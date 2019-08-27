use [SQL_Blog_Post];

--importing dataset--;

--KEY: ? - Next step to work on;
--????? - Reorganize code in the following format: 
-- drop tables code;;
-- cinci2 creation
-- timetable
-- incident
-- loctable
-- foreign keys and primary keys for cinci2
-- foreign and primary keys for time, incident, loctable;
-- Go back through and add notes plus the error message coding;

select count(*)
from cincifire;
--258365

select count(distinct EVENT_NUMBER)
FROM cincifire;
--258364


IF OBJECT_ID('dbo.cinci2', 'U') IS NOT NULL 
 DROP TABLE dbo.cinci2;

IF OBJECT_ID('dbo.timetable', 'U') IS NOT NULL 
  DROP TABLE dbo.timetable;

IF OBJECT_ID('dbo.incident', 'U') IS NOT NULL 
  DROP TABLE dbo.incident;

IF OBJECT_ID('dbo.loctable', 'U') IS NOT NULL 
  DROP TABLE dbo.loctable;


/*I need to create a new table that has no duplicates*/
--below I am figuring out how many characters are required for each
--column;

select max(len(EVENT_NUMBER)) from cincifire --14
select max(len(BEAT))from cincifire --14
select max(len(CREATE_TIME_INCIDENT_DATE)) from cincifire--19
select max(len(CREATE_TIME_INCIDENT_AMPM)) from cincifire-- 2

select	max(len(EVENT_NUMBER)) as eventID,--15
		MAX(LEN(CREATE_TIME_INCIDENT_DATE)) AS CREATEDAT,--10
		max(LEN(CREATE_TIME_INCIDENT_TOD)) AS TOD, --16
		MAX(len(ADDRESS_X)) AS ADDx, --62
		MAX(LEN(LATITUDE_X)) AS LAT, --7
		MAX(LEN(LONGITUDE_X)) AS LONG, --8
		MAX(LEN(AGENCY)) AS AGE, --3
		MAX(LEN(DISPOSITION_TEXT)) AS TEXT, --30 
		MAX(LEN(INCIDENT_TYPE_ID)) AS TYPEID, --19
		MAX(LEN(INCIDENT_TYPE_DESC)) AS TYPEDES, --85
		MAX(LEN(NEIGHBORHOOD)) AS NEIGH,--30
		max(len(BEAT)) AS BEAT, --
		MAX(LEN(CFD_INCIDENT_TYPE)) AS CFDI, --4
		MAX(LEN(CFD_INCIDENT_TYPE_GROUP)) AS CFDG, --55
		MAX(LEN(COMMUNITY_COUNCIL_NEIGHBORHOOD)) AS CCNEIGH --30
FROM cincifire

ALTER TABLE cincifire
ALTER COLUMN CREATE_TIME_INCIDENT_DATE date;

insert into cinci2(create_time_incident_date)
select CREATE_TIME_INCIDENT_DATE
FROM cincifire;

--ALTER TABLE cincifire ALTER COLUMN CREATE_TIME_INCIDENT_DATE DATE;
ALTER TABLE cincifire ALTER COLUMN CREATE_TIME_INCIDENT_TOD TIME;
ALTER TABLE cincifire ALTER COLUMN ARRIVAL_TIME_PRIMARY_UNIT_DATE DATE;
ALTER TABLE cincifire ALTER COLUMN ARRIVAL_TIME_PRIMARY_UNIT_TOD TIME;
ALTER TABLE cincifire ALTER COLUMN CLOSED_TIME_INCIDENT_DATE DATE;
ALTER TABLE cincifire ALTER COLUMN CLOSED_TIME_INCIDENT_TOD TIME;
ALTER TABLE cincifire ALTER COLUMN DISPATCH_TIME_PRIMARY_UNIT_DATE DATE;
ALTER TABLE cincifire ALTER COLUMN DISPATCH_TIME_PRIMARY_UNIT_TOD TIME;

select CREATE_TIME_INCIDENT_DATE, CREATE_TIME_INCIDENT_TOD,
		[ARRIVAL_TIME_PRIMARY_UNIT_DATE], [ARRIVAL_TIME_PRIMARY_UNIT_TOD],
		[CLOSED_TIME_INCIDENT_DATE], [CLOSED_TIME_INCIDENT_TOD],
		[DISPATCH_TIME_PRIMARY_UNIT_DATE],[DISPATCH_TIME_PRIMARY_UNIT_TOD]
FROM cincifire

