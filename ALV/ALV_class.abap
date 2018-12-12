*recommended way of displaying an ALV grid:
TYPES : BEGIN OF line_type,
          example TYPE example_type,
        END OF line_type.
DATA line TYPE line_type.
DATA table TYPE STANDARD TABLE OF line_type.
DATA alv_object TYPE REF TO cl_salv_table.
DATA alv_functions TYPE REF TO cl_salv_functions_list.
DATA alv_columns TYPE REF TO cl_salv_columns_table.

START-OF-SELECTION.
  SELECT *
    FROM db_table
    INTO CORRESPONDING FIELDS OF TABLE table
    UP TO 15 ROWS.
  TRY.
    CALL METHOD cl_salv_table=>factory IMPORTING r_salv_table = alv_object "instantiate object with the table
                                       CHANGING  t_table  = table.
    CATCH cx_salv_msg.
  ENDTRY.
  alv_columns = alv_object->get_columns( ).
  alv_columns->set_optimize( ). "optimize column width
  alv_functions = alv_object->get_functions( ). "provide access to LAV functions
  alv_functions->set_all( ). "sets all the functions
  CALL METHOD alv_object->display.