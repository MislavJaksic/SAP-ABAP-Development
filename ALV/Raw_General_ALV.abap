REPORT  /ctac/alv_template.                 " <<< DO CHANGE
*Source: Template for an ALV Report, Enhancing the Quality of ABAP Development 
*$*$----------------------------------------------------------------*
*$*$ Company  : Ctac Nederland
*$*$ Author   : Wouter Heuvelmans / Ben Meijs
*$*$ Date     : May 2004
*$*$ SAP rel. : 6.20
*$*$ Transport: <NR>
*$*$ Purpose  : Template For ALV Reports
*$*$            This template can be used as a basis for ALV Reports.
*$*$            After copying this template, you need to implement the
*$*$            following components:
*$*$            - Copy status STANDARD of function group SALV to the
*$*$              program and adjust the status to your needs
*$*$            - implement the selectionscreen as needed
*$*$            - implement subroutine A001_SELECTION
*$*$            - add the ALV structure with all displayfields to the
*$*$              Dictionary
*$*$            - adjust the TYPE-definition for
*$*$              - ta_list (ALV output table);
*$*$            - adjust the VALUE-declaration for the constants
*$*$            - co_struc = name of the DDIC ALV structure used
*$*$            - implement your own GUI functions in subroutine
*$*$              defined in constant CO_ROUT_UCOMM.
*$*$            - implement the headertexts in subroutine BUILD_COMMENT
*$*$            - if you need a second ALV list which is activated by
*$*$              one of your own GUI functions, you'll have to
*$*$              implement the following subroutines:
*$*$              * BUILD_SEC_LIST
*$*$              * DISPLAY_SEC_LIST
*$*$              * MODIFY_FIELDCAT_SEC
*$*$              * CHANGE_LAYOUT_SEC
*$*$
*$*$----------------------------------------------------------------*

*$*$----------------------------------------------------------------*
*$*$          M O D I F I C A T I O N S                             *
*$*$----------------------------------------------------------------*
*& Changed By  :
*& Date        :
*& SAP rel.    :
*& Transport   :
*& Purpose     :
*&------------------------------------------------------------------*

*$*$----------------------------------------------------------------*
*$*$          G L O B A L   D A T A   D E C L A R A T I O N         *
*$*$----------------------------------------------------------------*

*$*$----------------------------------------------------------------*
*$*$ Type pool declarations
*$*$----------------------------------------------------------------*
TYPE-POOLS: slis,                "ALV types / constants
            sdydo,
            abap,                "ABAP reporting types / constants
            icon.                "Possible icons
*$*$----------------------------------------------------------------*
*-- Constants
*$*$----------------------------------------------------------------*
CONSTANTS:
  co_background_alv     TYPE  sdydo_key VALUE 'ALV_WALLPAPER',
  co_save               TYPE c          VALUE 'A',
  co_msgty_inf          TYPE symsgty    VALUE 'I'.
*----------------------------------------------------------------------*
* Constants for interactive functions of an ALV
*----------------------------------------------------------------------*
CONSTANTS:
  co_double_click       TYPE syucomm   VALUE '&IC1',  "CHOOSE / F2
*----------------------------------------------------------------------*
* Customer interactive functions for the ALV
*----------------------------------------------------------------------*
  co_sec_list      
     TYPE syucomm   VALUE 'SEC_LIST'.
"Secundary list
*----------------------------------------------------------------------*
* Names of the routines to be called dynamically from the ALV function
*----------------------------------------------------------------------*
CONSTANTS:
  co_rout_pf_stat       TYPE char30    VALUE 'R0_SET_PF_STATUS',
  co_rout_ucomm         TYPE char30    VALUE 'R1_PROCESS_USER_COMMAND',
  co_rout_top_of_page   TYPE char30    VALUE 'R2_SET_TOP_OF_PAGE',
  co_rout_html_top      TYPE char30    VALUE 'R3_SET_HTML_TOP_OF_PAGE',
  co_rout_html_end      TYPE char30    VALUE 'R4_SET_HTML_END_OF_LIST',
  co_rout_pf_stat_sec   TYPE char30    VALUE 'R5_SET_PF_STATUS_SEC',
  co_rout_ucomm_sec     TYPE char30    VALUE 'R6_PROCESS_UCOMM_SEC',
  co_rout_top_page_sec  TYPE char30    VALUE 'R7_SET_TOP_OF_PAGE_SEC'.

