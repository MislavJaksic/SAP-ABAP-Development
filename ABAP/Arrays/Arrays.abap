*Tables are two dimensional arrays, but they can be reduced to a single dimension if
*the table has only one column

DATA int_table TYPE STANDARD TABLE OF i.

DATA integer TYPE i VALUE 2.
DATA exp TYPE i.
DO 4 TIMES. "Fill the table with numbers   "|index|value|
  exp = integer ** sy-index.               "|  1  |  2  |
  APPEND exp TO int_table.                 "|  2  |  4  |
  ENDDO.                                   "|  3  |  8  |
                                           "|  4  |  16 |
                                           
*Table indexes less then one get converted to 1
READ TABLE int_table INDEX -1 INTO integer.
WRITE / sy-tabix. "-> 0
WRITE / integer. "-> 2
READ TABLE int_table INDEX 0 INTO integer.
WRITE / sy-tabix. "-> 0
WRITE / integer. "-> 2
READ TABLE int_table INDEX 1 INTO integer.
WRITE / sy-tabix. "-> 1
WRITE / integer. "-> 2
READ TABLE int_table INDEX 2 INTO integer.
WRITE / sy-tabix. "-> 2
WRITE / integer. "-> 4                   "|index|value|
                                         "|  1  |  2  |      
integer = 7.                             "|  2  |  7  |
INSERT integer INTO int_table INDEX 2.   "|  3  |  4  |
                                         "|  4  |  8  |
                                         "|  5  |  16 |
                                     
                                         "|index|value|   
                                         "|  1  |  2  |
DELETE int_table INDEX 3.                "|  2  |  7  |
                                         "|  3  |  8  |
                                         "|  4  |  16 |
                                     
                                         "|index|value|
integer = 5.                             "|  1  |  2  |
MODIFY int_table FROM integer INDEX 4.   "|  2  |  7  |
                                         "|  3  |  8  |
                                         "|  4  |  5  |
SORT table.

LOOP AT int_table INTO integer.
  WRITE sy-tabix. "-> 1 2 3 4
  WRITE integer. " -> 2 5 7 8
  ENDLOOP.

CLEAR int_table. "deletes all table rows
