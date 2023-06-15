use entertainmentagencyexample;
-- Question 1
SELECT 
    c.CustomerID, 
    CONCAT(c.CustFirstName, ' ',c.CustLastName) as CustomerName, 
    ms.StyleName, 
    count(1) over (partition by CustomerID) as TotalPreferences
FROM
    customers c
        JOIN
    musical_preferences mp ON c.CustomerID = mp.CustomerID
        JOIN
    musical_styles ms ON ms.StyleID = mp.StyleID;
    
-- Question 2

SELECT 
    c.CustomerID, 
    CONCAT(c.CustFirstName, ' ',c.CustLastName) as CustomerName, 
    ms.StyleName, 
    count(1) over (partition by CustomerID) as TotalPreferences,
    count(ms.StyleName) over (order by CONCAT(c.CustFirstName, ' ',c.CustLastName) RANGE between unbounded preceding and current row) as RunningSum
FROM
    customers c
        JOIN
    musical_preferences mp ON c.CustomerID = mp.CustomerID
        JOIN
    musical_styles ms ON ms.StyleID = mp.StyleID order by CustomerName;
    
-- Question 3

WITH SUM_CTE AS (
SELECT
	c.CustomerID
    ,CONCAT(c.custfirstname,", ",c.custlastname) AS Customer_name
    ,CustCity
    ,COUNT(mp.CustomerID) AS Pref_Cnt
FROM 
	customers c 
INNER JOIN
	musical_preferences mp
ON 
	c.CustomerID = mp.CustomerID
INNER JOIN
	musical_styles ms
ON 
	ms.StyleID = mp.StyleID
GROUP BY
	c.CustomerID
    ,CONCAT(c.custfirstname,", ",c.custlastname)
    ,CustomerID
)
SELECT
	*
    ,SUM(Pref_Cnt) OVER(PARTITION BY CustCity ORDER BY Customer_name) AS RUNNING_TOTAL_CITY
FROM 
	SUM_CTE;
    
-- Question 4

SELECT 
    c.CustomerID, 
    CONCAT(c.CustFirstName, ' ',c.CustLastName) as CustomerName, 
    c.CustState, 
    row_number() over (order by CONCAT(c.CustFirstName, ' ',c.CustLastName)) as CUST_ROW_NUMBER
FROM
    customers c;
    
-- Question 5

SELECT 
    c.CustomerID, 
    CONCAT(c.CustFirstName, ' ',c.CustLastName) as CustomerName, 
    c.CustCity,
    c.CustState,
    row_number() over (partition by c.CustCity, c.CustState order by CONCAT(c.CustFirstName, ' ',c.CustLastName)) as CUST_ROW_NUMBER_CITY_STATE
FROM
    customers c;
    
-- Question 6

SELECT 
    e.EngagementNumber,
    e.StartDate,
    CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName, en.EntStageName,
    count(en.EntStageName) over(partition by en.EntStageName rows between unbounded preceding and unbounded following) as total_Entertainer,
    count(1) over (partition by e.StartDate) as engagements_startdate
FROM
    engagements e
        JOIN
    customers c ON c.CustomerID = e.CustomerID
        JOIN
    entertainers en ON en.EntertainerID = e.EntertainerID;

-- Question 7

with q7_cte as(
SELECT 
    en.EntStageName, COUNT(*) Total_count, COUNT(e.EntertainerID) Ent_id_count
FROM
    entertainers en
        LEFT JOIN
    engagements e ON en.EntertainerID = e.EntertainerID
GROUP BY 1)

select EntStageName, Ent_id_count, 
dense_rank() over (order by Ent_id_count DESC) Rank_number, 
NTILE(3) OVER(ORDER BY Ent_id_count DESC) AS Bucket
from q7_cte;

-- Question 8

with q8_cte as(
SELECT 
    en.AgentID, sum(e.ContractPrice) Total_Price
FROM
    agents en
        LEFT JOIN
    engagements e ON en.AgentID = e.AgentID
GROUP BY 1)

select *, dense_rank() over (order by Total_Price DESC) as Price_rank from q8_cte;

-- Question 9


SELECT 
    en.EntStageName, CONCAT(c.CustFirstName, ' ', c.CustLastName) AS CustomerName,
    e.StartDate, count(en.EntStageName) over (partition by en.EntStageName) as engagement_count
FROM
    entertainers en
		JOIN
    engagements e ON en.EntertainerID = e.EntertainerID
            JOIN
    customers c ON c.CustomerID = e.CustomerID;
    
-- Question 10

SELECT 
    en.EntStageName,
    CONCAT(m.MbrFirstName, m.MbrLastName) AS Member_name,
    ROW_NUMBER() over ( partition by CONCAT(m.MbrFirstName, m.MbrLastName)) as Row_number_momber
FROM
    entertainers en
        JOIN
    entertainer_members enm ON en.EntertainerID = enm.EntertainerID
        JOIN
    members m ON m.MemberID = enm.MemberID
order by EntStageName;
    
-- ACCOUNTS PAYABLE DATABASE
use accountspayable;

-- Question 1

SELECT 
i.vendor_id,
invoice_total - (payment_total + credit_total) AS BalanceDue,
SUM(invoice_total - (payment_total + credit_total)) OVER (ORDER BY invoice_total - (payment_total + credit_total)) AS CumulativeBalance,
SUM(invoice_total - (payment_total + credit_total)) OVER (PARTITION BY i.vendor_id) AS TotalBalanceForAllVendor
FROM accountspayable.invoices i
WHERE (invoice_total - (payment_total + credit_total)) != 0;

-- Question 2

SELECT DISTINCT
vendor_id,
invoice_total - (payment_total + credit_total) AS BalanceDue,
SUM(invoice_total - (payment_total + credit_total)) OVER (PARTITION BY vendor_id) AS TotalBalanceForAllVendors,
SUM(invoice_total - (payment_total + credit_total)) OVER (ORDER BY vendor_id) CumulativeTotalBalance,
ROUND(AVG(invoice_total - (payment_total + credit_total)) OVER (ORDER BY vendor_id),2) CumulativeAvgBalance
FROM invoices 
WHERE (invoice_total - (payment_total + credit_total)) != 0;

-- Question 3

with total_inv_q3_cte as (
SELECT 
    invoice_date, SUM(invoice_total) AS invoice_total
FROM
    invoices
GROUP BY 1
order by 1)

select *, 
avg(invoice_total) over(order by invoice_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as three_month_moving_avg
from total_inv_q3_cte; 



