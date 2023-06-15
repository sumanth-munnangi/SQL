-- Create the table
-- Bonus Q1

DROP TABLE IF EXISTS #TableValues;
CREATE TABLE #TableValues(ID INT, Data INT);
-- Populate the table
INSERT INTO #TableValues(ID, Data)
VALUES(1,100),(2,100),(3,NULL),
(4,NULL),(5,600),(6,NULL),
(7,500),(8,1000),(9,1300),
(10,1200),(11,NULL);
-- Display the results


with tempdata as
(SELECT ID, count(data) over ( order by ID) New, data FROM #TableValues)

select ID, FIRST_VALUE(data) over (partition by New  order by ID) Data  from tempdata;



-- Bonus Q2 

-- Create the temp table
DROP TABLE IF EXISTS #Registrations;
CREATE TABLE #Registrations(ID INT NOT NULL IDENTITY PRIMARY KEY,
DateJoined DATE NOT NULL, DateLeft DATE NULL);

-- Variables
DECLARE @Rows INT = 10000,
@Years INT = 5,
@StartDate DATE = '2011-01-01'
-- Insert 10,000 rows with five years of possible dates
INSERT INTO #Registrations (DateJoined)
SELECT TOP(@Rows) DATEADD(DAY,CAST(RAND(CHECKSUM(NEWID())) * @Years *
365 as INT) ,@StartDate)
FROM sys.objects a
CROSS JOIN sys.objects b
CROSS JOIN sys.objects c;
-- Give cancellation dates to 75% of the subscribers
UPDATE TOP(75) PERCENT #Registrations
SET DateLeft = DATEADD(DAY,CAST(RAND(CHECKSUM(NEWID())) * @Years * 365
as INT),DateJoined);


with joined_count AS (
select EOMONTH(DateJoined,0) DateJoined, count(ID) as joined_count from #Registrations 
GROUP BY EOMONTH(DateJoined,0)),

left_count AS(
select EOMONTH(DateLeft,0) DateLeft, count(ID) as Left_count from #Registrations
WHERE DateLeft is not null
GROUP BY EOMONTH(DateLeft,0)),

left_rolling AS(
select coalesce( j.DateJoined,l.DateLeft) MonthEnding,
coalesce(j.joined_count,0) as NumberSubscribed,
coalesce(l.Left_count,0) as NumberUnsubscribed
FROM joined_count j full outer join left_count l 
on j.DateJoined = l.DateLeft),

final_rolling as  (
SELECT *,
sum(NumberUnsubscribed) over(order by MonthEnding RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as roll_left,
sum(NumberSubscribed) over(order by MonthEnding RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as roll_joined
from left_rolling)



select 
MonthEnding, 
NumberSubscribed, 
NumberUnsubscribed, 
(roll_joined - roll_left) as ActiveSubscriptions 
FROM final_rolling;


-- Bonus Q3

-- Create the table
DROP TABLE IF EXISTS #TimeCards;
CREATE TABLE #TimeCards(
TimeStampID INT NOT NULL IDENTITY PRIMARY KEY,
EmployeeID INT NOT NULL,
ClockDateTime DATETIME2(0) NOT NULL,
EventType VARCHAR(5) NOT NULL);
-- Populate the table
INSERT INTO #TimeCards(EmployeeID,
ClockDateTime, EventType)
VALUES
(1,'2021-01-02 08:00','ENTER'),
(2,'2021-01-02 08:03','ENTER'),
(2,'2021-01-02 12:00','EXIT'),
(2,'2021-01-02 12:34','ENTER'),
(3,'2021-01-02 16:30','ENTER'),
(2,'2021-01-02 16:00','EXIT'),
(1,'2021-01-02 16:07','EXIT'),
(3,'2021-01-03 01:00','EXIT'),
(2,'2021-01-03 08:10','ENTER'),
(1,'2021-01-03 08:15','ENTER'),
(2,'2021-01-03 12:17','EXIT'),
(3,'2021-01-03 16:00','ENTER'),
(1,'2021-01-03 15:59','EXIT'),
(3,'2021-01-04 01:00','EXIT');



