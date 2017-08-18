REPORT  HashTable.

*Hash tables are a type of tables
TYPES: BEGIN OF columns,
         key_column TYPE i,
         value_column TYPE string,
       END OF columns.
DATA row TYPE columns.
DATA hash_table TYPE HASHED TABLE OF columns WITH UNIQUE KEY key_column.

*Cannot APPEND, only INSERT
row-key_column = 2.
row-value_column = 'Two'.
INSERT row INTO TABLE hash_table.  "|key|value|
row-key_column = 3.                "| 2 | Two |
row-value_column = 'Three'.        "| 3 |Three|
INSERT row INTO TABLE hash_table.

READ TABLE hash_table WITH TABLE KEY key_column = 2 INTO row.
WRITE / row-value_column. "-> Two

row-key_column = 3.                "|key|value|
row-value_column = 'Eeeee'.        "| 2 | Two |
MODIFY TABLE hash_table FROM row.  "| 3 |Eeeee|

DELETE TABLE hash_table WITH TABLE KEY key_column = 3.