CONSTANTS:
  co_struc              TYPE tabname   VALUE '/CTAC/S_ALV_STRUCTURE',
  co_struc_sec          TYPE tabname   VALUE '/CTAC/S_ALV_STRUC_SEC'.
*$*$----------------------------------------------------------------*
*$*$ Data definitions
*$*$----------------------------------------------------------------*
*TYPES: <type>.

*$*$----------------------------------------------------------------*
*$*$ Data declarations
*--  Internal Tables
*$*$----------------------------------------------------------------*
*    TA_LIST is the internal table containing the data to be outputted
*    by ALV
*----------------------------------------------------------------------*
DATA: ta_list           TYPE TABLE OF /ctac/s_alv_structure.
*----------------------------------------------------------------------*
* Internal tables, needed for ALV formatting
*----------------------------------------------------------------------*
DATA: ta_comment        TYPE slis_t_listheader. "Top of page of the ALV

*$*$----------------------------------------------------------------*
*-- Work areas / records
*$*$----------------------------------------------------------------*
DATA:
  st_s_variant          TYPE disvariant,  "Display Variant (Ext. Use)
  st_s_var_usr          TYPE disvariant.

*$*$----------------------------------------------------------------*
*-- Temporary Fields / Variables
*$*$----------------------------------------------------------------*
DATA: tp_repid_this     TYPE syrepid.
*
*$*$----------------------------------------------------------------*
*$*$          S E L E C T I O N   S C R E E N                       *
*$*$----------------------------------------------------------------*
*$*$ Define your selection-criteria here                            *
*$*$----------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK s01 WITH FRAME TITLE text-s01.
*SELECT-OPTIONS:   <so_sel01> FOR <table_field>.
*PARAMETERS:       <pa_parm1> TYPE <type>.
SELECTION-SCREEN: END OF BLOCK s01.

*$*$----------------------------------------------------------------*
*$*$ This block is meant for giving the user the possibility to     *
*$*$ define whether the output should be printed directly.          *
*$*$----------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK immed WITH FRAME TITLE text-imm.
SELECTION-SCREEN: BEGIN OF LINE.
SELECTION-SCREEN: COMMENT 1(31) text-c01. " Output directly to printer?
PARAMETERS:       pa_print AS CHECKBOX.
SELECTION-SCREEN: END OF LINE.
SELECTION-SCREEN: END OF BLOCK immed.

*$*$----------------------------------------------------------------*
*$*$ This block is meant for giving the user the possibility to     *
*$*$ choose an ALV variant on the selection-screen                  *
*$*$----------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK variant WITH FRAME TITLE text-var.
PARAMETERS:       pa_varia TYPE slis_vari.
SELECTION-SCREEN: END OF BLOCK variant.

*&------------------------------------------------------------------*

*$*$----------------------------------------------------------------*
*$*$          I N I T I A L I Z A T I O N                           *
*$*$----------------------------------------------------------------*
*INITIALIZATION.

*$*$----------------------------------------------------------------*
*$*$          A T   S E L E C T I O N   S C R E E N                 *
*$*$----------------------------------------------------------------*
*-- Selection screen output
*AT SELECTION-SCREEN OUTPUT.

*-- Selection screen processing
AT SELECTION-SCREEN.

  PERFORM process_output_variant USING    pa_varia
                                 CHANGING st_s_variant
                                          st_s_var_usr.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_varia.
*----------------------------------------------------------------------*
* Handling possible values for the ALV Display Variant
*----------------------------------------------------------------------*
  PERFORM get_possible_variants CHANGING pa_varia
                                         st_s_variant
                                         st_s_var_usr.

*$*$----------------------------------------------------------------*
*$*$          M A I N   P R O C E S S I N G                         *
*$*$----------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM init_report.
*----------------------------------------------------------------------*
* Select the data that is going to be displayed in the ALV
*----------------------------------------------------------------------*
  PERFORM select_data TABLES ta_list.

END-OF-SELECTION.
*----------------------------------------------------------------------*
* Finish the internal table that is going to be displayed in the ALV.
*----------------------------------------------------------------------*
  PERFORM process_data TABLES ta_list.
