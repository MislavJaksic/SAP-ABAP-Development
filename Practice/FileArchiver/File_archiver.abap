*&---------------------------------------------------------------------*
*& Report  Z_FILE_ARCHIVER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_file_archiver.

*----------------------------------------------------------------------*
*       CLASS file_archiver DEFINITION
*----------------------------------------------------------------------*
* USE: copy every file's data into a directory, perform a function on
*      it and delete the original files
* DESIGN NOTE: if a file already exists at the destination, the data
*              will be appended. This shouldn't occure as file names
*              should be unique
*----------------------------------------------------------------------*
CLASS file_archiver DEFINITION.
  PUBLIC SECTION.
    METHODS:
    find_and_transfer_files IMPORTING im_input_dir TYPE string
                           im_output_dir TYPE string.
  PRIVATE SECTION.
    METHODS:
    find_files EXPORTING ex_file_names TYPE STANDARD TABLE,
    is_file IMPORTING im_file_name TYPE text32
            RETURNING VALUE(ret_boolean_is_file) TYPE i,
    transfer_files IMPORTING im_file_names TYPE STANDARD TABLE,
    construct_file_paths IMPORTING im_file_name TYPE text32
                    EXPORTING ex_input_file_path TYPE string
                              ex_output_file_path TYPE string,
    copy_line IMPORTING im_text_line TYPE string
                        im_output_file_path TYPE string,
    delete_input_file IMPORTING im_input_file_path TYPE string.
    DATA: input_dir  TYPE string,
          output_dir TYPE string.
ENDCLASS.                    "file_archivist DEFINITION

*----------------------------------------------------------------------*
*       CLASS file_rules DEFINITION
*----------------------------------------------------------------------*
* USE: determine if a directory is a file
* DESIGN NOTE: rules for checking if a directory is a file has been
*              seperated from the rest of the logic to allow for greater
*              program flexibility
*----------------------------------------------------------------------*
CLASS file_rules DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
    check_rules IMPORTING im_file_name TYPE text32
                RETURNING value(ret_boolean_satisfies_rules) TYPE i.
  PRIVATE SECTION.
    CLASS-METHODS:
    is_txt RETURNING value(ret_boolean_is_text) TYPE i.


    CLASS-DATA file_name TYPE text32.
ENDCLASS.                    "file_rules DEFINITION

*----------------------------------------------------------------------*
*       CLASS function_wrapper DEFINITION
*----------------------------------------------------------------------*
* USE: wraps a function that the move_and_process object will execute on
*      data
* DESIGN NOTE: this wrapper adds higher order function capabilities to
*              ABAP
*----------------------------------------------------------------------*
CLASS function_wrapper DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      function.
    CLASS-DATA execute_function TYPE string.
ENDCLASS.

CLASS file_archivist IMPLEMENTATION.

  METHOD find_and_transfer_files.
*IMPORTING: im_input_dir, im_output_dir
    input_dir = im_input_dir.
    output_dir = im_output_dir.
    DATA file_names TYPE STANDARD TABLE OF text32.
    CALL METHOD find_files IMPORTING ex_file_names = file_names.
    CALL METHOD transfer_files EXPORTING im_file_names = file_names.
  ENDMETHOD.                    "find_and_transfer_files

  METHOD find_files.
*EXPORTING: ex_file_names
*get all the names of the subdirectories in the input directory
    DATA directories TYPE TABLE OF salfldir.
    CALL FUNCTION 'RZL_READ_DIR' EXPORTING name     = input_dir
                                 TABLES    file_tbl = directories.
*check if the subdirectory is a file
    DATA directory TYPE salfldir.
    LOOP AT directories INTO directory.
      IF is_file( directory-name ) = 1.
        APPEND directory-name TO ex_file_names.
      ELSE.
        WRITE / directory-name.
        WRITE 'is not a file (according to the file_rules).'.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.                    "find_files

  METHOD is_file.
*RETURNING: ret_boolean_is_file
    ret_boolean_is_file = file_rules=>check_rules( im_file_name ).
  ENDMETHOD.                    "is_file

  METHOD transfer_files.
*IMPORTING: im_file_names
    DATA file_name TYPE text32.
    LOOP AT im_file_names INTO file_name.
      WRITE / 'Reading file'.
      WRITE file_name.

