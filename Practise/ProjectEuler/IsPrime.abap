*Given a number returns 1 if the number is prime
*and 0 if it is not
*Very slow, but memory efficient
FORM is_prime USING value(number) TYPE p
                    boolean_prime TYPE i.
  DATA divider TYPE i VALUE 4.
  DATA boolean_div TYPE i.
  DATA root TYPE f.
  boolean_prime = 1.
  root = SQRT( number ).
  DO.
    IF number <= 1.
      boolean_prime = 0.
      EXIT.
      ENDIF.
    IF number <= 3.
      EXIT.
      ENDIF.
    IF divider >= root.
      EXIT.
      ENDIF.
    boolean_div = number MOD divider.
    IF boolean_div = 0.
      boolean_prime = 0.
      EXIT.
    ELSE.
      divider = divider + 1.
      ENDIF.
    ENDDO.
  ENDFORM.