--Everything appears to be fine, I am not sure how to do a thorough clean look at the data 
--other than to look at each row, (I can run a calculate query, or can I...).

--specifying the date type
select CREATE_TIME_INCIDENT_DATE from cincifire--date
select CREATE_TIME_INCIDENT_TOD from cincifire-- should be just time
select CREATE_TIME_INCIDENT_AMPM from cincifire-- varchar(2) might want to add the two columns


IF OBJECT_ID('dbo.cinci2', 'U') IS NOT NULL 
 DROP TABLE dbo.cinci2;

create table cinci2(event_number varchar(29), timeid varchar(35), locid varchar(84), incidentid varchar(81),
					create_time_incident_date date,create_time_incident_tod time,create_time_incident_ampm varchar(2),
					arrival_time_primary_unit_date date, arrival_time_primary_unit_tod time,arrival_time_primary_unit_ampm varchar(2),
					closed_time_incident_date date,closed_time_incident_tod time,closed_time_incident_ampm varchar(2),
					dispatch_time_primary_unit_date date,dispatch_time_primary_unit_tod time,dispatch_time_primary_unit_ampm varchar(2),
					address_x varchar(62),
					latitude_x float,--7
					longitude_x float,--8
					agency varchar(3),
					disposition_text varchar(30),
					incident_type_id varchar(19),
					incident_type_desc varchar(85),
					neighborhood varchar(30),
					beat varchar(14),
					cfd_incident_type varchar(4),
					cfd_incident_type_group varchar(55),
					community_council_neighborhood varchar(30)
					/*,PRIMARY KEY(event_number)*/);

insert into cinci2(event_number, timeid, locid, incidentid, create_time_incident_date,create_time_incident_tod,create_time_incident_ampm,
					arrival_time_primary_unit_date, arrival_time_primary_unit_tod,arrival_time_primary_unit_ampm,
					closed_time_incident_date,closed_time_incident_tod,closed_time_incident_ampm,
					dispatch_time_primary_unit_date,dispatch_time_primary_unit_tod,dispatch_time_primary_unit_ampm,
					address_x,latitude_x,longitude_x,agency,
					disposition_text,incident_type_id,incident_type_desc,
					neighborhood,beat,cfd_incident_type,cfd_incident_type_group,community_council_neighborhood)
select distinct[EVENT_NUMBER]+[BEAT], 
				concat([CREATE_TIME_INCIDENT_DATE],[CREATE_TIME_INCIDENT_TOD],[CREATE_TIME_INCIDENT_AMPM],[LATITUDE_X]),
				concat([BEAT],[AGENCY],[NEIGHBORHOOD],[LATITUDE_X], [LONGITUDE_X], [DISPATCH_TIME_PRIMARY_UNIT_TOD],[CLOSED_TIME_INCIDENT_TOD] ),
				concat([INCIDENT_TYPE_ID],[CLOSED_TIME_INCIDENT_TOD],[CREATE_TIME_INCIDENT_TOD],[DISPOSITION_TEXT]),
					CREATE_TIME_INCIDENT_DATE,[CREATE_TIME_INCIDENT_TOD],[CREATE_TIME_INCIDENT_AMPM],
					[ARRIVAL_TIME_PRIMARY_UNIT_DATE], [ARRIVAL_TIME_PRIMARY_UNIT_TOD],[ARRIVAL_TIME_PRIMARY_UNIT_AMPM],
					[CLOSED_TIME_INCIDENT_DATE],[CLOSED_TIME_INCIDENT_TOD],[CLOSED_TIME_INCIDENT_AMPM],
					[DISPATCH_TIME_PRIMARY_UNIT_DATE],[DISPATCH_TIME_PRIMARY_UNIT_TOD],[DISPATCH_TIME_PRIMARY_UNIT_AMPM],
					[ADDRESS_X],[LATITUDE_X],[LONGITUDE_X],[AGENCY],
					[DISPOSITION_TEXT],[INCIDENT_TYPE_ID],[INCIDENT_TYPE_DESC],
					[NEIGHBORHOOD],[BEAT],[CFD_INCIDENT_TYPE],[CFD_INCIDENT_TYPE_GROUP],[COMMUNITY_COUNCIL_NEIGHBORHOOD]--28 columns;
from cincifire;

--Msg 8152, Level 16, State 2, Line 47 String or binary data would be truncated.The statement has been terminated.;
-- I am going to go back and see which data string length is off by updating the datatype in the master table, cincifire.
--same message different line because of the code I added at the beginning to alter the data types;
--? Now look at all of the data types that aren't the dates and make sure the number of spaces is correct (I think I may have to update
--? the data type length in the cincifire data set before changing the length in the columns for cinci2;
-- Success, Event_number was the culprit 15 not 14 characters;

