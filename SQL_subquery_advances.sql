IF OBJECT_ID('tempdb.dbo.#GameScores','U') IS NOT NULL
DROP TABLE #GameScores;
GO
CREATE TABLE #GameScores
(
FirstPlayer VARCHAR(10),
SecondPlayer VARCHAR(10),
Score INTEGER
);
GO
INSERT INTO #GameScores VALUES
('Joe','Ryan', 120),
('Sue', 'Jackie', 200),
('Ryan', 'Sue', 50),
('Ryan', 'Joe', 100);
GO


-- Question 1 





select FirstPlayer, SecondPlayer, score  from
( 
select  
game1.FirstPlayer, 
game1.SecondPlayer, 
game1.Score + coalesce (game2.Score,0) as Score , 
(case when game1.FirstPlayer < game2.FirstPlayer or  (game2.Score is null) then 1 else 0 end) as flag
from

(select concat(FirstPlayer,SecondPlayer) as Full_name, * 
from [dbo].[#GameScores] ) as game1

left join 

(select concat(SecondPlayer,FirstPlayer) as Full_name, * 
from [dbo].[#GameScores] ) as game2 

on game1.Full_name = game2.Full_name
) as final
where flag = 1;



-- Quesiton 2

IF OBJECT_ID('tempdb.dbo.##DetailedSchedule','U') IS NOT NULL
DROP TABLE ##DetailedSchedule;
GO
CREATE TABLE ##DetailedSchedule
(
StartDate DATE,
EndDate DATE
);
GO
INSERT INTO ##DetailedSchedule VALUES
('1/11/2022','1/13/2022'),
('1/11/2022','1/15/2022'),
('1/11/2022','1/12/2022'),
('1/13/2022','1/19/2022'),
('1/20/2022','1/22/2022'),
('1/24/2022','1/26/2022'),
('1/25/2022','1/29/2022');
GO


select min(StartDate) as StartDate, EndDate from
( 
select  a.StartDate, max(b.enddate) as EndDate from
(select StartDate,max(EndDate) as EndDate from ##DetailedSchedule group by StartDate) as a
inner join 
(select StartDate,max(EndDate) as EndDate from ##DetailedSchedule group by StartDate) as b
on a.StartDate <> b.startdate or a.StartDate = b.startdate where b.startdate between a.startdate and a.enddate
group by a.StartDate
) as d
group by EndDate;



