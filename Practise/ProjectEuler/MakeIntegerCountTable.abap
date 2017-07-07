TYPES: BEGIN OF key_value,
           key TYPE i,
           value TYPE i,
         END OF key_value.
DATA count_table TYPE HASHED TABLE OF key_value WITH UNIQUE KEY key.

FORM make_integer_count_table USING table LIKE primes
                                   count_table LIKE count_table.
  DATA number TYPE i.
  DATA entry TYPE key_value.
  DATA boolean_not_in_table TYPE i.
  LOOP AT table INTO number.
    READ TABLE count_table WITH TABLE KEY key = number INTO entry.

    boolean_not_in_table = 0.
    IF sy-subrc = 4.
      boolean_not_in_table = 1.
      ENDIF.
    IF boolean_not_in_table = 1.
      entry-key = number.
      entry-value = 1.
      INSERT entry INTO TABLE count_table.
      ELSE.
        entry-value = entry-value + 1.
        MODIFY TABLE count_table FROM entry.
        ENDIF.
    ENDLOOP.
  ENDFORM.
