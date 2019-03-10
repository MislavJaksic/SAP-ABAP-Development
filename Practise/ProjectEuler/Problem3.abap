*Project Euler, Problem 3
*Given a number returns a table of factors
DATA primes TYPE STANDARD TABLE OF i.

FORM number_to_primes USING value(number) TYPE p
                         table LIKE primes.
  DATA divisor TYPE i VALUE 2.
  DATA boolean_div TYPE i.
  WRITE / 'Prime factors of'.
  WRITE number.
  WRITE 'are:'.
  DO.
    IF divisor > number.
      EXIT.
      ENDIF.
    boolean_div = number MOD divisor.
    IF boolean_div = 0.
      APPEND divisor TO table.
      WRITE divisor.
      number = number / divisor.
    ELSE.
      divisor = divisor + 1.
      ENDIF.
    ENDDO.
  ENDFORM.
