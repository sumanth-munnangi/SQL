use entertainmentagencyexample;

## Question 1

SELECT 
    CONCAT(c.custfirstname, ' ', c.custlastname) AS CustName,
    CASE
        WHEN
            stylename LIKE '40\'s%'
                OR stylename LIKE '50\'s%'
                OR stylename LIKE '60\'s%'
                OR stylename LIKE '70\'s%'
                OR stylename LIKE '80\'s%'
        THEN
            'Oldies'
        ELSE stylename
    END AS StyleName
FROM
    customers c
        JOIN
    musical_preferences mp ON c.customerid = mp.customerid
        JOIN
    musical_styles ms ON mp.styleid = ms.styleid;
    
## Question 2

SELECT 
    *
FROM
    engagements
WHERE
    HOUR(STR_TO_DATE(DATE_FORMAT(starttime, '%H:%i:%s'),
                '%H:%i:%s')) BETWEEN 12 AND 17
        AND MONTH(STR_TO_DATE(DATE_FORMAT(startdate, '%d-%m-%Y'),
                '%d-%m-%Y')) = 10;

## Question 3

SELECT DISTINCT
    e.EntertainerID,
    e.EntStageName,
    MIN(CASE
        WHEN
            eg.startdate <= '2017-12-25'
                AND eg.enddate >= '2017-12-25'
        THEN
            'Booked on Christmas'
        ELSE 'Free on Cristmas'
    END) AS CristmasWorkFlag
FROM
    entertainers e
        LEFT JOIN
    engagements eg ON e.entertainerid = eg.entertainerid
GROUP BY 1 , 2;

## Question 4
SELECT 
    jz.*
FROM
    ((SELECT 
        CONCAT(c.custfirstname, ' ', c.custlastname) AS CustName,
            StyleName
    FROM
        customers c
    JOIN musical_preferences mp ON c.customerid = mp.customerid
    JOIN musical_styles ms ON mp.styleid = ms.styleid
    WHERE
        ms.stylename = 'Jazz') jz
    LEFT JOIN (SELECT 
        CONCAT(c.custfirstname, ' ', c.custlastname) AS CustName,
            StyleName
    FROM
        customers c
    JOIN musical_preferences mp ON c.customerid = mp.customerid
    JOIN musical_styles ms ON mp.styleid = ms.styleid
    WHERE
        ms.stylename = 'Standards') st ON st.CustName = jz.CustName)
WHERE
    st.CustName IS NULL;

use accountspayable;

## Question 1
SELECT 
    invoice_number,
    CONCAT('$', " ",
            CAST(SUM(invoice_total) AS CHARACTER)) AS invoice_total
FROM
    invoices
GROUP BY 1;
    
## Question 2

SELECT 
    CAST(invoice_date AS CHARACTER) AS InvoiceDate,
    CAST((invoice_total) AS UNSIGNED) AS invoice_total
FROM
    invoices;

## Question 3

SELECT 
    CASE
        WHEN LENGTH(invoice_id) = 1 THEN CONCAT('00', invoice_id)
        WHEN LENGTH(invoice_id) = 2 THEN CONCAT('0', invoice_id)
        ELSE invoice_id
    END AS invoice_id,
    vendor_id,
    invoice_number,
    invoice_date,
    invoice_total,
    payment_total,
    credit_total,
    terms_id,
    invoice_due_date,
    payment_date
FROM
    invoices; 
    
## Question 4

SELECT 
    ROUND(invoice_total, 1) AS invoice_one_digit,
    ROUND(invoice_total, 0) AS invoice_no_digit
FROM
    invoices;

## Question 5

/**
USE accountspayable;
CREATE TABLE date_sample
(
date_id INT NOT NULL,
start_date DATETIME
);
INSERT INTO date_sample VALUES
(1, '1986-03-01 00:00:00'),
(2, '2006-02-28 00:00:00'),
(3, '2010-10-31 00:00:00'),
(4, '2018-02-28 10:00:00'),
(5, '2019-02-28 13:58:32'),
(6, '2019-03-01 09:02:25');
**/

SELECT 
    DATE_FORMAT(start_date, '%b/%d/%y') AS format_1,
    DATE_FORMAT(start_date, '%c/%d/%y') AS format_2,
    DATE_FORMAT(start_date, '%h:%i %p') AS format_3
FROM
    date_sample;

## Question 6

SELECT 
    vendor_name,
    UPPER(vendor_name) AS cap_vendor_name,
    vendor_phone,
    RIGHT(vendor_phone, 4) AS last_four_digits,
    CONCAT(SUBSTRING(vendor_phone, 2, 3),
            '.',
            SUBSTRING(vendor_phone, 7, 3),
            '.',
            SUBSTRING(vendor_phone, - 4, 4)) AS vendor_phone_new
FROM
    vendors;

## Question 7

SELECT 
    invoice_number,
    invoice_date,
    DATE_ADD(invoice_date, INTERVAL 30 DAY) AS new_invoice_date,
    payment_date,
    DATEDIFF(payment_date, invoice_date) AS days_to_pay,
    MONTH(invoice_date) AS num_invoice_month,
    YEAR(invoice_date) AS invoice_year
FROM
    invoices
WHERE
    EXTRACT(MONTH FROM invoice_date) = 5;

## Question 8

/**
CREATE TABLE string_sample
(
emp_id VARCHAR(3),
emp_name VARCHAR(25)
);
INSERT INTO string_sample VALUES
('1', 'Lizbeth Darien'),
('2', 'Darnell O''Sullivan'),
('17', 'Lance Pinos-Potter'),
('20', 'Jean Paul Renard'),
('3', 'Alisha von Strump');
**/

SELECT 
    emp_name,
    REGEXP_SUBSTR(emp_name, '^[[:alpha:]]+', 1) AS first_name,
    REGEXP_REPLACE(emp_name, '^[[:alpha:]]+', "") AS last_name
FROM
    string_sample;

