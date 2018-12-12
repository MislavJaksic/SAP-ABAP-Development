## IDoc

IDoc is an intermediate document with a similar use as XML, standardized data exchange.  
IDocs are stored in a database, have a unique number and can be viewed as text.  

### In EDI

EDI enabled applications first create an application document and them convert it into an IDoc.  

### In ALE

ALE enables exchange between two SAP systems and IDoc acts as a data container.  

### In Workflow

Workflow uses IDocs to enable the form interface and to enable exchange between workflows in different systems.  

### IDoc Tools

IDoc editor and Segment editor can enhance or create new IDocs.  
IDocs are monitored using everything from IDoc display to IDoc statistics.  
IDocs are tested using different tools.  

### IDoc Documentation

IDoc documentation can be viewed in transaction WE60.  

### IDoc Utilities

Standard function modules are available in function group EDI1.  

### IDoc components

Basic IDoc type (aka IDoc type, IDoc name) defines the structure of the IDoc.  
IDoc name is made up 8 characters, the first being Z if its a custom IDoc and the last two are version number.  
Each IDoc has a number of segments and each segment can have their own segments.  
Some segments are mandatory while others are optional.  
Range defines how many segments can there be under another segment or IDoc type.  
A segment is made up of data elements where each one has a type (and length).  
A segment has a type (aka segment name) which starts with Z if it is custom, segment definition can have up
to 1000 characters, start with E2 and a segment can have more then one segment definition.  
Is SAP segments are called with their type/name while outside SAP segments are called by their definition.  

### IDoc structure

IDocs are made up of a control record and many data records. To see the control record use the transaction SE11.  
