*Given table writes out the table
DATA integer_table TYPE STANDARD TABLE OF i.

FORM write_out_table USING table LIKE integer_table.
  DATA number TYPE i.
  LOOP AT table INTO number.
    WRITE number.
    ENDLOOP.
  ENDFORM.