select EmployeeID, convert(varchar(10),(ClockDateTime),111) as WorkDate, 
RIGHT('0' + convert(varchar(5),sum(DateDiff(s, lag_time, ClockDateTime)/3600)),2)+':'
+RIGHT('0' +convert(varchar(5),sum(DateDiff(s, lag_time, ClockDateTime)%3600/60)),2)+':'
+RIGHT('0'+convert(varchar(5),sum(DateDiff(s, lag_time, ClockDateTime)%60)),2) AS TimeWorked from 
(select *, lag(ClockDateTime) over (partition by EmployeeID order by TimeStampID) as lag_time from #TimeCards) lag_table
where EventType like 'EXIT'
group by EmployeeID, convert(varchar(10),(ClockDateTime),111)
order by 1;



-- Bonus Q4 

-- Create the table
DROP TABLE IF EXISTS #FolderHierarchy;
GO
-- Create the table
CREATE TABLE #FolderHierarchy
(
ID INTEGER PRIMARY KEY,
Name VARCHAR(100),
ParentID INTEGER
);
GO
-- Populate the table
INSERT INTO #FolderHierarchy VALUES
(1, 'my_folder', NULL),
(2,'my_documents', 1),
(3, 'events', 2),
(4, 'meetings', 3),
(5, 'conferences', 3),
(6, 'travel', 3),
(7, 'integration', 3),
(8, 'out_of_town', 4),
(9, 'abroad', 8),
(10, 'in_town', 4);
GO


with base_cte as (

SELECT ID , Name, ParentID, CAST('My Folder' as varchar(200)) AS path from #FolderHierarchy
where ParentID IS NULL
UNION ALL
SELECT fol.ID , fol.Name, fol.ParentID, CAST(CONCAT_WS(' / ', base.path, fol.Name) as Varchar(200)) AS path
from #FolderHierarchy fol
join base_cte base
ON fol.ParentID = base.ID
)

select * from base_cte;

-- Bonus Question 5 

DROP TABLE IF EXISTS #Destination;
GO
-- Create the table
CREATE TABLE #Destination
(
ID INTEGER PRIMARY KEY,
Name VARCHAR(100)
);
GO
-- Populate the table
INSERT INTO #Destination VALUES
(1, 'Warsaw'),
(2,'Berlin'),
(3, 'Bucharest'),
(4, 'Prague');
GO
DROP TABLE IF EXISTS #Ticket;
GO
-- Create the table
CREATE TABLE #Ticket
(
CityFrom INTEGER,
CityTo INTEGER,
Cost INTEGER
);
GO
-- Populate the table
INSERT INTO #Ticket VALUES
(1, 2, 350),
(1, 3, 80),
(1, 4, 220),
(2, 3, 410),
(2, 4, 230),
(3, 2, 160),
(3, 4, 110),
(4, 2, 140),
(4, 3, 75);
GO

with name_base_cte as (
select t.*, 
d1.Name as CityFromName, 
d2.Name as CityToName 
from #Ticket t
join #Destination d1
ON t.CityFrom = d1.ID
join #Destination d2
ON t.CityTo = d2.ID)

,

recur_cte as (
select cast(CONCAT_WS(' -> ' ,CityFromName, CityToName) as varchar(200)) AS Path,
CityTo as LastID, CityFrom, Cost, 2 as NumberPlacesVsited
from name_base_cte
where CityFrom = 1
union ALL
select cast(CONCAT_WS(' -> ' ,r1.Path, n2.CityToName) as varchar(200)) AS Path,
n2.CityTo as LastID, n2.CityFrom, r1.Cost + n2.Cost as Cost, r1.NumberPlacesVsited + 1 as NumberPlacesVsited
from recur_cte r1
inner join name_base_cte n2
on r1.LastID = n2.CityFrom 
where r1.Path not like '%'+n2.CityToName+'%' 
)

select Path,LastID,Cost,NumberPlacesVsited from recur_cte 
where NumberPlacesVsited = 4
order by Cost DESC;




