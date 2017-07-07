*Project Euler, Problem 7
FORM find_nth_prime USING n TYPE i.
  DATA prime_counter TYPE i VALUE 0.
  DATA number TYPE p VALUE 0.
  DATA boolean_prime TYPE i.
  DO.
    number = sy-index.
    boolean_prime = 0.
    PERFORM is_prime USING number
                           boolean_prime.
    IF boolean_prime = 1.
      prime_counter = prime_counter + 1.
      ENDIF.
    IF prime_counter = n.
      WRITE / 'The'.
      WRITE n.
      WRITE 'th prime number is:'.
      WRITE number.
      EXIT.
      ENDIF.
    ENDDO.
  ENDFORM.
