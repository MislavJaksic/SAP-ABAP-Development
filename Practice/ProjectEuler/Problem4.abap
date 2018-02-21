*Project Euler, Problem 4, the most complex and interesting so far
*Given digits writes out the largest palindrome number
*that is a product of two digits digit numbers
*Solved in O(n) time
*1 digit product table where element the 1. is the largest product
*2. is the second largest and so on. The same pattern holds true
*for higher digit product tables
*  9  8  7  6  5  4 : i-nner
*9 1. 2. 4. 6. 9.
*8    3. 5. 8.
*7       7. ...
*:
*o-uter
FORM largest_palindrome_product USING digits TYPE i.
  IF digits < 1.
    WRITE / 'Too few digits'.
    EXIT.
    ENDIF.

  DATA minimum TYPE i VALUE 1.
  DATA maximum TYPE i VALUE 1.
  DO digits TIMES.
    maximum = maximum * 10.
    ENDDO.
  maximum = maximum - 1.

  digits = digits - 1.
  DO digits TIMES.
    minimum = minimum * 10.
    ENDDO.

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
