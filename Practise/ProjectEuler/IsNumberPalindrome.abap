FORM is_number_palindrome USING value(palindrome_candidate) TYPE i
                                boolean_palindrome TYPE i.
  DATA digit_stack TYPE REF TO stack.
  CREATE OBJECT digit_stack TYPE stack.

  DATA number TYPE i.
  number = palindrome_candidate.

  DATA float_digits TYPE f.
  DATA digits TYPE i.
  DATA half_digits TYPE i.
  float_digits = LOG10( palindrome_candidate ).
  float_digits = FLOOR( float_digits ).
  digits = float_digits + 1.
  half_digits = digits DIV 2.

  DO half_digits TIMES.
    DATA num_digit TYPE i.
    num_digit = palindrome_candidate MOD 10.
    CALL METHOD digit_stack->push EXPORTING im_number = num_digit.
    palindrome_candidate = palindrome_candidate DIV 10.
    ENDDO.

  DATA boolean_odd TYPE i.
  boolean_odd = digits MOD 2.
  IF boolean_odd = 1.
    palindrome_candidate = palindrome_candidate  DIV 10.
    ENDIF.

  boolean_palindrome = 1.
  DATA stack_digit TYPE i.
  DO half_digits TIMES.
    CALL METHOD digit_stack->pop RECEIVING ret_number = stack_digit.
    num_digit = palindrome_candidate MOD 10.
    palindrome_candidate = palindrome_candidate DIV 10.
    IF stack_digit <> num_digit.
      WRITE / number.
      WRITE 'is not a palindrome!'.
      boolean_palindrome = 0.
      EXIT.
      ENDIF.
    ENDDO.
  IF boolean_palindrome = 1.
    WRITE / number.
    WRITE 'is a palindrome!'.
    ENDIF.
  ENDFORM.