*----------------------------------------------------------------------*
* Call the correct function to display the ALV data.
*----------------------------------------------------------------------*
  PERFORM display_data TABLES ta_list.

*$*$----------------------------------------------------------------*
*$*$          F O R M   R O U T I N E S                             *
*$*$----------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  init_report
*&---------------------------------------------------------------------*
*       One time actions that are required at this moment.
*----------------------------------------------------------------------*
FORM init_report .

  tp_repid_this = sy-repid. "or sy-cprog

ENDFORM.                    " init_report
*&--------------------------------------------------------------------*
*&      Form  select_data
*&--------------------------------------------------------------------*
*       Build internal table TA_LIST
*---------------------------------------------------------------------*
FORM select_data TABLES tta_list STRUCTURE /ctac/s_alv_structure.

*---------------------------------------------------------------------*
* For example, build the internal table from the purchase header database.
*---------------------------------------------------------------------*
*  SELECT * FROM  ekko
*           INTO TABLE tta_list
*           WHERE  ebeln IN so_ebeln.

ENDFORM.                    " select_data
*&--------------------------------------------------------------------*
*&      Form  process_data
*&--------------------------------------------------------------------*
*       Process the selected data so that it can be used in the ALV.
*---------------------------------------------------------------------*
FORM process_data TABLES tta_list STRUCTURE /ctac/s_alv_structure.

  SORT tta_list.

ENDFORM.                    " process_data
*&--------------------------------------------------------------------*
*&      Form  display_data
*&--------------------------------------------------------------------*
*       Prepare the ALV output.
*       Display output in ALV format.
*       If SAPGUI is available, the GRID will be displayed.
*       In other situations, the LIST will be displayed.
*---------------------------------------------------------------------*
FORM display_data TABLES tta_list STRUCTURE /ctac/s_alv_structure.

*---------------------------------------------------------------------*
*  Comment:
*  Define all data locally, except when you explicitly need it globally!
*---------------------------------------------------------------------*
  DATA: lta_fcat             TYPE slis_t_fieldcat_alv. "Field Catalog
  DATA: lta_extab            TYPE slis_t_extab.        "Excl. Functions
  DATA: lta_spec_groups      TYPE slis_t_sp_group_alv. "Spec. groups
  DATA: lta_sort_alv         TYPE slis_t_sortinfo_alv.
  DATA: lta_filter           TYPE slis_t_filter_alv.
  DATA: lta_events           TYPE slis_t_event.
  DATA: lta_event_exit       TYPE slis_t_event_exit.
  DATA: lta_alv_graphics     TYPE dtc_t_tc.
  DATA: lta_add_fieldcat     TYPE slis_t_add_fieldcat.
  DATA: lta_hyperlink        TYPE lvc_t_hype.

  DATA: lst_layout           TYPE slis_layout_alv,     "Layout Settings
        lst_is_print         TYPE slis_print_alv,
        lst_sel_hide         TYPE slis_sel_hide_alv,
        lst_exit_user        TYPE slis_exit_by_user.

  DATA: ltp_title            TYPE lvc_title,
        ltp_gui_active       TYPE boolean,
        ltp_tdline           TYPE tdline,
        ltp_reprep_id        TYPE slis_reprep_id,
        ltp_html_hght_top    TYPE i,
        ltp_html_hght_end    TYPE i,
        ltp_exit_caller(1)   TYPE c.

*----------------------------------------------------------------------*
* First we build the field catalog.
* This internal table is required to determine which fields of the internal
* table are to be displayed and how they should be displayed.
*----------------------------------------------------------------------*
  PERFORM build_fieldcatalog    USING co_struc
                             CHANGING lta_fcat[].
*----------------------------------------------------------------------*
* After building the field catalog (e.g., from a DDIC structure), we can 
* modify these settings in the following subroutine.
*----------------------------------------------------------------------*
  PERFORM modify_fieldcatalog    CHANGING lta_fcat[].
*----------------------------------------------------------------------*
* Also, we can modify the layout settings.
*----------------------------------------------------------------------*
  PERFORM change_layout_settings CHANGING lst_layout.

*----------------------------------------------------------------------*
* Set title
*----------------------------------------------------------------------*
  ltp_title = sy-title.

