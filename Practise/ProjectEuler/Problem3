*Project Euler, Problem 3
DATA primes TYPE STANDARD TABLE OF i.
FORM number_to_primes USING value(number) TYPE p
                         table LIKE primes.
  DATA divider TYPE i VALUE 2.
  DATA boolean_div TYPE i.
  WRITE / 'Prime factors of'.
  WRITE number.
  WRITE 'are:'.
  DO.
    IF divider > number.
      EXIT.
      ENDIF.
    boolean_div = number MOD divider.
    IF boolean_div = 0.
      APPEND divider TO table.
      WRITE divider.
      number = number / divider.
    ELSE.
      divider = divider + 1.
      ENDIF.
    ENDDO.
  ENDFORM.