*construct the file paths with the pattern: dir1/dir2/file1.txt
      DATA input_file_path TYPE string.
      DATA output_file_path TYPE string.
      CALL METHOD construct_file_paths EXPORTING im_file_name = file_name
                                       IMPORTING ex_input_file_path = input_file_path
                                                 ex_output_file_path = output_file_path.
*open the file and extract data from it, line by line
      OPEN DATASET input_file_path FOR INPUT IN TEXT MODE ENCODING UTF-8.
*if the file already exists in the output directory, append lines to it
*if the file doesen't exist, it will be crated
      OPEN DATASET output_file_path FOR APPENDING IN TEXT MODE ENCODING UTF-8.
      DATA text_line TYPE string.
      DO.
        READ DATASET input_file_path INTO text_line.
*the end of file was reached if READ DATASET returns 4 in subrc
        IF sy-subrc = 4.
          EXIT.
        ENDIF.

        CALL METHOD function_wrapper=>(function_wrapper=>execute_function).
        CALL METHOD copy_line EXPORTING im_text_line = text_line
                                        im_output_file_path = output_file_path.
      ENDDO.

      CLOSE DATASET output_file_path.
      CLOSE DATASET input_file_path.
      WRITE / 'Transfer of'.
      WRITE input_file_path.
      WRITE 'to'.
      WRITE output_file_path.
      WRITE 'complete.'.

*deactivate DELETE during testing and development
*CALL METHOD delete_input_file EXPORTING im_input_file_path = input_file_path.
    ENDLOOP.
  ENDMETHOD.                    "read_file

  METHOD construct_file_paths.
*IMPORTING: im_file_name
*EXPORTING: ex_input_file_path, ex_output_file_path
    CONCATENATE input_dir '/' im_file_name INTO ex_input_file_path.
    CONCATENATE output_dir '/' im_file_name INTO ex_output_file_path.
ENDMETHOD.

  METHOD copy_line.
*IMPORTING: im_text_line, im_output_file_path
    TRANSFER im_text_line TO im_output_file_path.
  ENDMETHOD.                    "copy_line

  METHOD delete_input_file.
*IMPORTING: im_input_file_path
    DELETE DATASET im_input_file_path.

    WRITE / 'Input file'.
    WRITE im_input_file_path.
    WRITE 'deleted'.
  ENDMETHOD.

ENDCLASS.                    "file_archivist IMPLEMENTATION

CLASS file_rules IMPLEMENTATION.

  METHOD check_rules.
*RETURNING: ret_boolean_satisfies_rules
    file_name = im_file_name.
*logic that determines which subdirectory is a file
    ret_boolean_satisfies_rules = 0.
    IF file_rules=>is_txt( ) = 1.
      ret_boolean_satisfies_rules = 1.
    ENDIF.
  ENDMETHOD.                    "check_rules

  METHOD is_txt.
*RETURNING: ret_boolean_is_text
*compare the last x characters to a string value of length x
    CONSTANTS x_last_chars         TYPE i VALUE 4.
    CONSTANTS txt_extension TYPE string VALUE '.txt'.
    DATA:     file_name_last_chars TYPE string,
              file_name_length     TYPE i,
              file_name_offset     TYPE i.

    ret_boolean_is_text = 0.
    file_name_length = STRLEN( file_name ).
    IF file_name_length >= x_last_chars.

      file_name_offset = file_name_length - x_last_chars.
      file_name_last_chars = file_name+file_name_offset.

      IF file_name_last_chars = txt_extension.
        ret_boolean_is_text = 1.
      ENDIF.
    ENDIF.
  ENDMETHOD.                    "is_txt
ENDCLASS.               "file_rules

CLASS function_wrapper IMPLEMENTATION.
  METHOD function.
*implement the desired functionality
    WRITE / 'function_wrapper function has been executed'.
    ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  function_wrapper=>execute_function = 'FUNCTION'.
  DATA process_object TYPE REF TO file_archivist.
  CREATE OBJECT process_object.
  CALL METHOD process_object->find_and_transfer_files EXPORTING im_input_dir  = 'test_mes/in'
                                                                im_output_dir = 'test_mes/in/archive'.