*----------------------------------------------------------------------*
* Table ta_comment is used to display header information in the
* top-of-page of the ALV output.
*----------------------------------------------------------------------*
  PERFORM build_comment CHANGING ta_comment[].

*----------------------------------------------------------------------*
* Determine whether the report is executed within a SAPGUI environment.
* We need to know whether GUI-controls are accessible.
* If not, we use function module REUSE_ALV_LIST_DISPLAY (without
* controls) instead of function module REUSE_ALV_GRID_DISPLAY.
*----------------------------------------------------------------------*
  CALL FUNCTION 'GUI_IS_AVAILABLE'
    IMPORTING
      return = ltp_gui_active.

*----------------------------------------------------------------------*
* If we send the output directly to the printer, we can
* deactivate the GUI-setting and select the LIST-variant of the ALV.
*----------------------------------------------------------------------*
  IF pa_print = abap_true.
    lst_is_print-print    = 'X'.
    CLEAR ltp_gui_active.
  ENDIF.

  IF ltp_gui_active = abap_true.
*----------------------------------------------------------------------*
* GUI active -> Activate the ALV GRID (control enabled)
*----------------------------------------------------------------------*
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program          = tp_repid_this
        i_callback_pf_status_set    = co_rout_pf_stat
        i_callback_user_command     = co_rout_ucomm
        i_callback_top_of_page      = co_rout_top_of_page
*        i_callback_html_top_of_page = co_rout_html_top     "
*        i_callback_html_end_of_list = co_rout_html_end     "
        i_background_id             = co_background_alv
*        i_structure_name            = co_struc             "
        i_grid_title                = ltp_title
        is_layout                   = lst_layout
        it_fieldcat                 = lta_fcat[]
*        it_excluding                = lta_extab[]          "
*        it_special_groups           = lta_spec_groups[]    "
*        it_sort                     = lta_sort_alv[]       "
*        it_filter                   = lta_filter[]         "
*        is_sel_hide                 = lst_sel_hide         "
        i_default                   = abap_true
        i_save                      = co_save
        is_variant                  = st_s_variant
*        it_events                   = lta_events[]        "
*        it_event_exit               = lta_event_exit[]    "
        is_print                    = lst_is_print
*        is_reprep_id                = ltp_reprep_id       "
*        i_screen_start_column       = 0                   "
*        i_screen_start_line         = 0                   "
*        i_screen_end_column         = 0                   "
*        i_screen_end_line           = 0                   "
*        it_alv_graphics             = lta_alv_graphics[]  "
*        it_add_fieldcat             = lta_add_fieldcat[]  "
*        it_hyperlink                = lta_hyperlink[]     "
*        i_html_height_top           = ltp_html_hght_top   "
*        i_html_height_end           = ltp_html_hght_end   "
*      IMPORTING                                           "
*        e_exit_caused_by_caller     = ltp_exit_caller     "
*        es_exit_caused_by_user      = lst_exit_user       "
      TABLES
        t_outtab                    = ta_list
      EXCEPTIONS
        program_error               = 1
        OTHERS                      = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ELSE.
*----------------------------------------------------------------------*
* GUI not active -> ALV LIST displayed in Background.
* All parameters for interactive processing need not be supplied.
*----------------------------------------------------------------------*
    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
*        i_interface_check        = space                   "
*        i_bypassing_buffer       = space                   "
*        i_buffer_active          = space                   "
        i_callback_program       = tp_repid_this
*        i_callback_pf_status_set = co_rout_pf_stat         "
*        i_callback_user_command  = co_rout_ucomm           "
*        i_structure_name         = co_struc                "
        is_layout                = lst_layout
        it_fieldcat              = lta_fcat[]
*        it_excluding             = lta_extab[]             "
*        it_special_groups        = lta_spec_groups[]       "
*        it_sort                  = lta_sort_alv[]          "
*        it_filter                = lta_filter[]            "
*        is_sel_hide              = lst_sel_hide            "
        i_default                = abap_true
*        i_save                   = co_save                 "
        is_variant               = st_s_variant
*        it_events                = lta_events[]            "
*        it_event_exit            = lta_event_exit[]        "
        is_print                 = lst_is_print
