*Project Euler, Problem 8
*Given n_of_adjacent and huge_number writes out the largest product of
*n_of_adjacent adjacent digits in a huge_number
FORM max_adjacent_digits_product USING n_of_adjacent TYPE i
                                       huge_number TYPE string.
  DATA length TYPE i.
  length = STRLEN( huge_number ).
  IF n_of_adjacent > length.
    EXIT.
    ENDIF.

  DATA adjacency_table TYPE STANDARD TABLE OF i.
  DATA digit TYPE i.
  DATA index TYPE i.
  DATA adjacency TYPE i.
  DATA max_adjacency TYPE i.
  DATA initial_size TYPE i.
  initial_size = n_of_adjacent - 1.
  DO.
    index = sy-index - 1.
    IF index >= length.
      EXIT.
      ENDIF.
    digit = huge_number+index(1).
    APPEND digit TO adjacency_table.
    IF index < initial_size.
      CONTINUE.
      ENDIF.
    adjacency = 1.
    LOOP AT adjacency_table INTO digit.
      adjacency = adjacency * digit.
      ENDLOOP.
    IF adjacency > max_adjacency.
      max_adjacency = adjacency.
      ELSE.
      ENDIF.
    DELETE adjacency_table INDEX 1.
    ENDDO.
  WRITE max_adjacency.
  ENDFORM.
