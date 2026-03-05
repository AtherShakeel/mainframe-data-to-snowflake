       01  MF-REC.
           05  REC-TYPE                  PIC X(1).
               88  HDR-REC-TYPE          VALUE 'H'.
               88  DTL-REC-TYPE          VALUE 'D'.
               88  TRL-REC-TYPE          VALUE 'T'.
           05  COMMON-AREA.
               10  FILE-DATE             PIC 9(8).
               10  BATCH-ID              PIC X(10).
           05  PAYLOAD                   PIC X(150).
           05  HDR-REC REDEFINES PAYLOAD.
               10  HDR-DESC              PIC X(29).
               10  SOURCE-SYS            PIC X(10).
               10  FILLER                PIC X(111).
           05  DTL-REC REDEFINES PAYLOAD.
               10  CUST-ID               PIC 9(5).
               10  CUST-NAME             PIC X(30).
               10  CUST-TYPE             PIC X(1).
               10  BALANCE               PIC S9(7)V99.
               10  PHONE-RAW             PIC X(10).
               10  PHONE-PARTS REDEFINES PHONE-RAW.
                   15  PHONE-AREA        PIC X(3).
                   15  PHONE-PFX         PIC X(3).
                   15  PHONE-LINE        PIC X(4).
               10  TXNS OCCURS 3 TIMES.
                   15  TRN-ID            PIC 9(6).
                   15  TRN-AMT           PIC S9(5)V99.
               10  STREET                PIC X(30).
               10  CITY                  PIC X(20).
               10  STATE                 PIC X(2).
               10  FILLER                PIC X(4).
           05  TRL-REC REDEFINES PAYLOAD.
               10  REC-COUNT             PIC 9(9).
               10  TOTAL-AMT             PIC S9(9)V99.
               10  FILLER                PIC X(130).