*        is_reprep_id             = ltp_reprep_id           "
*        i_screen_start_column    = 0                       "
*        i_screen_start_line      = 0                       "
*        i_screen_end_column      = 0                       "
*        i_screen_end_line        = 0                       "
*      IMPORTING
*        e_exit_caused_by_caller  = ltp_exit_caller         "
*        es_exit_caused_by_user   = lst_exit_user           "
      TABLES
        t_outtab                 = tta_list
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ENDFORM.                    " display_data
*&--------------------------------------------------------------------*
*&      Form  get_possible_variants
*&--------------------------------------------------------------------*
*       Handle request for possible values on the output variant.
*---------------------------------------------------------------------*
FORM get_possible_variants CHANGING ctp_varia     TYPE slis_vari
                                    cst_s_variant TYPE disvariant
                                    cst_s_var_usr TYPE disvariant.

  DATA: ltp_exit(1)   TYPE c.

  PERFORM init_variant USING sy-repid
                    CHANGING cst_s_variant.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant    = cst_s_variant
      i_save        = co_save
    IMPORTING
      e_exit        = ltp_exit
      es_variant    = cst_s_var_usr
    EXCEPTIONS
      not_found     = 1
      program_error = 2
      OTHERS        = 3.

  CASE sy-subrc.
    WHEN 0.
      IF ltp_exit = abap_false.
        ctp_varia = st_s_var_usr-variant.
      ENDIF.
    WHEN 1.
      MESSAGE ID sy-msgid TYPE co_msgty_inf  NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    WHEN 2.
      MESSAGE ID sy-msgid TYPE co_msgty_inf  NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    WHEN 3.
      MESSAGE ID sy-msgid TYPE co_msgty_inf  NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDCASE.

ENDFORM.                                     " get_possible_variants
*&--------------------------------------------------------------------*
*&      Form  init_variant
*&--------------------------------------------------------------------*
*       Initialize the output variant
*---------------------------------------------------------------------*
FORM init_variant USING    utp_repid_this TYPE syrepid
                  CHANGING cst_s_variant  TYPE disvariant.

  CLEAR cst_s_variant.
  cst_s_variant-report = utp_repid_this.

ENDFORM.                               " init_variant
*&--------------------------------------------------------------------*
*&      Form  r0_set_pf_status
*&--------------------------------------------------------------------*
*       If you need additional GUI functions, copy status STANDARD
*       from function group SALV and add your own functions to this status.
*       In this routine, you specify that you want to use your own GUI
*       status instead of the basic GUI status.
*---------------------------------------------------------------------*
*      -->UTA_EXTAB  text
*---------------------------------------------------------------------*
FORM r0_set_pf_status USING uta_extab TYPE slis_t_extab.    "#EC CALLED

*---------------------------------------------------------------------*
* Copy GUI status 'STANDARD' from functiongroup 'SALV'.
* After copy, reactivate function '&RNT_PREV' and place this function
* in the 1st position of the menu bar.
*---------------------------------------------------------------------*
  SET PF-STATUS 'STANDARD'.

ENDFORM.                    "R0_SET_PF_STATUS
*&--------------------------------------------------------------------*
*&      Form  r1_process_user_command
*&--------------------------------------------------------------------*
*       This routine deals with the "non-standard" GUI-functions.
*       It enables you to do the following:
*       - Double-click or click on a hotspotted field
*       - Implement your own GUI-functions 
*       You'll find some predefined examples in this routine.
*---------------------------------------------------------------------*
FORM r1_process_user_command                                "#EC CALLED
     USING utp_ucomm    TYPE syucomm
           utp_selfield TYPE slis_selfield.

  DATA: lta_list_sec         TYPE TABLE OF /ctac/s_alv_struc_sec.

  DATA: ltp_repid            TYPE syrepid.

*  DATA: ltp_ebeln_num(10)    TYPE n.
*  DATA: ltp_ebeln            TYPE ebeln.
*  DATA: ltp_matnr            TYPE matnr.
*  DATA: ltp_matnr_char(18)   TYPE c.
*
*----------------------------------------------------------------------*
* Handle the specific user-commands.                                    *
*----------------------------------------------------------------------*
  CASE utp_ucomm.

*----------------------------------------------------------------------*
* Handle double click or hotspot on a specific field.                  *
* These are some examples                                              *
*----------------------------------------------------------------------*

    WHEN co_double_click.
      CASE utp_selfield-fieldname.

