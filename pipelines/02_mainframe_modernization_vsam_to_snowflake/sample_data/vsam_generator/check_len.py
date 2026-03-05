file_path = r".\customer_batch_0001.dat"

with open(file_path, "rb") as f:
    data = f.read()

print("Total bytes:", len(data))
print("Bytes mod 169:", len(data) % 169)
print("Record count (if clean):", len(data) // 169)
