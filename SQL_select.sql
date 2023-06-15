-- show databases;

use colonial;

/* Question 1 */

SELECT 
    TripName
FROM
    trip
WHERE
    season LIKE 'Late Spring';

/* Question 2 */

SELECT 
    TripName
FROM
    trip
WHERE
    State LIKE 'VT' OR MaxGrpSize > 10;

/* Question 3 */

SELECT 
    TripName
FROM
    trip
WHERE
    Season IN ('Early Fall' , 'Late Fall');

/* Question 4 */

SELECT 
    COUNT(1)
FROM
    trip
WHERE
    State IN ('VT' , 'CT');
    
/* Question 5 */

SELECT 
    TripName
FROM
    trip
WHERE
    State NOT LIKE 'NH';


/* Question 6 */
SELECT 
    TripName, StartLocation
FROM
    trip
WHERE
    Type LIKE 'Biking';
    




/* Question 7 */
SELECT 
    TripName
FROM
    trip
WHERE
    Type LIKE 'Hiking' AND Distance > 6
ORDER BY TripName;



/* Question 8 */
SELECT 
    TripName
FROM
    trip
WHERE
    State LIKE 'VT' OR Type LIKE 'Paddling';

/* Question 9 */


SELECT 
    COUNT(1)
FROM
    trip
WHERE
    Type IN ('Hiking' , 'Biking');

/* Question 10 */
SELECT 
    TripName, State
FROM
    trip
WHERE
    Season LIKE 'Summer'
ORDER BY state , TripName;


/* Question 11 */

SELECT 
    TripName
FROM
    trip
        JOIN
    tripguides ON trip.TripID = tripguides.TripID
        JOIN
    guide ON tripguides.GuideNum = guide.GuideNum
WHERE
    FirstName LIKE 'Miles'
        AND LastName LIKE 'Abrams';


/* Question 12 */

SELECT 
    TripName
FROM
    trip
        JOIN
    tripguides ON trip.TripID = tripguides.TripID
        JOIN
    guide ON tripguides.GuideNum = guide.GuideNum
WHERE
    FirstName LIKE 'Rita'
        AND LastName LIKE 'Boyers'
        AND trip.Type LIKE 'Biking';


/* Question 13 */

SELECT 
    LastName, TripName, StartLocation
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
        JOIN
    customer ON reservation.CustomerNum = customer.CustomerNum
WHERE
    TripDate LIKE '2018-07-23';

/* Question 14 */

SELECT 
    count(1)
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
WHERE reservation.TripPrice >= 50 and  reservation.TripPrice <=100;

/* Question 15 */

SELECT 
    LastName, TripName, Type
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
        JOIN
    customer ON reservation.CustomerNum = customer.CustomerNum
WHERE
    TripPrice > 100;


/* Question 16 */

SELECT 
    LastName
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
        JOIN
    customer ON reservation.CustomerNum = customer.CustomerNum
WHERE
    trip.State like "ME";

/* Question 17 */

SELECT 
    State, COUNT(1) AS number_of_trips
FROM
    trip
GROUP BY State
ORDER BY State;

/* Question 18 */

SELECT 
    reservation.ReservationID,LastName, TripName
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
        JOIN
    customer ON reservation.CustomerNum = customer.CustomerNum
WHERE
    reservation.NumPersons > 4;


/* Question 19 */

SELECT 
    TripName, guide.LastName, guide.FirstName 
FROM
    trip
        JOIN
    tripguides ON trip.TripID = tripguides.TripID
        JOIN
    guide ON tripguides.GuideNum = guide.GuideNum
WHERE
    trip.State like "NH";

/* Question 20 */
SELECT 
    reservation.ReservationID,customer.CustomerNum,LastName, FirstName 
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
        JOIN
    customer ON reservation.CustomerNum = customer.CustomerNum
WHERE
    substring(reservation.TripDate,1,7) like "2018-07";

/* Question 21 */

SELECT 
    reservation.ReservationID,
    trip.TripName,
    LastName,
    FirstName,
    (TripPrice + OtherFees) * NumPersons AS TotalCost
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
        JOIN
    customer ON reservation.CustomerNum = customer.CustomerNum
WHERE
    reservation.NumPersons > 4;

/* Question 22 */
SELECT 
    customer.CustomerNum, LastName, FirstName
FROM
    customer
