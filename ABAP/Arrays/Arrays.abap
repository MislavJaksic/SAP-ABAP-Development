*Tables are very similar to arrays, but they can be thought of as database tables
*Internal tables
DATA internal_table TYPE STANDARD TABLE OF i.
*Fill table with data
DATA integer TYPE i VALUE 2.
DATA exp TYPE i.
DO 4 TIMES.
  exp = integer ** sy-index.
  APPEND exp TO internal_table.
  ENDDO.

*Table indexes start from 1, not 0
READ TABLE internal_table INDEX -1 INTO integer.
WRITE / sy-tabix. "-> 0
WRITE / integer. "-> 2
READ TABLE internal_table INDEX 0 INTO integer.
WRITE / sy-tabix. "-> 0
WRITE / integer. "-> 2
READ TABLE internal_table INDEX 1 INTO integer.
WRITE / sy-tabix. "-> 1
WRITE / integer. "-> 2
READ TABLE internal_table INDEX 2 INTO integer.
WRITE / sy-tabix. "-> 2
WRITE / integer. "-> 4

LOOP AT internal_table INTO integer.
  WRITE / 'Table line:'.
  WRITE sy-tabix. "-> 1 2 3  4
  WRITE 'Number:'.
  WRITE integer. " -> 2 4 8 16
  ENDLOOP.

integer = 7.
INSERT integer  INTO internal_table INDEX 2.
DELETE internal_table INDEX 3.
integer = 5.
MODIFY internal_table FROM integer INDEX 1.

LOOP AT internal_table INTO integer.
  WRITE / 'Table line:'.
  WRITE sy-tabix. "-> 1 2 3  4
  WRITE 'Number:'.
  WRITE integer. " -> 5 7 8 16
  ENDLOOP.

SORT internal_table.
CLEAR internal_table.