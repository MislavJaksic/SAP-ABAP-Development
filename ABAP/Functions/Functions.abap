*Code structure: subroutines (FORM),
*                local and global classes,
*                function groups hold function modules,
*                includes (INCLUDE).

PERFORM subroutine. "-> subroutine

*Use the 'Pattern' button to fill in the function call
DATA words TYPE spell.
CALL FUNCTION 'SPELL_AMOUNT' EXPORTING amount = 15      "what you give to the function module
                             IMPORTING in_words = words."what you get from the function module
WRITE / words-word. "-> FIFTEEN

FORM subroutine.
  WRITE 'subroutine'.
  ENDFORM.