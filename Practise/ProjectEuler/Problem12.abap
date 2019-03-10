*Project Euler, Problem 12, extremly slow!
FORM find_triangle_number USING num_of_divisors TYPE i
                                start_from TYPE i.
  DATA triangle_number TYPE p VALUE 0.
  DATA adder TYPE i VALUE 1.
  DATA counter TYPE i.
  DATA boolean TYPE i.
  DATA count_divisors TYPE i.
  DATA divisors TYPE STANDARD TABLE OF i.

  IF start_from > 0.
    DO.
      triangle_number = triangle_number + adder.
      adder = adder + 1.
      if triangle_number = start_from.
        exit.
        endif.
      ENDDO.
    WRITE 'Started from:'.
    WRITE / triangle_number.
    ENDIF.

  DO.
    triangle_number = triangle_number + adder.
    adder = adder + 1.

    count_divisors = 0.
    CLEAR divisors.
    DO triangle_number TIMES.
      counter = sy-index.
      boolean = triangle_number MOD counter.

      IF boolean = 0.
        count_divisors = count_divisors + 1.
        APPEND counter TO divisors.
        ENDIF.
      ENDDO.

    IF count_divisors >= num_of_divisors.
      EXIT.
      ENDIF.
    ENDDO.
  WRITE / triangle_number.
  LOOP AT divisors INTO count_divisors.
    WRITE count_divisors.
    ENDLOOP.

  ENDFORM.
