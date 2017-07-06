REPORT  UnitTesting.

*unit testing classes need to have FOR TESTING addition
*and "#AU Risk_Level Harmless "AU Duration Short as a comment
CLASS test_class DEFINITION FOR TESTING. "#AU Risk_Level Harmless "AU Duration Short
  PRIVATE SECTION.
*unit testing methods need to have FOR TESTING addition
  METHODS test_method FOR TESTING.
  ENDCLASS.

CLASS test_class IMPLEMENTATION.
  METHOD test_method.
    DATA: test_price TYPE i VALUE 200.
    PERFORM procedure CHANGING test_price.
*call class methods to assert the truth
*act is what the tested function returns, exp is what is expected
*and msg is what will be written if the assert fails
    cl_aunit_assert=>assert_equals( act = test_price exp = 180
    msg = 'ninety percent not calculated correctly').
    ENDMETHOD.
ENDCLASS.

FORM procedure CHANGING fprice TYPE i.
  data price type i.
*price = fprice * '0.9'. "will get an error screen
  fprice = fprice * '0.9'. "will not got an error screen
  ENDFORM.