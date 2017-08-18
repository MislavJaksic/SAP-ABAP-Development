REPORT functions.
*In ABAP there are both subroutines and functions
*For modularization, there are also include programs, macros, global classes and function groups

DATA number TYPE i VALUE 5.
DATA str TYPE string VALUE 'String'.
PERFORM subroutine USING number
                         str.
WRITE number. "-> 5
WRITE str.    "-> Subroutine changed me.

*Function module
*Use the 'Pattern' button to fill in the function module call
DATA words TYPE spell.
CALL FUNCTION 'SPELL_AMOUNT' EXPORTING amount = 15      "what you give to the function module
                             IMPORTING in_words = words."what you get from the function module
WRITE / words-word. "-> FIFTEEN

FORM subroutine USING value(number) "pass by value
                CHANGING    str.    "pass by reference
  number = number DIV 2.
  str = 'Subroutine changed me.'.
  ENDFORM.
  
