REPORT  ObjectOriented.

INTERFACE interface.
  METHODS:
  interface_method.
  ENDINTERFACE.

*Final classes cannot be inherited
*Abstract classes cannot be instantiated
*A class has to be abstract if it has at least one abstract method
CLASS super_class DEFINITION ABSTRACT.
*Visibility modifiers: PUBLIC, PROTECTED, PRIVATE.
  PUBLIC SECTION.
  INTERFACES interface.
*Instance methods are inherited and can be overridden(REDEFINITION)
*Final methods are inherited and cannot be overridden
*Static(class) methods are inherited and cannot be overridden
*Static methods are shared by all classes that inherit them
*Abstract methods aren't fully implemented
  METHODS: instance,
           final FINAL,
           abstract ABSTRACT.
  CLASS-METHODS: static.
*Define an instance and static attribute
  DATA instance_data TYPE i VALUE 6.
  CLASS-DATA static_data TYPE i VALUE 7.
  ENDCLASS.

*sub_class inherits from super_class
CLASS sub_class DEFINITION INHERITING FROM super_class.
  PUBLIC SECTION.
*Events and methods that raise them are defined in the same class
  EVENTS event EXPORTING value(ev_number) TYPE i. "events can only export a value
  METHODS: raise_event_method,
*Inherited instance methods can be REDEFINITIONed
*Inherited abstract methods have to be ABSTRACT or REDEFINITIONed
           instance REDEFINITION,
           abstract REDEFINITION.
           

  ENDCLASS.

CLASS event_responder DEFINITION.
  PUBLIC SECTION.
*Another method is declared an event handler and it responds to the event
  METHODS: event_handler FOR EVENT event OF sub_class IMPORTING ev_number.
  ENDCLASS.

CLASS super_class IMPLEMENTATION.
  METHOD instance.
    WRITE / 'super_class instance'.
    ENDMETHOD.
  METHOD static.
    WRITE / 'super_class static'.
    ENDMETHOD.
  METHOD final.
    WRITE / 'super_class final'.
    ENDMETHOD.
  METHOD interface~interface_method.
    WRITE / 'interface'.
    ENDMETHOD.

  ENDCLASS.

CLASS sub_class IMPLEMENTATION.
  METHOD instance.
    WRITE / 'sub_class instance'.
*super in this method can only invoke the instance named method of the superclass
    call method super->instance.
    ENDMETHOD.
  METHOD abstract.
    WRITE / 'sub_class abstract'.
    ENDMETHOD.
  METHOD raise_event_method.
    RAISE EVENT event EXPORTING ev_number = instance_data.
    ENDMETHOD.
  ENDCLASS.

CLASS event_responder IMPLEMENTATION.
    METHOD event_handler.
      WRITE / 'I got this number:'.
      WRITE ev_number.
      ENDMETHOD.
    ENDCLASS.

  START-OF-SELECTION.
*Create a sub_class object and store it in a super_class reference
    DATA super_ref TYPE REF TO super_class.
    CREATE OBJECT super_ref TYPE sub_class.
*Access instance  components with ->
*Access static    components with =>
*Access interface components with _interface~_component
    CALL METHOD super_ref->instance. "-> sub_class instance
                                     "-> super_class instance 
    CALL METHOD super_class=>static. "-> super_class static
    CALL METHOD sub_class=>static. "-> super_class static
    
    CALL METHOD super_ref->final. "-> super_class final
    
    CALL METHOD super_ref->abstract. "-> sub_class abstract
    
    CALL METHOD super_ref->interface~interface_method. "-> interface

*An event handler will respond only if the handler is registered (SET HANDLER)
    DATA event_responder_object TYPE REF TO event_responder.
    DATA sub_ref TYPE REF TO sub_class.
    CREATE OBJECT event_responder_object TYPE event_responder.
    CREATE OBJECT sub_ref TYPE sub_class.
    SET HANDLER event_responder_object->event_handler FOR sub_ref. "cannot say ... FOR super_ref because it references super_class
    CALL METHOD sub_ref->raise_event_method. "-> I got this number: 6