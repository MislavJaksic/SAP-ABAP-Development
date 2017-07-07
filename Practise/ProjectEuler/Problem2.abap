*Project Euler, Problem 2
*Given max_fib writes out the sum of all even
*fibonacci numbers that are less then max_fib
FORM even_fibonacci USING max_fib TYPE i.
  DATA n_minus_one TYPE i VALUE 1.
  DATA n_minus_two TYPE i VALUE 1.
  DATA fib TYPE i.
  DATA boolean_div TYPE i.
  DATA sum_of_even TYPE i.
  
  IF max_fib < 1.
    EXIT.
    ENFIF.

  DO.
    fib = n_minus_one + n_minus_two.
    IF fib > max_fib.
      EXIT.
    ENDIF.

    PERFORM is_div_by USING fib
                            2
                            boolean_div.
    IF boolean_div = 1.
      sum_of_even = sum_of_even + fib.
      ENDIF.
    n_minus_one = n_minus_two.
    n_minus_two = fib.
    ENDDO.

  WRITE / sum_of_even.
  WRITE 'is the sum of all even Fib numbers'.
  ENDFORM.
