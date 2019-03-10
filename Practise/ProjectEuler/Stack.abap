*Stack data structure implementation
*Can only accept integers
*Use push to put the data on top, pop to get data from the top
*Use top to check what number is on top of the stack
*If an operation cannot be executed, a sentinel value is returned
CLASS stack DEFINITION.
  PUBLIC SECTION.
  METHODS: pop RETURNING value(ret_number) TYPE i,
           push IMPORTING value(im_number) TYPE i,
           top RETURNING value(ret_number) TYPE i.
  CLASS-DATA sentinel TYPE i VALUE -999.

  PRIVATE SECTION.
  METHODS: is_empty RETURNING value(ret_boolean) TYPE i.
  DATA array TYPE STANDARD TABLE OF i.
  DATA stack_top_index TYPE i VALUE 0.
  ENDCLASS.

CLASS stack IMPLEMENTATION.
  METHOD is_empty.
    ret_boolean = 0.
    IF stack_top_index = 0.
      ret_boolean = 1.
      ENDIF.
    ENDMETHOD.

  METHOD pop.
    IF is_empty( ) = 0.
      READ TABLE array INDEX stack_top_index INTO ret_number.
      DELETE array INDEX stack_top_index.
      stack_top_index = stack_top_index - 1.
      ELSE.
        ret_number = sentinel.
      ENDIF.
    ENDMETHOD.

  METHOD push.
    APPEND im_number TO array.
    stack_top_index = stack_top_index + 1.
    ENDMETHOD.

  METHOD top.
    IF is_empty( ) = 0.
    READ TABLE array INDEX stack_top_index INTO ret_number.
    ELSE.
      ret_number = sentinel.
    ENDIF.
    ENDMETHOD.
  ENDCLASS.