/* I could not add columns to cinci2, so I recreated the table.
ALTER TABLE cinci2
ADD timeid varchar(35) NULL;

ALTER TABLE cinci2
ALTER COLUMN timeid varchar(35) NOT NULL;
/*Msg 515, Level 16, State 2, Line 182
Cannot insert the value NULL into column 'timeid', table 'SQL_Blog_Post.dbo.cinci2'; column does not allow nulls. UPDATE fails.
The statement has been terminated.*/

INSERT INTO cinci2(timeid)
SELECT concat(create_time_incident_date,
						create_time_incident_tod, 
						create_time_incident_ampm,
						latitude_x)
FROM cinci2

--foreign key loctable
select count(distinct concat(beat,agency,
							neighborhood,latitude_x, 
							longitude_x, dispatch_time_primary_unit_tod, 
							closed_time_incident_tod))
from cinci2

select max(len(concat(beat,agency,
							neighborhood,latitude_x, 
							longitude_x, dispatch_time_primary_unit_tod, 
							closed_time_incident_tod)))
from cinci2
--84 = foreign key

--foreign key incident 
select count(distinct concat(incident_type_id, closed_time_incident_tod, 
			create_time_incident_tod, disposition_text))
from cinci2

select max(len(concat(incident_type_id, closed_time_incident_tod, 
			create_time_incident_tod, disposition_text)))
from cinci2
--81

ALTER TABLE cinci2
ADD incidentid varchar(81);

INSERT INTO cinci2(incidentid)
SELECT concat(incident_type_id, closed_time_incident_tod, 
			create_time_incident_tod, disposition_text)
FROM cinci2*/


---Create Time Table;


IF OBJECT_ID('dbo.timetable', 'U') IS NOT NULL 
  DROP TABLE dbo.timetable;

CREATE TABLE timetable(
		timekey varchar(31) PRIMARY KEY NOT NULL, --timekey= event_number 29+ ampm 2=31;
		timeidF varchar(35), create_date date, create_time time,
		arrival_date date, arrival_time time,
		dispatch_date date, dispatch_time time,
		closed_date date, closed_time time,
		/*PRIMARY KEY(timekey) NOT NULL*/);
/*/*Warning! The maximum key length is 900 bytes. The index 'PK__timetabl__82FB87EAA69A93C9' has maximum length of 1020 bytes. For some combination of large values, the insert/update operation will fail.
*/
/*resolved;
--SELECT COUNT(CREATE_TIME_INCIDENT)FROM cincifire
--258365 SAME AS THE EXCEL SPREADSHEET
--SELECT COUNT(*)
--FROM cincifire
--516730 VERY DIFFERENT
*/

/*--alter column names

use SQL_Blog_Post;

GO  
EXEC sp_rename 'Createvent', 
				'timekey', 
				'COLUMN';  
GO  
above not working
*/

select count(distinct EVENT_NUMBER)
FROM cincifire;

--258364
--one matching EventNumber?

SELECT *
FROM cincifire
--many nulls!!!

--ALTER TABLE dbo.timetable --Doing this to make the adding of the two columns possible
--ALTER COLUMN Createvent nvarchar(510)
--select max(len(event_number)) from cinci2 29
*/

select count(distinct event_number) from cinci2
select count(event_number) from cinci2 where event_number IS NULL --0 nulls for event
select count(create_time_incident_ampm) from cinci2 where create_time_incident_ampm IS NULL; --0


insert into timetable(timekey, create_date, create_time, arrival_date, arrival_time, dispatch_date, dispatch_time, closed_date, closed_time)
select ([event_number]+[create_time_incident_ampm]), 
		create_time_incident_date,create_time_incident_tod,
		arrival_time_primary_unit_date, arrival_time_primary_unit_tod,
		dispatch_time_primary_unit_date, dispatch_time_primary_unit_tod,
		closed_time_incident_date,closed_time_incident_tod
from cinci2;

/* Resolved
/*Msg 242, Level 16, State 3, Line 98
The conversion of a nvarchar data type to a datetime data type resulted in an out-of-range value.
The statement has been terminated.*/*/
--column length appears to be the issue;

---Create Location Table;


IF OBJECT_ID('dbo.loctable', 'U') IS NOT NULL 
  DROP TABLE dbo.loctable;