*        WHEN 'EBELN'.
*
*          ltp_ebeln_num = utp_selfield-value.
*          ltp_ebeln     = ltp_ebeln_num.
*          CALL FUNCTION 'MR_PO_DISPLAY'
*               EXPORTING
*                    i_ebeln = ltp_ebeln.
*
*        WHEN 'LIFNR'.
*
*          SET PARAMETER ID 'LIF' FIELD utp_selfield-value.
*          CALL TRANSACTION 'MK03' AND SKIP FIRST SCREEN.

*        WHEN 'TABNAME'.
*
*          REFRESH bdcdata.
*          PERFORM bdc_dynpro USING 'SAPMSRD0'       '0102'.
*          PERFORM bdc_field  USING 'BDC_OKCODE'     '=SHOW'.
*          PERFORM bdc_field  USING 'RSRD1-TBMA'     abap_true.
*          PERFORM bdc_field  USING 'RSRD1-TBMA_VAL' utp_selfield-value.
*
*          CALL TRANSACTION 'SE11' USING bdcdata MODE 'E'.
*
        WHEN OTHERS.

      ENDCASE.

*---------------------------------------------------------------------*
* Handle your own GUI functions here                                  *
* For example, handle a secondary ALV List                            *
*---------------------------------------------------------------------*
    WHEN co_sec_list.

      PERFORM build_sec_list   TABLES   lta_list_sec.
      PERFORM display_sec_list TABLES   lta_list_sec
                               CHANGING utp_selfield.

*---------------------------------------------------------------------*
* Or some other GUI-functions                                         *
*---------------------------------------------------------------------*
*    WHEN 'OKCODE_01'.
*      Actions for this okcode

    WHEN OTHERS.

  ENDCASE.

ENDFORM.                    "R1_PROCESS_USER_COMMAND
*---------------------------------------------------------------------*
*       FORM R2_SET_TOP_OF_PAGE                                       *
*---------------------------------------------------------------------*
*       Put the content of table TA_COMMENT on the top of the ALV     *
*---------------------------------------------------------------------*
FORM r2_set_top_of_page.                                    "#EC CALLED

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ta_comment
    EXCEPTIONS
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    "R2_SET_TOP_OF_PAGE

*&--------------------------------------------------------------------*
*&      Form  build_comment
*&--------------------------------------------------------------------*
*       Create the internal table that is going to be the TOP-OF-PAGE
*       of the ALV grid or list.
*---------------------------------------------------------------------*
FORM build_comment CHANGING cta_top_of_page TYPE slis_t_listheader.

  DATA: lwa_line TYPE slis_listheader.

  REFRESH cta_top_of_page.

*---------------------------------------------------------------------*
* LIST HEADING LINE: TYPE H
*---------------------------------------------------------------------*
  CLEAR lwa_line.
  lwa_line-typ  = 'H'.
*---------------------------------------------------------------------*
* LLINE-KEY:  NOT USED FOR THIS TYPE
*---------------------------------------------------------------------*
  lwa_line-info = text-100.
  APPEND lwa_line TO cta_top_of_page.

*---------------------------------------------------------------------*
* STATUS LINE: TYPE S
*---------------------------------------------------------------------*
  CLEAR lwa_line.
  lwa_line-typ  = 'S'.
  lwa_line-key  = text-101.
  lwa_line-info = text-102.
  APPEND lwa_line TO cta_top_of_page.
  lwa_line-key  = text-103.
  lwa_line-info = text-104.
  APPEND lwa_line TO cta_top_of_page.

*---------------------------------------------------------------------*
* ACTION LINE: TYPE A
*---------------------------------------------------------------------*
  CLEAR lwa_line.
  lwa_line-typ  = 'A'.
*---------------------------------------------------------------------*
* LLINE-KEY:  NOT USED FOR THIS TYPE
*---------------------------------------------------------------------*
  lwa_line-info = text-105.
  APPEND lwa_line TO cta_top_of_page.

ENDFORM.                    " build_comment
*&--------------------------------------------------------------------*
*&      Form  build_fieldcatalog
*&--------------------------------------------------------------------*
*       Build a field catalog from the DDIC structure specified. 
*---------------------------------------------------------------------*
FORM build_fieldcatalog    USING utp_struc TYPE tabname
                        CHANGING cta_fcat  TYPE slis_t_fieldcat_alv.

