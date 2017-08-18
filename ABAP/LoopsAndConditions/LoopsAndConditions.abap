REPORT  LoopsAndCond.

DATA boolean TYPE i VALUE 0.
IF boolean <> 0. "not equal
  ELSEIF boolean = 0.
    WRITE / 'Zero'. "-> Zero
    ENDIF.

WHILE boolean > 0 OR boolean > 0.
  WRITE / 'I didn''t enter WHILE'.
  ENDWHILE.

DO 5 TIMES.
  WRITE sy-index. "-> 1 2 3 4 5
  ENDDO.

DO.
  sy-subrc = 5.     "intentionally cause an error
  IF sy-subrc <> 0. "if there was en error
    EXIT.           "exit endless loop
    ENDIF.
  ENDDO.

DATA int_tab TYPE STANDARD TABLE OF i.
DATA int TYPE i.
LOOP AT int_tab INTO int. "table loop
  WRITE int.
  ENDLOOP.
  
