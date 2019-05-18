## SmartForms

Transaction: SMARTFORMS  

Create SmartForm form:  
```
Create a blank SmartForm
OR
Copy an existing form and create a Z named SmartForm form
```

Print program:
```
An ABAP program passes data to a SmartForm Function Module
```

- SmartForm  
  - Global Settings  
    - Form Attributes - specify output format, page format and SmartForm style  
    - Form Interface - parameter interface through which data is exchanged with the print program, types have to be defined in the ABAP Dictionary  
    - Global Definitions - define local, working variables such as those into which tables are going to be unpacked  
  - Pages and Windows  
    - FIRST page - points to the NEXT page  
    - NEXT page - points to itself  
    - Nodes - the building blocks of SmartForm  

You can create more then two pages, but their interactions become complicated.  

### Nodes

- Page - there will normally be only two pages, NEXT and FIRST  
  - Window - there can only be one Main Window, all other are either Secondary or Final  
    - Table - under table->details define a line type by defining the width of each column. Under data, specify which form interface table will be unpacked into which global definition local variable  
      - Table line - set line type that you previously defined under table->details. This will generate cells, text elements into which you will be able to write  
    - Text element - write text. Variables will be printed if their name is sandwiched between & and the variable then appears on a gray background. If a text module by type, then you have to create the text module in transaction SMARTFORMS  
  - Graphic - define which picture you want to show. Upload a picture using transaction SE78  
  - Address - prints out ISO formatted data  
  - Other nodes - Template, Include Text type of Text element, Program lines, Command, Loop and Alternatives  

### Function module generation

Generate function module:  
```
Activate SmartForm
Execute SmartForm 
``` 

Do this every time you change a SmartForm.  

### Print Program

The data type of the table that will be send to the SmartForm's function module has to be field for field exact as the importing parameter's type defined in the Form Interface.  

Select data with SQL.  

Invoke 'SSF_FUNCTION_MODULE_NAME' and then invoke the function module.  

### Testing

SmartForm testing:  
```
Execute Print Program
OutputDevice=LP01
Print Preview  
OR
Execute SmartForm Function Module
Give parameters data
Execute Module
OutputDevice=LP01
Print Preview
```

Use PageUp and PageDown in print preview to cycle through the pages.  

### Print program example

```abap
REPORT zplayground.

* declarations
DATA flights TYPE STANDARD TABLE OF spfli.
* select data
SELECT *
  FROM spfli
  INTO TABLE flights.
  
* determine SmartForm's generated function module name
DATA smart_form_name TYPE tdsfname VALUE 'ZPLAYGROUND'.
DATA function_module_name TYPE rs38l_fnam.
CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
     EXPORTING  formname           = smart_form_name
     IMPORTING  fm_name            = function_module_name
     EXCEPTIONS no_form            = 1
                no_function_module = 2
                OTHERS             = 3.
* call SmartForm's function module
CALL FUNCTION function_module_name
     EXPORTING
                flights              = flights "SmartForm has very strict type checking
     EXCEPTIONS formatting_error     = 1
                internal_error       = 2
                send_error           = 3
                user_canceled        = 4
                OTHERS               = 5.
```