WHERE
    FirstName LIKE 'S%'
        OR FirstName LIKE 'L%';

/* Question 23 */
SELECT 
    distinct trip.TripName
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
WHERE
    reservation.TripPrice BETWEEN 30 AND 50;

/* Question 24 */

SELECT 
    count(*)
FROM
    trip
        JOIN
    reservation ON trip.TripID = reservation.TripID
WHERE
    reservation.TripPrice BETWEEN 30 AND 50;


/* Question 25 */
SELECT 
    trip.TripID,trip.TripName, reservation.ReservationID 
FROM
    trip
        left JOIN
    reservation ON trip.TripID = reservation.TripID
WHERE
    reservation.ReservationID is NULL;

/* Question 26 */
SELECT 
    *
FROM
    trip AS t1
        JOIN
    trip AS t2 ON t1.StartLocation = t2.StartLocation
        AND t1.TripID < t2.tripID;
        
/* Question 27 */
SELECT DISTINCT
    c.*
FROM
    customer AS c
        LEFT JOIN
    reservation AS r ON c.CustomerNum = r.CustomerNum
WHERE
    State like 'NJ'
        OR r.ReservationID IS NOT NULL;

/* Question 28 */

SELECT 
    firstname, lastname
FROM
    guide g
    left join tripguides tg on tg.GuideNum = g.GuideNum
    where tg.TripID is NULL;

/* Question 29 */


SELECT 
    *
FROM
    guide AS t1
        JOIN
    guide AS t2 ON t1.State = t2.State
        AND t1.GuideNum < t2.GuideNum;

/* Question 30 */

SELECT 
    *
FROM
    guide AS t1
        JOIN
    guide AS t2 ON t1.City = t2.City
        AND t1.GuideNum < t2.GuideNum;

use entertainmentagencyexample;

/* Question 1 */
SELECT 
    agtlastname, agtfirstname, agtphonenumber
FROM
    agents
ORDER BY agtlastname , agtfirstname;

/* Question 2 */

SELECT 
    engagementnumber, startdate
FROM
    engagements
ORDER BY startdate DESC , engagementnumber;

/* Question 3 */
SELECT 
    agtfirstname,
    agtlastname,
    datehired,
    DATE_ADD(datehired, INTERVAL 6 MONTH) AS first6monthreview
FROM
    agents;

/* Question 4 - ASK*/
SELECT 
    *
FROM
    engagements
WHERE
    MONTH(startdate) = 10
        AND MONTH(enddate) = 10
        AND YEAR(startdate) = 2017;

/* Question 5 - Ask*/

SELECT 
    *
FROM
    engagements
WHERE
    MONTH(startdate) = 10
        AND MONTH(enddate) = 10
        AND year(startdate) = 2017
        AND starttime between '12:00:00' and '17:00:00';

/* Question 6 */
SELECT 
    *
FROM
    engagements
WHERE startdate = enddate;


/* Question 7 */

SELECT 
    distinct agtfirstname, agtlastname, startdate, enddate
FROM
    agents a
        JOIN
    engagements e ON a.agentid = e.agentid
ORDER BY startdate;


/* Question 8 */
SELECT DISTINCT
    c.custfirstname, c.custlastname, entstagename
FROM
    customers c
        JOIN
    engagements eg
        JOIN
    entertainers e ON c.customerid = eg.customerid
        AND eg.entertainerid = e.entertainerid; 

/* Question 9 */

SELECT DISTINCT
    a.agtfirstname, a.agtlastname, e.entstagename
FROM
    agents a
        JOIN
    entertainers e ON a.agtzipcode = e.entzipcode; 

/* Question 10 */


SELECT 
    entstagename, entphonenumber, entcity
FROM
    entertainers
WHERE
    entcity IN ('Bellevue' , 'Redmond', 'Woodinville');

/* Question 11 */

SELECT 
    *
FROM
    engagements
WHERE
    DATEDIFF(enddate, startdate) = 3;


/* Question 12 */

SELECT 
    entstagename, startdate, enddate, contractprice
FROM
    entertainers ent
        JOIN
    engagements eng ON ent.entertainerid = eng.entertainerid;

/* Question 13 */
SELECT 
    entstagename, startdate, enddate, contractprice
FROM
    entertainers ent
        JOIN
    engagements eng ON ent.entertainerid = eng.entertainerid;

