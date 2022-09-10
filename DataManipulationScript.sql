/* Welcome to your first SQL script!

In this script you will: 
1. Create a database schema
2. Insert data into your database
3. Query the data (and learn what all of this means)

Note: What are the # and astericks/slashes doing in here? 
In SQL, these symbols are used to create comments which are not part of what 
we want the computer to execute.
Comments are also generally a different text color for easy identification. (blue in this case)
*/

/*****************************************************************/
/* Step one: Create a schema

But first, what is a schema??
A schema is essentially a way to categorize a group of tables. (ex. if a 
database table is named Pharm.MockPharmacyData, the schema name is Pharm)

To create your first schema:
1. Highlight the below code with your mouse (Create schema Pharm;)
2. Click the lightening bolt to execute ( the lightening bolt is just right of the 
floppy disk/save icon which is above and to the left)
Note: semicolons are used to help the computer identify the end of the SQL statement. 
*/

Create schema Pharm;

/* To see your new schema:
 Click Schemas tab (up and to the left) -> Right-click sys -> Refresh All. You
should now see the Pharm schema. 
*/

/*****************************************************************/
/* Step two: Insert all data in MockPharmacyDispenseData.csv, 
  MockPatientData.csv, and DimDateTime.csv into the Pharm schema

Note: All data was created by an online fake data generator and there are no actual 
patient records or information used as part of this tutorial.

Right-click Pharm Schema -> Table Data Import Wizard -> browse to and select the 
  MockPharmacyDispenseData.csv file -> follow prompts until complete.
  
  Follow the same steps to import the DimDateTime.csv and Pharm.MockPatientData.csv 
  files into your database. 
  Afterwards, right-click the Pharm schema -> Refresh All.
  Now if you click the drop down arrow on the Pharm schema, then the drop down 
  arrow for Tables, you should see the names of the new tables.
  Congratulations! You now have a database with actual data in it.
*/

/*****************************************************************/
/* Step three: Query the data
Hightlight and execute (click the thunderbolt) the below code to see the top 
10 rows of data in the Pharm.mockpharmacydata table that were dispensed 
after 2019-10-01 ordered by dispense date.
*/

# Review a sample of the date table
SELECT *
FROM Pharm.dimdatetime
LIMIT 10;

# Review a sample of the dispense table
SELECT *
FROM Pharm.MockPharmacyDispenseData
ORDER BY DispensedDate DESC
LIMIT 10;

# Review a sample of the dispense table
SELECT *
FROM Pharm.MockPatientData
LIMIT 10;

/* So what just happened here?
There are 4 elements to the above queries:
	1. Select: this section identifies which columns you want to retrieve (* = all columns)
	2. From: this identifies the table to pull data from
	3. Order By: specifies which column(s) to sort the data by
	4. limit: reduces the amount of returned data. What happens if you remove/change this?

You'll find that SQL can be used to filter data to find all kinds of interesting 
information. 
Run the following query and consider why the output may be relevant.
*/

# Why is the output of this query interesting?
SELECT A.PatientID
      ,A.DispensedDate
      ,A.GenericName
      ,A.BrandName
FROM Pharm.MockPharmacyDispenseData AS A                                
WHERE GenericName LIKE '%warf%' 
   OR GenericName LIKE '%flucona%'; 
   
/*Notes for the above query:
1. concat() is used to join columns into a single text column
2. The "A.*" means to return ALL columns from the specified table (A)
3. 'AS A' is a way to alias/rename the table in the FROM statement. 
   This is useful when a query when a query contains multiple tables as we'll see later.
4. % are called wildcards and are used to find sub-text inside of a string of text.
*/

# Which patient was that?
SELECT DISTINCT CONCAT(LastName, ', ', FirstName) as PatientFullName 
FROM Pharm.MockPatientData
WHERE PatientID = 998349255

/* More about CONCAT():
In the sql language, there are commands (known as functions) that can be used
to make your life easier.

In the above query, we used concat() to join the FirstName and LastName columns
together into a new format.

Many, many other functions exist and can be found online. 
Some examples of useful functions include:
SUM(): sums the values within the column
AVG(): returns the average of the column
MAX(): return max value in column
        min(): return min value in column
        count(): return a count of the length of the table
        
There are many "flavors" of SQL out there. Functions in each language may operate 
slightly differently (just for your awareness).
*/

# Function examples:
SELECT COUNT(*) AS TotalRowCount
FROM Pharm.MockPharmacyDispenseData;

# Look at column date range
SELECT CAST(MAX(DateID) AS DATE) as MaxDate
      ,CAST(MIN(DateID) AS DATE) as MinDate
FROM Pharm.dimdatetime;

SELECT  CAST(MAX(DispensedDateID) AS DATE) as MaxDispenseDate
       ,CAST(MIN(DispensedDateID) AS DATE) as MinDispenseDate
FROM Pharm.MockPharmacyDispenseData;

/* Brief introduction to the Relational Database
1. A relational database consists of many tables that can be "joined" 
together using primary and foreign keys. (see lecture for more info)
    2. The primary key for the datetime table is DateID
    3. This primary key matches to the DispensedDateID foreign key in the 
       MockPharmacyDispenseData table
       
We will use the above knowledge of our data to join the Pharm.dimdatetime and 
Pharm.MockPharmacyDispenseData tables together in the following query.
*/

SELECT b.isweekend
      ,b.dayname
      ,a.*
FROM Pharm.MockPharmacyDispenseData as a     
JOIN Pharm.dimdatetime as b        # identifies the second table that we will match our Pharm.mockpharmacydata to
  ON a.DispensedDateID = b.DateID  # identifies the columns from both tables that we will match 
WHERE b.isweekend = 'Y';            # Return all prescriptions that were dispensed on a weekend

# In plain english, "return all prescription data from the mockpharmacydata table 
# that were dispensed on a weekend."

# Finally, we can use GROUP BY to group data in interesting ways. For example,
# this query allows us to identify the top 10 most frequently dispensed drugs.
# NOTE: the online fake data generator I used did not provide true brand names. 
# It's always important to explore and understand the limitations of the data
# available to you.

SELECT A.BrandName
      ,COUNT(*) AS DispenseCounts
FROM Pharm.MockPharmacyDispenseData as a 
GROUP BY A.BrandName
ORDER BY COUNT(*) DESC
LIMIT 10;

/*****************************************************************
Some questions you could attempt to answer:
	- How many total dispenses were completed on 2019-06-30?
      A: 4 total dispenses
    - In this script we identify a patient taking warfarin + fluconazole. Can you
      convert the two queries we used into a single query? 
      The output should be the fake patient's name only (HINT: use JOIN)
    - On which date were the most dispenses completed? (HINT: use GROUP BY)
      A: 2019-10-24; 10 dispenses
    
Last steps: Continue to explore on your own! Don't be afraid to make mistakes and 
always work to learn from the ones you make. Read error messages carefully. They 
typically contain useful hints. If not, search for the error messages online.

Check out sqlzoo.net to learn more SQL if you would like. Apply what you learn to
the data we imported above or import more data from available online data sets.

There are tons of free and interesting datasets all over the web just waiting to be explored.
There is also much more to learn about SQL if you are interested in pursuing a 
career in pharmacy data management. 
*/