*----------------------------------------------------------------------*
* Build a field catalog for ALV, based on a DDIC structure.
*----------------------------------------------------------------------*
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = tp_repid_this
      i_structure_name       = utp_struc
      i_bypassing_buffer     = abap_true
    CHANGING
      ct_fieldcat            = cta_fcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " build_fieldcatalog
*&--------------------------------------------------------------------*
*&      Form  change_layout_settings
*&--------------------------------------------------------------------*
*       Set some layout attributes.
*---------------------------------------------------------------------*
FORM change_layout_settings  CHANGING cst_layout TYPE slis_layout_alv.

*----------------------------------------------------------------------*
* Modify layout settings.
*----------------------------------------------------------------------*
  cst_layout-zebra             = abap_true.
  cst_layout-colwidth_optimize = abap_true.

ENDFORM.                    " change_layout_settings
*&--------------------------------------------------------------------*
*&      Form  modify_fieldcatalog
*&--------------------------------------------------------------------*
*       Modify the field catalog for the primary list, if needed!
*       You can set attributes for every column in the ALV output by
*       selecting the fieldname belonging to the column.
*       For an overview of the attributes available, see the
*       online documentation of function module REUSE_ALV_GRID_DISPLAY.
*---------------------------------------------------------------------*
FORM modify_fieldcatalog  CHANGING cta_fcat TYPE slis_t_fieldcat_alv.

  DATA: lwa_fcat             TYPE slis_fieldcat_alv.

*----------------------------------------------------------------------*
* Modify the field catalog according to the requirements.
* Some examples are shown below.
*----------------------------------------------------------------------*
  LOOP AT cta_fcat INTO lwa_fcat.
    CASE lwa_fcat-fieldname.
*      WHEN 'EBELN'.
*        lwa_fcat-key       = abap_true.
*        lwa_fcat-hotspot   = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'BUKRS' OR 'EKORG' OR 'EKGRP' OR 'EBELP'.
*        lwa_fcat-key       = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'LIFNR' or 'BELNR'.
*        lwa_fcat-hotspot   = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'NETPR' OR 'DMBTR' OR 'MENGE'.
*        lwa_fcat-no_zero   = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'ZGR_REQ' OR 'SHKZG'.
*        lwa_fcat-just      = 'C'.
*        MODIFY cta_fcat FROM lwa_fcat.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    " modify_fieldcatalog
*&--------------------------------------------------------------------*
*&      Form  modify_fieldcat_SEC
*&--------------------------------------------------------------------*
*       Modify the field catalog for the secondary list, if needed!
*       As you could for the field catalog of the primary list, you 
*       can set attributes for every column by selecting the corresponding
*       field name. Look at the examples.
*---------------------------------------------------------------------*
FORM modify_fieldcat_sec  CHANGING cta_fcat TYPE slis_t_fieldcat_alv.

  DATA: lwa_fcat             TYPE slis_fieldcat_alv.

*----------------------------------------------------------------------*
* Modify the field catalog according to the requirements.
* Some examples are shown below.
*----------------------------------------------------------------------*
  LOOP AT cta_fcat INTO lwa_fcat.
    CASE lwa_fcat-fieldname.
*      WHEN 'EBELN'.
*        lwa_fcat-key       = abap_true.
*        lwa_fcat-hotspot   = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'BUKRS' OR 'EKORG' OR 'EKGRP' OR 'EBELP'.
*        lwa_fcat-key       = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'LIFNR' or 'BELNR'.
*        lwa_fcat-hotspot   = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'NETPR' OR 'DMBTR' OR 'MENGE'.
*        lwa_fcat-no_zero   = abap_true.
*        MODIFY cta_fcat FROM lwa_fcat.
*      WHEN 'ZGR_REQ' OR 'SHKZG'.
*        lwa_fcat-just      = 'C'.
*        MODIFY cta_fcat FROM lwa_fcat.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.

ENDFORM.                    " modify_fieldcat_sec
*&--------------------------------------------------------------------*
*&      Form  build_sec_list
*&--------------------------------------------------------------------*
*       Build internal table for second ALV list
*---------------------------------------------------------------------*
FORM build_sec_list TABLES tta_list STRUCTURE /ctac/s_alv_struc_sec.


