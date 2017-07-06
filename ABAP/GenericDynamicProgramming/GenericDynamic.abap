REPORT  GenDynProg.

*Generic and dynamic programming
*Rule one: everything that is a literal (value) must be written in CAPITAL LETTERS

*Determine the data object's type the old fashioned way
DATA number TYPE p DECIMALS 3.
DATA t TYPE string.
DATA d TYPE string.
DESCRIBE FIELD number TYPE t DECIMALS d.
WRITE / t. "-> P
WRITE / d. "-> 3

*Determine the name of the structure with RTTS class cl_abap_typedescr:
*RTTI and RTTC methods are used to identify and create
data data_object type TEXT32.
DATA data_object_descriptor TYPE REF TO cl_abap_typedescr.
data data_object_name type string.
DATA structure TYPE vbak.
DATA structure_descriptor TYPE REF TO cl_abap_structdescr.
DATA structure_name TYPE string.

structure_descriptor ?= cl_abap_typedescr=>describe_by_data( structure ). "casting to access attribute components
structure_name = structure_descriptor->get_relative_name( ).
WRITE / structure_name. "-> VBAK

data_object_descriptor = cl_abap_typedescr=>describe_by_data( data_object ).
data_object_name = data_object_descriptor->get_relative_name( ).
write / data_object_name. "-> TEXT32

*Determine the name of structure's components, category, length and decimal places
DATA component TYPE abap_compdescr.
*Table type is abap_compdescr_tab, line type is abap_componentdescr or abap_compdescr depending on the version
LOOP AT structure_descriptor->components INTO component.
WRITE: / component-name,      "-> MANDT  VBELN
         component-type_kind, "-> C      C
         component-length,    "-> 6      20
         component-decimals.  "-> 0      0
IF component-name = 'VBELN'.
  EXIT.
  ENDIF.
ENDLOOP.

*Dynamically generate a structure
DATA new_structure TYPE REF TO data.
FIELD-SYMBOLS <symbol> TYPE data.
CREATE DATA new_structure TYPE (structure_name).
ASSIGN new_structure->* TO <symbol>.
*After dereferencing it can be accessed and manipluated
structure-erzet = '111111'.
MOVE-CORRESPONDING structure TO <symbol>.
FIELD-SYMBOLS <component> TYPE data.
ASSIGN COMPONENT 'ERZET' OF STRUCTURE <symbol> TO <component>.
WRITE / <component>. "-> 11:11:11