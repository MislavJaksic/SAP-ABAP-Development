REPORT  HashTable.

*Hash tables are a special kind of internal tables
TYPES: BEGIN OF columns,
         key_column TYPE i,
         data_column TYPE string,
       END OF columns.
DATA row TYPE columns.

DATA hash_table TYPE HASHED TABLE OF columns WITH UNIQUE KEY key_column.

*Cannot APPEND, only INSERT
row-key_column = 2.
row-data_column = 'Two'.
INSERT row INTO TABLE hash_table.
row-key_column = 3.
row-data_column = 'Three'.
INSERT row INTO TABLE hash_table.

READ TABLE hash_table WITH TABLE KEY key_column = 2 INTO row.
WRITE / row-data_column. "-> Two

row-key_column = 3.
row-data_column = 'Threeeeee'.
MODIFY TABLE hash_table WITH row.
READ TABLE hash_table WITH TABLE KEY key_column = 3 INTO row.
WRITE / row-data_column. "-> Threeeeee
