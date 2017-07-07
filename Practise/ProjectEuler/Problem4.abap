*Project Euler, Problem 4, the most complex and interesting so far
*solved in O(n) time
FORM largest_palindrome_product USING digit_number TYPE i.
  IF digit_number < 1.
    WRITE / 'Too few digits'.
    EXIT.
    ENDIF.

  DATA minimum TYPE i VALUE 1.
  DATA maximum TYPE i VALUE 1.

  DO digit_number TIMES.
    maximum = maximum * 10.
    ENDDO.
  maximum = maximum - 1.

  digit_number = digit_number - 1.
  DO digit_number TIMES.
    minimum = minimum * 10.
    ENDDO.

  WRITE / 'Maximum product number:'.
  WRITE maximum.
  WRITE / 'Minimum product number:'.
  WRITE minimum.

  DATA o_reset TYPE i.
  DATA i_reset TYPE i.
  DATA o TYPE i.
  DATA i TYPE i.
  o_reset = i_reset = o = i = maximum.

  DATA n TYPE i VALUE 0.
  DATA i_condition TYPE i.

  DATA palindrome_candidate TYPE i VALUE 1.
  DATA largest_palindrome TYPE i VALUE 1.
  DATA boolean_palindrome TYPE i.
  DATA boolean_div TYPE i.

  DO.
    i = i_reset.

    i_condition = maximum - n.
    WHILE i >= i_condition.
      palindrome_candidate = i * o.
      PERFORM is_number_palindrome USING palindrome_candidate
                                         boolean_palindrome.
      WRITE / 'Outer:'.
      WRITE o.
      WRITE 'Inner:'.
      WRITE i.
      i = i - 1.
      o = o + 1.

      IF boolean_palindrome = 1.
        WRITE / 'Found the largest palindrome!'.
        WRITE palindrome_candidate.
        largest_palindrome = palindrome_candidate.
        EXIT.
        ENDIF.
      ENDWHILE.

    n = n + 1.
    PERFORM is_div_by USING n
                            2
                            boolean_div.
    IF boolean_div = 0.
      i_reset = i_reset - 1.
      ELSE.
        o_reset = o_reset - 1.
      ENDIF.

    o = o_reset.

    IF largest_palindrome > 1.
      EXIT.
      ENDIF.
    ENDDO.

ENDFORM.