/* Question 14 */
SELECT DISTINCT
    ent.entertainerid, entstagename
FROM
    entertainers ent
        JOIN
    engagements eng ON ent.entertainerid = eng.entertainerid
        JOIN
    customers cust ON cust.customerid = eng.customerid
WHERE
    custlastname IN ('Berg' , 'Hallmark');
            

/* Question 15  */

SELECT 
    DISTINCT agtfirstname, agtlastname, startdate, enddate
FROM
    agents a
        JOIN
    engagements eng ON a.agentid = eng.agentid order by startdate;


/* Question 16 */
SELECT DISTINCT
    custfirstname, custlastname, entstagename
FROM
    entertainers ent
        JOIN
    engagements eng
        JOIN
    customers cust ON ent.entertainerid = eng.entertainerid
        AND cust.customerid = eng.customerid;

/* Question 17 */


SELECT DISTINCT
    agtfirstname, agtlastname, entstagename
FROM
    entertainers ent
        JOIN
    agents a ON  a.agtzipcode = entzipcode;


/* Question 18 */

SELECT DISTINCT
    entstagename
FROM
    entertainers ent
        LEFT JOIN
    engagements eng ON ent.entertainerid = eng.entertainerid
WHERE
    eng.entertainerid IS NULL;

/* Question 19 */
SELECT DISTINCT
    stylename, custfirstname, custlastname
FROM
    musical_styles ms
        LEFT JOIN
    musical_preferences mp ON mp.styleid = ms.styleid
        LEFT JOIN
    customers c ON c.customerid = mp.customerid
ORDER BY stylename;

/* Question 20 */

SELECT DISTINCT
    agtfirstname, agtlastname, entstagename
FROM
    agents a
        LEFT JOIN
    engagements eng ON a.agentid = eng.agentid
        LEFT JOIN
    entertainers ent ON ent.entertainerid = eng.entertainerid
WHERE
    entstagename IS NULL;

/* Question 21 */

SELECT DISTINCT
    custfirstname, custlastname, engagementnumber
FROM
    customers cust
        LEFT JOIN
    engagements eng ON cust.customerid = eng.customerid
WHERE
    engagementnumber IS NULL;

/* Question 22 */

SELECT
	DISTINCT C.* , ENT.*
FROM 	
	ENTERTAINMENTAGENCYEXAMPLE.CUSTOMERS C
LEFT JOIN
	ENTERTAINMENTAGENCYEXAMPLE.ENGAGEMENTS E
ON
	E.CUSTOMERID = C.CUSTOMERID
LEFT JOIN 
	ENTERTAINMENTAGENCYEXAMPLE.ENTERTAINERS ENT 
ON 
	E.ENTERTAINERID = ENT.ENTERTAINERID
UNION
SELECT
	DISTINCT C.* , ENT.*
FROM 	
	ENTERTAINMENTAGENCYEXAMPLE.ENTERTAINERS ENT 
LEFT JOIN
	ENTERTAINMENTAGENCYEXAMPLE.ENGAGEMENTS E
ON
	E.ENTERTAINERID = ENT.ENTERTAINERID
LEFT JOIN 
	ENTERTAINMENTAGENCYEXAMPLE.CUSTOMERS C
ON 
	E.CUSTOMERID = C.CUSTOMERID
	;

/* Question 24 */

SELECT DISTINCT
    C.custfirstname,
    C.custlastname,
    CMS.stylename,
    ENT.entstagename
FROM
    CUSTOMERS C
        JOIN
    MUSICAL_PREFERENCES CMP
        JOIN
    MUSICAL_STYLES CMS ON CMP.CUSTOMERID = C.CUSTOMERID
        AND CMS.STYLEID = CMP.STYLEID
        LEFT JOIN
    ENGAGEMENTS E ON E.CUSTOMERID = C.CUSTOMERID
        LEFT JOIN
    ENTERTAINERS ENT ON E.ENTERTAINERID = ENT.ENTERTAINERID
WHERE
    UPPER(CMS.STYLENAME) = 'CONTEMPORARY' 
UNION SELECT DISTINCT
    C.custfirstname,
    C.custlastname,
    EMS.stylename,
    ENT.entstagename
