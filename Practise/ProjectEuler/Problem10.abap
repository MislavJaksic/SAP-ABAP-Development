*Write out the sum all primes from 2 to max_number
*Project Euler, Problem 10
FORM sum_primes USING max_number TYPE i.
  DATA number TYPE p.
  DATA boolean_prime TYPE i.
  DATA sum_primes TYPE p.
  DO max_number TIMES.
    number = sy-index.
    PERFORM is_prime USING number
                           boolean_prime.
    IF boolean_prime = 1.
      sum_primes = sum_primes + number.
      ENDIF.
  ENDDO.
  WRITE / sum_primes.
  ENDFORM.