select max(len(concat(event_number,longitude_x,latitude_x))) as lockey,
		max(len(address_x)) as address_x,
		max(len(latitude_x)) as lat_x,
		max(len(longitude_x)) as long_x,
		max(len(neighborhood)) as neighborhood, 
		max(len(community_council_neighborhood)) as cc_neighborhood
from cinci2

/*
lockey	address_x	lat_x	long_x	neighborhood	cc_neighborhood
44		62			7		8		30				30
*/
CREATE TABLE loctable(
		lockey varchar(44), --lockey= event_number 29+ longitude_x 7+ latitude_x 8 = 44; 
		locidF varchar(84),
		addressx varchar(62), 
		latx float, longx float, 
		neighborhood varchar(30), 
		ccneighborhood nvarchar(30)
		/*PRIMARY KEY(lockey)*/);

--Warning! The maximum key length is 900 bytes. The index 'PK__loctable__B2B442466D9298C7' has maximum length of 1020 bytes. For some combination of large values, the insert/update operation will fail.

--select max(len(longitude_x)) from cinci2 8
--select max(len(latitude_x)) from cinci2 7

INSERT INTO dbo.loctable(lockey, addressx, latx, longx, neighborhood, ccneighborhood)
SELECT concat(event_number,longitude_x,latitude_x), 
		address_x,
		latitude_x,
		longitude_x, 
		neighborhood, 
		community_council_neighborhood
FROM cinci2;

/*resolved! lockey was the culprit. My favorite message: Msg 8152, Level 16, State 14, Line 290
String or binary data would be truncated.
The statement has been terminated.
-- This means that I have a string that is longer than what I created for this table.*/

/*Msg 8114, Level 16, State 5, Line 160
Error converting data type nvarchar to float.*/

/*Msg 2627, Level 14, State 1, Line 159
Violation of PRIMARY KEY constraint 'PK__loctable__B2B44246691AB47F'. Cannot insert duplicate key in object 'dbo.loctable'. The duplicate key value is (AVONDALE-84.478639.1475).
The statement has been terminated.
*/--to resolve this I changed the primary key by removing neighborhood and replacing it with event_number


/* 1st attempt :
Msg 2627, Level 14, State 1, Line 157
Violation of PRIMARY KEY constraint 'PK__loctable__B2B442466D9298C7'. Cannot insert duplicate key in object 'dbo.loctable'. The duplicate key value is (-45.2137).
The statement has been terminated.
solution= adding another column to the primary key to make it more unique*/


-- Create Incident Table;


IF OBJECT_ID('dbo.incident', 'U') IS NOT NULL 
  DROP TABLE dbo.incident;

CREATE TABLE incident(incidentkey varchar(33), --incidentkey= cfd_incident_type 4 + even_number 29 = 33;
						incidentidF varchar(81),
						cfd_incident varchar(4), 
						cfd_incidentgroup varchar(55), 
						textdes varchar(30), 
						incidenttype varchar(19), 
						incidentdesc varchar(85),
						/*PRIMARY KEY(incidentkey)*/);

insert into incident(incidentkey, 
					cfd_incident, 
					cfd_incidentgroup,
					textdes, 
					incidenttype, 
					incidentdesc)
select concat(cfd_incident_type,event_number), 
		cfd_incident_type, 
		cfd_incident_type_group, 
		disposition_text, 
		incident_type_id, 
		incident_type_desc
from cinci2;--Success


-- # of rows 258365;

