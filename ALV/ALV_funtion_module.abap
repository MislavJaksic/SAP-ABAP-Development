*using this is not recommended. Use ALV_class instead
TYPES : BEGIN OF line_type,
          example TYPE example_type,
		  another_example TYPE another_example_type,
        END OF line_type.
DATA table TYPE TABLE OF line_type.

TYPE-POOLS: slis. "SLIS: Global types for generic list building blocks, holds flags that effect ALV
DATA field_catalog TYPE slis_t_fieldcat_alv.
DATA field_description LIKE LINE OF field_catalog.

START-OF-SELECTION.
PERFORM select_data.
PERFORM build_field_catalog.
PERFORM call_alv.

FORM select_data.
  SELECT *
  FROM db_table
  INTO CORRESPONDING FIELDS OF TABLE table.
    ENDFORM.

FORM build_field_catalog.
*structures's components need to be added to the field catalog
  TYPES: BEGIN OF field_desc,
	fieldname TYPE string,
	tabname TYPE string,
    END OF field_desc.

  DATA pair_table TYPE TABLE OF field_desc.
  DATA pair TYPE field_desc.

  pair-tabname = 'DB_TABLE'.
  pair-fieldname ='EXAMPLE_TYPE'.
  APPEND pair TO pair_table.
  pair-fieldname ='ANOTHER_EXAMPLE_TYPE'.
  APPEND pair TO pair_table.

  REFRESH field_catalog.
  LOOP AT pair_table INTO pair.
    CLEAR field_description.
    field_description-fieldname = pair-fieldname.
    field_description-ref_tabname = pair-tabname.
    APPEND field_description TO field_catalog.
    ENDLOOP.
ENDFORM.

FORM call_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
       EXPORTING
            it_fieldcat              = field_catalog "field catalog holds column information
       TABLES
            t_outtab                 = table "data to be displayed
       EXCEPTIONS
            program_error            = 1
            OTHERS                   = 2.
ENDFORM.