# SneezePharma in SQL  
Database for a fictional pharmacy, SneezePharma.  

The modeling of the database was made based on [this](https://app.brmodeloweb.com/#!/publicview/690d58909242e2a9d3b2959b) Entity Relationship Diagram and [this](https://www.drawdb.app/editor?shareId=0724d9333a7af8b9418816b7f4506c9b) Logical Data Model.
> [!Note]
> These scripts were made before gaining proper knowledge about triggers and procedures.
</br>

## Execution
Files included in this repository:
* [CREATE_DATABASE.sql](#create_databasesql)
* [ADD_KEY_CONSTRAINTS.sql](#add_key_constraintssql)
* [CREATE_TRIGGERS.sql](#create_triggerssql)
* [CREATE_PROCEDURES.sql](#create_proceduressql)
* [INSERT_DATA.sql](#insert_datasql)
* [CONSULT_DATA.sql](#consult_datasql)
* [CONSULT_REPORTS.sql](#consult_reportssql)

Before executing any file, make sure you are using either [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/ssms/install/install) or a Universal Database Tool and select MSSQL for the project.  
1. To **create the database** correctly, execute the first 4 files as listed above in the same order:  
```
CREATE_DATABASE.sql
ADD_KEY_CONSTRAINTS.sql
CREATE_TRIGGERS.sql
CREATE_PROCEDURES.sql
```
2. Once the database has been properly set up, you may execute `INSERT_DATA.sql` to **insert some standard example data** into all tables, or you can **manually insert data** by using `INSERT` statements in conjunction with the added procedures.
3. After the tables have been populated with data, execute `CONSULT_DATA.sql` or `CONSULT_REPORTS.sql`, or utilize the added procedures, to **show the inserted data**.
</br>

## Files

### Creating Database

1. #### CREATE_DATABASE.sql
Contains the script that creates the skeleton of the database.  
In it are statements that create all necessary tables for **Clients**, **Suppliers**, **Medicine**, **Ingredients**, **Purchases**, **Sales** and **Production** and all associative entities from their relations with each other.

2. #### ADD_KEY_CONSTRAINTS.sql
Contains the script for all foreign key constraints based on relations between entities.  
In addition, it also has statements for adding composite primary keys to the associative entities.

3. #### CREATE_TRIGGERS.sql
Contains the script for creating triggers used in the inserting of data in the database.  
In it are triggers that can:
* Block the deletion of data from tables, with the exception of *Restricted Clients* and *Blocked Suppliers*;
* Block *Purchases*, *Sales* and *Production* that include '**Inactive**' entities;
* Block *Production* if *Ingredient* hasn't been bought;
* Block *Sale* if *Medicine* hasn't been produced;
* Limit *Sales* and *Purchase Items* to 3 per ID.

4. #### CREATE_PROCEDURES.sql
Contains the script for creating procedures and types used for inserting and consulting data from the database.  
It in are procedures for:
* Inserting *Purchase Items* with a new *Purchase*
* Inserting *Sales Items* with a new *Sale*
* Inserting *Ingredients* with a new *Production*
* Inserting *Telephone* numbers with a new *Customer* account
* Generating reports for *Sales* per Period
* Generating reports for *Medicine* Most Sold
* Generating reports for *Purchases* per Supplier

### Inserting Data 

1. #### INSERT_DATA.sql
Contains script for inserting data into all tables in the database.  
For tables that ask for the date of transaction, instead of inserting a date, the column is left out to insert a default value of the current date.

### Selecting Data

1. #### CONSULT_DATA.sql
Contains script for consulting data using `SELECT ` and `JOIN` from all the main tables: **Clients**, **Suppliers**, **Medicine**, **Ingredients**, **Sales**, **Purchases** and **Production**.

2. #### CONSULT_REPORTS.sql
Contains script for generating reports using `SELECT` and `JOIN` with varying conditions.
The reports it can generate are:
* Sales per Period
* Medicine Most Sold
* Purchases per Supplier