--??
--Next: How to link the different tables together? How to cut back on storage space (nvarchar(255) takes up a lot of space, can we limit that space?;  
--First create the ids inside the table cinci2? check results from class notes. Need to have the columns for the keys already in the cincifire table, too much data?
-- Connect with like columns or the keys?
/*
IF OBJECT_ID('dbo.cincifire','U') IS NOT NULL DROP TABLE cincifire;

SELECT DISTINCT event_number = IDENTITY(INT,1,1)
	, incidentkey
	, lockey
	, Createvent
INTO dbo.cincifire
FROM dbo.cinci2 C2
INNER JOIN dbo.timetable T 
on C2.time_id = T.CreateDate
INNER JOIN dbo.loctable L
on C2.loc_id = L.lockey
INNER JOIN dbo.incident I
on C2.incident_id = I.incidentkey;
*/
--Instead of completing the query directly above, I am going to add foreign keys to
--each table and link them that way.
--I am worried that the cinci2 table is to big and that adding 3 foreign keys might cause some issues...

/* I can't alter the primary key's storage capacity, time to rerun the query for the table with a shorter length
ALTER TABLE timetable
ALTER COLUMN Createvent nvarchar(100);
*/
--999.999 = 13 bytes, I think I can definitely limit the length of the column to 255 for Createvent
--the highest length is 31;


--Can't set event_number as primary key SOLVED with below code;

ALTER TABLE cinci2
ALTER COLUMN event_number VARCHAR(29) NOT NULL;--Success;

ALTER TABLE cinci2
ALTER COLUMN timeid varchar(35) NOT NULL;

ALTER TABLE cinci2
ALTER COLUMN locid varchar(84) NOT NULL;

ALTER TABLE cinci2
ALTER COLUMN incidentid varchar(81) NOT NULL;

ALTER TABLE cinci2
ADD PRIMARY KEY(event_number);--Success;

--Only one primary key is allowed;
/*ALTER TABLE cinci2
ADD PRIMARY KEY(timeid);

ALTER TABLE cinci2
ADD PRIMARY KEY(locid);

ALTER TABLE cinci2
ADD PRIMARY KEY(incidentid);
*/
--Adding the foreign keys to fact table
--since I already have these keys indexed I am not going to use the primary keys as FK in the Fact Table.
--https://www.mssqltips.com/sqlservertip/5690/create-a-star-schema-data-model-in-sql-server-using-the-microsoft-toolset/;
/*
ALTER TABLE cinci2
DROP CONSTRAINT [FK__cinci2__timekeyF__05D8E0BE];

ALTER TABLE cinci2
DROP CONSTRAINT [FK__cinci2__lockeyF__7F2BE32F];

ALTER TABLE cinci2
DROP CONSTRAINT [FK__cinci2__incident__7D439ABD];

ALTER TABLE cinci2
DROP COLUMN timekeyF

ALTER TABLE cinci2
DROP COLUMN incidentkeyF

ALTER TABLE cinci2
DROP COLUMN lockeyF

ALTER TABLE dbo.cinci2
DROP COLUMN timekeyF;

ALTER TABLE cinci2
DROP COLUMN timekeyF;

CREATE UNIQUE INDEX TIMEKEY
ON dbo.timetable(timekey)
GO

ALTER TABLE cinci2
ADD timekeyF varchar(31) not null
FOREIGN KEY REFERENCES dbo.timetable(timekey);

select timekeyF
from cinci2

/*ALTER TABLE cinci2
ADD timekeyF varchar(31) NOT NULL 
FOREIGN KEY REFERENCES dbo.timetable(timekey);--Success;*/

*/-- Just adding a foreign key is not working. I am going to try indexing.

--Now that we know that this works. Let's create primary keys for all of the other 
--tables and link them to cinci2 as foreign keys.
--??

ALTER TABLE loctable
ALTER COLUMN lockey varchar(44) NOT NULL;

ALTER TABLE	loctable
ADD PRIMARY KEY(lockey);--Success;

ALTER TABLE incident
ALTER COLUMN incidentkey varchar(33) NOT NULL;

ALTER TABLE incident
ADD PRIMARY KEY(incidentkey);--success;

--now let's add them as foreign keys to cinci2;

ALTER TABLE cinci2
ADD incidentkeyF varchar(33)  
FOREIGN KEY REFERENCES dbo.incident(incidentkey);--Success;

ALTER TABLE cinci2
ADD lockeyF varchar(44)  
FOREIGN KEY REFERENCES dbo.loctable(lockey);--Success;

--Success!!!! Finally!!!! Do I need to add Event_number as a foreign key to the 
--other tables?? No. add other ids to the other tables.

alter table timetable drop column timeidF;

ALTER TABLE timetable
ADD timeidF varchar(35)
FOREIGN KEY REFERENCES dbo.cinci2(timeid);

/*Msg 1776, Level 16, State 0, Line 454
There are no primary or candidate keys in the referenced table 'dbo.cinci2' that match the referencing column list in the foreign key 'FK__timetable__timei__00200768'.
Msg 1750, Level 16, State 0, Line 454
Could not create constraint or index. See previous errors.
*/

/*ALTER TABLE cinci2
DROP COLUMN timekeyF;*/

/*ALTER TABLE cinci2
ADD incidentkeyF nvarchar(100) 
FOREIGN KEY REFERENCES dbo.incident(incidentkey);

ALTER TABLE cinci2
ADD lockeyF nvarchar(100) 
FOREIGN KEY REFERENCES dbo.loctable(lockey);
--renamed on thedisplay everything to (name)F
Above queries not working*/

/*ALTER TABLE dbo.cinci2
ADD timekeyF nvarchar(100);

ALTER TABLE dbo.cinci2
ADD FOREIGN KEY (timekeyF)
REFERENCES dbo.timetable(timekey);
Above query just giving me nulls*/

--I think I need to create the foreign keys in the dimensional tables. I am going to do this using the click and save method;

ALTER TABLE cinci2
--ADD timekeyID varchar(50);
ALTER COLUMN timekeyID varchar(49)

ALTER TABLE cinci2
--ADD lockeyID varchar(50);
ALTER COLUMN lockeyID varchar(54)

ALTER TABLE cinci2
--ADD incidentID varchar(50);
ALTER COLUMN incidentID varchar(54)

select timekeyID, lockeyID, incidentID
from cinci2

-- timekeyID =event_nubmer 255 + create_time_ampm 10 = 265-216(old version) -->  49
-- lockeyID = event_number 255, longitude_x 8, latitude_x 7= 270 -216 --> 54
-- incidentID = cfd_incident_type 15 + event_number 255 =270-216--> 54;

-- ?? Foreign keys for the dimensional tables;;


ALTER TABLE timetable
ADD timeidF varchar(35)
FOREIGN KEY REFERENCES dbo.cinci2(timeid);

/*Msg 1776, Level 16, State 0, Line 526
There are no primary or candidate keys in the referenced table 'dbo.cinci2' 
that match the referencing column list in the foreign key 
'FK__timetable__timei__01142BA1'.
Msg 1750, Level 16, State 0, Line 526
Could not create constraint or index. See previous errors.*/
--Not a primary key, which is why this isn't working.
--Also, we already have a primary key, so we need to create a unique ID or a unique 
--constraint.
-- http://www.sql-server-helper.com/error-messages/msg-1776.aspx;

CREATE UNIQUE INDEX TIMEID
ON dbo.cinci2 (timeid)
GO

ALTER TABLE timetable
ADD timeidF varchar(35)
FOREIGN KEY REFERENCES dbo.cinci2(timeid);
-- Success!!!;


CREATE UNIQUE INDEX LOCID
ON dbo.cinci2 (locid)
GO

alter table loctable
drop column locidF;

ALTER TABLE loctable
ADD locidF varchar(84)
FOREIGN KEY REFERENCES dbo.cinci2(locid);

alter table incident
drop column incidentidF;

CREATE UNIQUE INDEX INCIDENTID
ON dbo.cinci2 (incidentid)
GO

ALTER TABLE incident
ADD incidentidF varchar(81)
FOREIGN KEY REFERENCES dbo.cinci2(incidentid);
--success!!!;;

use SQL_Blog_Post;

IF OBJECT_ID('dbo.practice', 'U') IS NOT NULL 
  DROP TABLE dbo.practice;

create table practice(names char(10), DOB datetime, height varchar(10), school char(20))
insert into practice values('George', '06/01/2000','6ft 10in', 'Milford Men')
/*Msg 8152, Level 16, State 14, Line 315
String or binary data would be truncated.
---This is because one of the values is longer than the columns' specified size. 
i think it is 
height: 10--> 18 Nope
school 10 -->20 (Milford Men = 11 spaces not 10) THAT WORKED!!!*/

use SQL_Blog_Post;

alter table practice
add pop_size nvarchar(3);

UPDATE dbo.practice
SET pop_size = '300';

/*
ALTER TABLE practice
ADD PRIMARY KEY(names);*/

alter table practice
add pop_id nvarchar(20)

alter table practice
add student_id varchar(20);


insert into dbo.practice(pop_id, student_id)
select concat(school, pop_size),concat(names,DOB)
from practice;

select *
from practice

INSERT INTO cinci2(timekeyID, lockeyID, incidentID)
select concat(create_time_incident_date, arrival_time_primary_unit_tod),
		concat(event_number,longitude_x,latitude_x), 
		concat(cfd_incident_type,event_number)
from cinci2

/*Msg 515, Level 16, State 2, Line 308
Cannot insert the value NULL into column 'event_number', table 'SQL_Blog_Post.dbo.cinci2'; column does not allow nulls. INSERT fails.
The statement has been terminated.
*/
--VICTORY!!!!
/*ALTER TABLE cinci2
DROP CONSTRAINT PRIMARY KEY(event_number); I DID UNDER THE KEYS FOLDER INSTEAD*/

SELECT *
FROM cinci2