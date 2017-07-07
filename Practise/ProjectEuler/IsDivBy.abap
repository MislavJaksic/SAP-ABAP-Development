FORM is_div_by USING number TYPE i
                     div_by_number TYPE i
                     boolean_div TYPE i.
  DATA boolean TYPE i.
  boolean = number MOD div_by_number.
  boolean_div = 0.
  IF boolean = 0.
    boolean_div = 1.
    ENDIF.
  ENDFORM.
