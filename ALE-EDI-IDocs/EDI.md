## EDI

EDI stands for Electronic Data Interchange and is a way to exchange information with external systems.  
In EDI senders and receivers are called trading partners. Trading partners exchange business documents.  

### Business documents

Business documents define transactions between trading partners.  
Examples include purchase orders and invoices which are legally defined.  

### EDI in SAP

EDI-enabled applications are those that can generate IDocs.  
IDocs stands for Intermediate Document and is SAP's data format.  
IDocs are constructed from application data and can be converted from their IDoc form back into application data.  
There are two EDI processes: outbound and inbound.  
In an outbound EDI process, an application document is created, then IDoc is generated based on the application data,
IDoc is converted to an EDI document and it is then finally transmitted by EDI. The whole process can generate report
statuses which allow the user to check the correctness of the outbound process.  
In inbound EDI process, an EDI transmission is received and then the process continues in the opposite direction of
the outbound process.  
Errors can and will occure in the process. Errors can be viewed in the Workflow.  

### IDoc

IDoc is a data container and simultaneously represents an Idoc type and IDoc data depending on the context.  
IDoc type is also the IDoc name and is made up of several segments (data records).  
Each segment consists of several data fields.  
IDoc can also be thought of as made up of a control record and many data records (segments).  

### Outbound processes

Selection programs are commonly implemented as function modules, extract application data and create an IDoc.   
Selection programs exist for each message type. Message control determines output connected to application documents.  
A port number determines the name of the EDI subsystem program and the directory path where the IDoc file will be 
created.  
RFC stands for Remote Function Call.  
RFC destination determines the characteristics of communication links to a remote system.  
Partner profile specifies the various components and is created for each business partner.  
Outbound processes are divided into those with and without message control.  

### Message control

Message control enables encapsulation business rules.  
Message control also determines output connected to application documents as well as separating the logic of
generating EDI documents from the logic of the application.  

### Inbound processes


### EDI subsystems


### EDI interface configuration

EDi processes are configured in the Implementation guide (IMG).  
Go to SPRO, IMG, search for IDoc.  
Basic settings are rarely changed and are defined for the whole system.
These include unique IDoc number range in transaction OYSN, global IDoc interface parameters in transaction
WE46 and coupling IDoc creation and IDoc processing in IMG, Activate event receiver linkage for IDoc inbound.  
Communication settings are made once and are independent of both transactions and business partners.  
There include setting an RFC destination in transaction SM59, port definition in transaction WE21.  

### RFC destination

RFC destination links to the subsystem program and can be skipped if the subsystem isn't installed.  
If that is so, the subsystem program will have to be run periodically to process IDocs.  
RFC destination is a logical name to identify a remote system on which a function has to be executed.  
There are two prerequisites for executing a function remotely: system should see each other via TCP/IP and a system 
level SAP user ID must be able to start a he program remotely and program that implements the functions must use RFC
protocols.  

### Partner profiles

