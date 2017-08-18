REPORT  AlgebraAndStrings.

*Data objects need to be defined before use
*Elementary types
DATA integer TYPE i.
DATA float TYPE f. "and p
DATA char TYPE c.
DATA str TYPE string.
DATA time TYPE t. "and d for date

TYPES: BEGIN OF structure,
         struct_number TYPE i,
         struct_string TYPE string,
       END OF structure.
DATA structure_data TYPE structure.
structure_data-struct_number = 7.

integer = 6 / 5. "Normal division
WRITE / integer. "-> _________1
integer = 6 DIV 5. "Integer division
WRITE / integer. "-> _________1
integer = 15 MOD 2. "Modulo
WRITE / integer. "-> _________1
integer = 4 ** 2. "Exponentiation
WRITE / integer. "-> ________16

DATA result TYPE f.
float = '1.505'.
result = SIGN( '-505.1' ).
WRITE / result. "-> _-1,0000000000000000E+00
result = SQRT( float ).
WRITE / result. "-> __1,2267844146385296E+00
result = ABS( float ).
WRITE / result. "-> __1,5049999999999999E+00
result = CEIL( float ).
WRITE / result. "-> __2,0000000000000000E+00
result = FLOOR( float ).
WRITE / result. "-> __1,0000000000000000E+00
result = TRUNC( float ).
WRITE / result. "-> __1,0000000000000000E+00
result = FRAC( float ).
WRITE / result. "-> __5,0499999999999989E-01
result = SIN( float ).
WRITE / result. "-> __9,9783620247734695E-01
result = LOG( float ).
WRITE / result. "-> __4,0879289820083897E-01
result = LOG10( float ).
WRITE / result. "-> __1,7753649992986212E-01
result = EXP( float ).
WRITE / result. "-> __4,5041536302884833E+00

DATA p_one TYPE string.
DATA p_two TYPE string.
*As ABAP is mostly about fine data manipulation,
*most common string functions are showcased
string = ' St    ring    '.
CONDENSE string NO-GAPS.
WRITE / string. "-> String

TRANSLATE string TO UPPER CASE.
WRITE / string. "-> STRING

TRANSLATE string USING 'TtRrIiNnGg'. "odd characters transform into even characters, T->t, R->r, I->i, ...
WRITE / string. "-> String

SPLIT string AT 'r' INTO p_one p_two.
WRITE / string. "-> String
WRITE p_one. "-> St
WRITE p_two. "-> ing

SEARCH string FOR 'k'.
WRITE / sy-subrc. "-> ____4 , code for not found

CONCATENATE string string INTO string.
WRITE / string. "-> StringString

integer = STRLEN( string ).
WRITE / integer. "-> ________12

*Don't use REPLACE as it behaves illogically with
*whitespaces and has a complex syntax. Use
*TRANSLATE .. USING instead to replace characters