ENDFORM.                    " build_sec_list
*&--------------------------------------------------------------------*
*&      Form  display_sec_list
*&--------------------------------------------------------------------*
*       This form builds a second ALV list with another field catalog
*       based on a second DDIC-structure (change this name!!!)
*       Fill in the right structure name for constant CO_STRUC_SEC!
*       .
*---------------------------------------------------------------------*
FORM display_sec_list
     TABLES   tta_list     STRUCTURE /ctac/s_alv_struc_sec
     CHANGING ctp_selfield TYPE slis_selfield.

  DATA: lta_fcat             TYPE slis_t_fieldcat_alv.
  DATA: lta_sort_alv         TYPE slis_t_sortinfo_alv.

  DATA: lst_s_variant        TYPE disvariant,
        lst_layout           TYPE slis_layout_alv,
        lst_exit_by_user     TYPE slis_exit_by_user.

  DATA: lwa_fcat             TYPE slis_fieldcat_alv.

  PERFORM build_fieldcatalog         USING co_struc_sec
                                  CHANGING lta_fcat[].
  PERFORM modify_fieldcat_sec     CHANGING lta_fcat[].
  PERFORM change_layout_settings  CHANGING lst_layout.
  PERFORM init_variant               USING tp_repid_this
                                  CHANGING lst_s_variant.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = tp_repid_this
      i_callback_pf_status_set = co_rout_pf_stat_sec
      i_callback_user_command  = co_rout_ucomm_sec
      i_callback_top_of_page   = co_rout_top_page_sec
      is_layout                = lst_layout
      it_fieldcat              = lta_fcat
      i_save                   = co_save
      is_variant               = lst_s_variant
      it_sort                  = lta_sort_alv
*      is_print                 = wa_is_print
    IMPORTING
      es_exit_caused_by_user   = lst_exit_by_user
    TABLES
      t_outtab                 = tta_list
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*----------------------------------------------------------------------*
* If field wa_exit_by_user is filled, the user has indicated that he/she wants * to quit.
* In that case, enter value 'X' in field utp_selfield_exit in order to 
* cause the ALV function to stop and not return to the first ALV list shown.
*----------------------------------------------------------------------*
  IF NOT lst_exit_by_user IS INITIAL.
    ctp_selfield-exit = abap_true.
  ENDIF.

ENDFORM.                    " display_sec_list
*&--------------------------------------------------------------------*
*&      Form  set_sort_criteria
*&--------------------------------------------------------------------*
* Determine the sort order and/or the subtotalling of the basic list.
*---------------------------------------------------------------------*
FORM set_sort_criteria  CHANGING cta_sort_alv TYPE slis_t_sortinfo_alv.

ENDFORM.                    " set_sort_criteria_sec
*&--------------------------------------------------------------------*
*&      Form  process_output_variant
*&--------------------------------------------------------------------*
*       Process the selected output variant
*---------------------------------------------------------------------*
FORM process_output_variant USING    utp_varia     TYPE slis_vari
                            CHANGING cst_s_variant TYPE disvariant
                                     cst_s_var_usr TYPE disvariant.

*----------------------------------------------------------------------*
* If display-variant entered on the selection-screen, we need to check
* whether this variant exists.
*----------------------------------------------------------------------*
  IF NOT utp_varia IS INITIAL.

    MOVE: cst_s_variant TO cst_s_var_usr,
          sy-repid      TO cst_s_var_usr-report,
          utp_varia     TO cst_s_var_usr-variant.

    CALL FUNCTION 'REUSE_ALV_VARIANT_EXISTENCE'
      EXPORTING
        i_save        = co_save
      CHANGING
        cs_variant    = cst_s_var_usr
      EXCEPTIONS
        wrong_input   = 1
        not_found     = 2
        program_error = 3
        OTHERS        = 4.
    IF sy-subrc <> 0.
      CLEAR cst_s_variant.
    ELSE.
      cst_s_variant = cst_s_var_usr.
    ENDIF.
  ELSE.
    PERFORM init_variant USING    sy-repid
                         CHANGING cst_s_variant.
  ENDIF.

ENDFORM.                    " process_output_variant
