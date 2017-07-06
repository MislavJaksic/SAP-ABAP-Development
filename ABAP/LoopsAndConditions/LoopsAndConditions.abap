REPORT  LoopsAndCond.

DATA boolean TYPE i VALUE 0.
IF boolean = 1.
  ELSEIF boolean = 0.
    WRITE / 'Zero'.
    ENDIF.

WHILE boolean > 0.
  WRITE / 'I didn''t enter while'.
  ENDWHILE.

DO 5 TIMES.
  WRITE sy-index.
  ENDDO.

DO.
  sy-subrc = 5. "intentionally cause an error
  IF sy-subrc <> 0. "if there was en error
    EXIT. "exit endless loop
    ENDIF.
  ENDDO.