FROM
    ENTERTAINERS ENT
        JOIN
    ENTERTAINER_STYLES EMP
        JOIN
    MUSICAL_STYLES EMS ON EMP.ENTERTAINERID = ENT.ENTERTAINERID
        AND EMS.STYLEID = EMP.STYLEID
        LEFT JOIN
    ENGAGEMENTS E ON E.ENTERTAINERID = ENT.ENTERTAINERID
        LEFT JOIN
    CUSTOMERS C ON E.CUSTOMERID = C.CUSTOMERID
WHERE
    UPPER(EMS.STYLENAME) = 'CONTEMPORARY';

/*Question 25*/

SELECT DISTINCT
    A.agtfirstname, A.agtlastname, ENT.entstagename
FROM
    AGENTS A
        LEFT JOIN
    ENGAGEMENTS E ON A.AGENTID = E.AGENTID
        LEFT JOIN
    ENTERTAINERS ENT ON E.ENTERTAINERID = ENT.ENTERTAINERID 
UNION SELECT DISTINCT
    A.agtfirstname, A.agtlastname, ENT.entstagename
FROM
    ENTERTAINERS ENT
        LEFT JOIN
    ENGAGEMENTS E ON E.ENTERTAINERID = ENT.ENTERTAINERID
        LEFT JOIN
    AGENTS A ON E.AGENTID = A.AGENTID;


/* Accounts Payable */

use accountspayable;

/*Question 1*/
select * from invoices;

/*Question 2*/
SELECT 
    invoice_number, invoice_date, invoice_total
FROM
    invoices
ORDER BY invoice_total desc;

/*Question 3 Case 1*/
SELECT 
    *
FROM
    invoices
WHERE
    MONTH(invoice_date) = 6;

/*Question 3 Case 2*/
SELECT 
    *
FROM
    invoices
WHERE
    MONTH(invoice_date) >= 6;
    


/*Question 4*/

SELECT 
    *
FROM
    vendors
ORDER BY vendor_contact_last_name , vendor_contact_first_name;

/*Question 5*/

SELECT 
    vendor_contact_last_name, vendor_contact_first_name
FROM
    vendors
WHERE
    LEFT(vendor_contact_last_name, 1) IN ('A' , 'B', 'C', 'E')
ORDER BY vendor_contact_last_name , vendor_contact_first_name;

/*Question 6*/

SELECT 
    invoice_due_date, invoice_total*1.1
FROM
    invoices
WHERE
    invoice_total between 500 and 1000;

/*Question 7*/

SELECT 
    invoice_number,
    invoice_total,
    payment_total + credit_total as payment_credit_total,
    invoice_total - payment_total - credit_total AS balance_total
FROM
    invoices
WHERE
    invoice_total - payment_total - credit_total> 50
ORDER BY balance_total DESC
LIMIT 5;


/*Question 8*/
SELECT 
    *
FROM
    invoices
WHERE
    invoice_total - payment_total - credit_total > 0;

/*Question 9*/

SELECT DISTINCT
    vendor_name
FROM
    invoices inv
        JOIN
    vendors ve ON inv.vendor_id = ve.vendor_id
WHERE
    invoice_total - payment_total - credit_total > 0;


/*Question 10*/

SELECT 
    ve.*, acc.account_description
FROM
    vendors ve
        JOIN
    general_ledger_accounts acc ON ve.default_account_number = acc.account_number;
    
/*Question 11*/

SELECT 
    *
FROM
    vendors ve
        LEFT JOIN
    invoices inv ON ve.vendor_id = inv.vendor_id
	join invoice_line_items li on inv.invoice_id = li.invoice_id;

/*Question 12*/

SELECT 
ve1.*
FROM
    vendors ve1
        JOIN
    vendors ve2 ON ve1.vendor_id != ve2.vendor_id
        AND ve1.vendor_contact_last_name = ve2.vendor_contact_last_name;

/*Question 13*/

SELECT DISTINCT
    la.account_number
FROM
    general_ledger_accounts la
        LEFT JOIN
    vendors ve ON ve.default_account_number = la.account_number
        LEFT JOIN
    invoice_line_items ili ON la.account_number = ili.account_number
WHERE
    ve.default_account_number IS NULL
        AND ili.account_number IS NULL
ORDER BY la.account_number;

/*Question 14*/

SELECT 
    vendor_name,
    CASE
        WHEN vendor_state = 'CA' THEN vendor_state
        ELSE 'Outside CA'
    END AS vendor_state
FROM
    vendors
ORDER BY vendor_name;


