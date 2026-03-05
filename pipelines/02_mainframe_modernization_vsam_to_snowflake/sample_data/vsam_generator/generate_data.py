from __future__ import annotations
from decimal import Decimal, ROUND_HALF_UP
from typing import List, Tuple

FILE_NAME = "CUSTOMERS_BAT_US_004_20260307.dat"
FILE_DATE = "20260307"        # PIC 9(8)
BATCH_ID  = "BAT_US_004"      # PIC X(10)
DETAIL_COUNT = 20

US_ADDR: List[Tuple[str, str, str]] = [
    ("350 5th Ave", "NEW YORK", "NY"),
    ("1600 Amphitheatre Pkwy", "MOUNTAIN VIEW", "CA"),
    ("233 S Wacker Dr", "CHICAGO", "IL"),
    ("301 S Tryon St", "CHARLOTTE", "NC"),
    ("1000 Elysian Park Ave", "LOS ANGELES", "CA"),
    ("1200 Post Oak Blvd", "HOUSTON", "TX"),
    ("1010 Museum Way", "MIAMI", "FL"),
    ("2101 4th Ave", "SEATTLE", "WA"),
    ("1701 JFK Blvd", "PHILADELPHIA", "PA"),
    ("1515 Broadway", "NEW YORK", "NY"),
    ("1 Microsoft Way", "REDMOND", "WA"),
    ("11 Wall St", "NEW YORK", "NY"),
    ("500 S Buena Vista St", "BURBANK", "CA"),
    ("700 Exposition Park Dr", "LOS ANGELES", "CA"),
    ("600 Montgomery St", "SAN FRANCISCO", "CA"),
    ("200 Santa Monica Pier", "SANTA MONICA", "CA"),
    ("600 Biscayne Blvd", "MIAMI", "FL"),
    ("401 Pine St", "SEATTLE", "WA"),
    ("555 California St", "SAN FRANCISCO", "CA"),
    ("1 E 161st St", "BRONX", "NY"),
]

def rpad(s: str, length: int, pad: str = " ") -> str:
    s = s if s is not None else ""
    return (s[:length]).ljust(length, pad)

def zpad_num(n: int, length: int) -> str:
    return str(n).zfill(length)[-length:]

# COBOL DISPLAY signed numeric usually uses "overpunch" in the last digit
_POS_OVERPUNCH = {
    "0": "{", "1": "A", "2": "B", "3": "C", "4": "D",
    "5": "E", "6": "F", "7": "G", "8": "H", "9": "I",
}
_NEG_OVERPUNCH = {
    "0": "}", "1": "J", "2": "K", "3": "L", "4": "M",
    "5": "N", "6": "O", "7": "P", "8": "Q", "9": "R",
}

def fmt_s9_v99_overpunch(value: float | Decimal, int_digits: int) -> str:
    """
    Format PIC S9(int_digits)V99 as DISPLAY with trailing overpunch sign.
    Total length = int_digits + 2  (NO extra sign char)
    Example S9(7)V99 -> length 9
    """
    d = Decimal(str(value)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    neg = d < 0
    d_abs = abs(d)

    scaled = int((d_abs * 100).to_integral_value(rounding=ROUND_HALF_UP))
    width = int_digits + 2  # no sign char
    digits = str(scaled).zfill(width)[-width:]  # exactly width digits

    last = digits[-1]
    over = _NEG_OVERPUNCH[last] if neg else _POS_OVERPUNCH[last]
    return digits[:-1] + over

def build_header_record(file_date: str, batch_id: str) -> bytes:
    rec_type = "H"
    hdr_desc = rpad("US-CUSTOMER-MIGRATION-BATCH", 29)
    source_sys = rpad("MAINFRAME", 10)
    filler = " " * 111
    payload = hdr_desc + source_sys + filler
    assert len(payload) == 150
    record = rec_type + file_date + rpad(batch_id, 10) + payload
    assert len(record) == 169
    return record.encode("ascii", errors="strict")

def build_detail_record(i: int, file_date: str, batch_id: str, addr: str, city: str, state: str) -> bytes:
    rec_type = "D"
    cust_id = zpad_num(20000 + i, 5)
    cust_name = rpad(f"CUSTOMER-NAME-{i}", 30)
    cust_type = "P" if i % 2 == 0 else "C"

    balance_val = Decimal("1250.75") * Decimal(i)
    balance = fmt_s9_v99_overpunch(balance_val, int_digits=7)  # length 9

    phone = f"212555{str(i).zfill(4)}"  # 10 chars

    # 3 TXNs
    txns = ""
    for t in range(1, 4):
        trn_id = zpad_num(int(f"{i}{t}"), 6)
        trn_amt_val = Decimal("50.00") * Decimal(t)
        trn_amt = fmt_s9_v99_overpunch(trn_amt_val, int_digits=5)  # length 7
        txns += trn_id + trn_amt
    assert len(txns) == 3 * (6 + 7)  # 39

    street = rpad(addr, 30)
    city_f = rpad(city, 20)
    state_f = rpad(state, 2)
    filler = " " * 4

    payload = (
        cust_id +            # 5
        cust_name +          # 30
        cust_type +          # 1
        balance +            # 9
        rpad(phone, 10) +    # 10
        txns +               # 39
        street +             # 30
        city_f +             # 20
        state_f +            # 2
        filler               # 4
    )
    assert len(payload) == 150, f"DTL payload len={len(payload)}"

    record = rec_type + file_date + rpad(batch_id, 10) + payload
    assert len(record) == 169
    return record.encode("ascii", errors="strict")

def build_trailer_record(file_date: str, batch_id: str, rec_count: int, total_amt: Decimal) -> bytes:
    rec_type = "T"
    rec_count_str = zpad_num(rec_count, 9)

    # S9(9)V99 => length 11
    total_amt_str = fmt_s9_v99_overpunch(total_amt, int_digits=9)

    filler = " " * 130
    payload = rec_count_str + total_amt_str + filler
    assert len(payload) == 150, f"TRL payload len={len(payload)}"

    record = rec_type + file_date + rpad(batch_id, 10) + payload
    assert len(record) == 169
    return record.encode("ascii", errors="strict")

def main() -> None:
    total_balance = Decimal("0.00")

    with open(FILE_NAME, "wb") as f:
        f.write(build_header_record(FILE_DATE, BATCH_ID))

        for i in range(1, DETAIL_COUNT + 1):
            addr, city, state = US_ADDR[(i - 1) % len(US_ADDR)]
            bal = Decimal("1250.75") * Decimal(i)
            total_balance += bal
            f.write(build_detail_record(i, FILE_DATE, BATCH_ID, addr, city, state))

        f.write(build_trailer_record(FILE_DATE, BATCH_ID, DETAIL_COUNT, total_balance))

    print(f"Success! '{FILE_NAME}' generated.")
    print(f"Records: {DETAIL_COUNT + 2} (1 header + {DETAIL_COUNT} detail + 1 trailer)")
    print("Record length: 169 bytes (no newlines)")

    # quick sanity check
    with open(FILE_NAME, "rb") as f:
        data = f.read()
    print("Total bytes:", len(data))
    print("Bytes mod 169:", len(data) % 169)

if __name__ == "__main__":
    main()
