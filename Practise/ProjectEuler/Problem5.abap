*Project Euler, Problem 5
FORM evenly_divisible USING max TYPE i.
  DATA number_constructor TYPE HASHED TABLE OF key_value WITH UNIQUE KEY key.
  DATA count_table TYPE HASHED TABLE OF key_value WITH UNIQUE KEY key.
  DATA primes TYPE STANDARD TABLE OF i.

  DATA prime TYPE i.
  DATA number TYPE p.
  DATA count_entry TYPE key_value.
  DATA constructor_entry TYPE key_value.
  DO max TIMES.
    number = sy-index.
    IF number = 1.
      CONTINUE.
      ENDIF.
    CLEAR primes.
    PERFORM number_to_primes USING number
                                primes.
    CLEAR count_table.
    PERFORM make_integer_count_table USING primes
                                        count_table.
    LOOP AT count_table INTO count_entry.
      READ TABLE number_constructor WITH TABLE KEY key = count_entry-key INTO constructor_entry.
      IF sy-subrc = 4.
        INSERT count_entry INTO TABLE number_constructor.
        ELSEIF count_entry-value > constructor_entry-value.
          MODIFY TABLE number_constructor FROM count_entry.
        ENDIF.
      ENDLOOP.
    ENDDO.
  WRITE / 'Contents of number_constructor:'.
  LOOP AT number_constructor INTO constructor_entry.
    WRITE / 'Key:'.
    WRITE constructor_entry-key.
    WRITE 'Value:'.
    WRITE constructor_entry-value.
    ENDLOOP.
  ENDFORM.
