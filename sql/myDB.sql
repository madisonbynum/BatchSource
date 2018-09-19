--2.1 Select
SELECT * FROM EMPLOYEE;
SELECT * FROM EMPLOYEE WHERE LASTNAME = 'King';
SELECT * FROM EMPLOYEE WHERE FIRSTNAME = 'Andrew' AND REPORTSTO IS NULL;
--2.2 Order By
SELECT * FROM ALBUM ORDER BY TITLE DESC;
SELECT FIRSTNAME FROM CUSTOMER ORDER BY CITY ASC;
--2.3 INSERT INTO
INSERT INTO GENRE (GENREID, NAME) VALUES (26,'New Genre 1');
INSERT INTO GENRE (GENREID, NAME) VALUES (27,'New Genre 2');

INSERT INTO EMPLOYEE (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL) 
    VALUES (9, 'Doe', 'John', 'Sales Representative', 2, '1-JAN-1998', '1-MAY-18', '123 Fake St', 'Salty', 'SE', 'Noville', '11223', '111-222-3333', '222-333-4444', 'jDoe@fake.com');
INSERT INTO EMPLOYEE (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL) 
    VALUES (10, 'Doe', 'Jane', 'Sales Representative', 2, '1-MAY-98', '1-JAN-18', '123 Fake St', 'Salty', 'SE', 'Noville', '11223', '333-222-1111', '222-333-4444', 'janeDoe@fake.com');

INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, COMPANY, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL, SUPPORTREPID) 
    VALUES (53, 'Jack', 'Doe', 'DOE Inc', '123 Doe St', 'Doeville', 'DO', 'DOE', '23456', '111-333-2222', null, 'jackDoe@fake.com', null);
INSERT INTO CUSTOMER (CUSTOMERID, FIRSTNAME, LASTNAME, COMPANY, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL, SUPPORTREPID) 
    VALUES (54, 'Elis', 'Doe', 'DOE Inc', '333 Doe St', 'Doeville', 'DO', 'DOE', '23456', '111-333-2222', '222-222-2222', 'eDoe@fake.com', null);
--2.4 Update
UPDATE customer SET firstname = 'Robert', lastname = 'Walter' WHERE firstname = 'Aaron' AND lastname = 'Mitchell';

UPDATE artist SET name = 'CCR' WHERE name = 'Creedence Clearwater Revival';
--2.5 Like
SELECT * FROM invoice WHERE billingaddress like 'T%';
--2.6 Between
SELECT * FROM invoice WHERE total BETWEEN 15 AND 50;

SELECT * FROM employee WHERE hireddate BETWEEN '01-JUN-03' AND '01-MAR-04';
--2.7 Delete
DELETE FROM customer
WHERE
    firstname = 'Robert'
    AND lastname = 'Walter';
--3.1 System Defined Functions
SELECT TO_CHAR(CURRENT_DATE, 'DD-MM-YYYY HH:MI:SS') from DUAL;

SELECT length(name) FROM mediatype;

--3.2 System Defined Aggregate Functions
SELECT SUM(total) FROM invoice;

SELECT MAX(unitprice) FROM track;
   
--3.3 User Defined Scalar Functions
SELECT AVG(unitprice) FROM invoiceline;

--3.4 User Defined Table Valued Functions
SELECT * FROM employee WHERE birthdate >= to_date('01-JAN-1968');

--4.1 Basic Stored Procedure
CREATE OR REPLACE PROCEDURE SELECT_EMP_FIRST_LAST
(S OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN S FOR
        SELECT FIRSTNAME, LASTNAME FROM EMPLOYEE;
    END SELECT_EMP_FIRST_LAST;
/
DECLARE
    S SYS_REFCURSOR;
    FIRSTNAME CUSTOMER.FIRSTNAME%TYPE;
    LASTNAME CUSTOMER.LASTNAME%TYPE;
    BEGIN
        SELECT_EMP_FIRST_LAST(S);
        LOOP
        FETCH S INTO FIRSTNAME,LASTNAME;
        EXIT WHEN S%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(FIRSTNAME||' '||LASTNAME);
        END LOOP
        CLOSE;
    END;
/
SET SERVEROUTPUT ON;

--4.2 Stored Procedure Input Parameters
CREATE OR REPLACE PROCEDURE UPDATE_EMP_FIRST
(NEW_FIRST IN VARCHAR2, EMP_ID IN NUMBER)
AS
BEGIN 
    UPDATE EMPLOYEE SET FIRSTNAME = NEW_FIRST WHERE EMPLOYEEID = EMP_ID;
END;
/
EXECUTE UPDATE_EMP_FIRST('Adam', 1);

CREATE OR REPLACE Procedure FIND_EMP_MANAGERS
(S OUT SYS_REFCURSOR, EMP_ID IN NUMBER)
    AS
    BEGIN
        OPEN S FOR
        SELECT FIRSTNAME, LASTNAME, EMPLOYEEID, REPORTSTO
        FROM EMPLOYEE
        WHERE EMPLOYEEID = EMP_ID;
    END FIND_EMP_MANAGERS;
/
DECLARE
    S SYS_REFCURSOR;
    FIRSTNAME EMPLOYEE.FIRSTNAME%TYPE;
    LASTNAME EMPLOYEE.LASTNAME%TYPE;
    EMPLOYEEID EMPLOYEE.EMPLOYEEID%TYPE;
    REPORTSTO EMPLOYEE.REPORTSTO%TYPE;
    BEGIN
        FIND_EMP_MANAGERS(S,5);
        FETCH S INTO FIRSTNAME, LASTNAME, EMPLOYEEID, REPORTSTO;
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE ' || FIRSTNAME || ' ' || LASTNAME);
        LOOP
        IF REPORTSTO IS NOT NULL THEN
            BEGIN
                FIND_EMP_MANAGERS(S,REPORTSTO);
                FETCH S INTO FIRSTNAME, LASTNAME, EMPLOYEEID, REPORTSTO;
                DBMS_OUTPUT.PUT_LINE('MANAGERS ' ||FIRSTNAME||' '||LASTNAME);
            END;
        END IF;
        EXIT WHEN REPORTSTO IS NULL;
        END LOOP
        CLOSE;
    END;
/

--4.3 Stored Procedure Output Parameters
CREATE OR REPLACE PROCEDURE FIND_CUST_NAME_COMPANY
(S OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN S FOR
        SELECT FIRSTNAME, LASTNAME, COMPANY FROM CUSTOMER;
    END FIND_CUST_NAME_COMPANY;
/
DECLARE
    S SYS_REFCURSOR;
    FIRSTNAME CUSTOMER.FIRSTNAME%TYPE;
    LASTNAME CUSTOMER.LASTNAME%TYPE;
    COMPANY CUSTOMER.COMPANY%TYPE;
    BEGIN
        FIND_CUST_NAME_COMPANY(S);
        LOOP
        FETCH S INTO FIRSTNAME, LASTNAME, COMPANY;
        EXIT WHEN S%NOTFOUND;
        IF COMPANY IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(FIRSTNAME||' '||LASTNAME || ' Company: ' || COMPANY);
        END IF;
        END LOOP
        CLOSE;
    END;
/
--5.0 Transactions
CREATE OR REPLACE PROCEDURE DEL_INVOICE 
(INVOICE_ID IN NUMBER)
AS 
TMP_ID NUMBER;
BEGIN
    SAVEPOINT BEFORE_DO_INVOICE_DELETE;
    TMP_ID := NULL;
    SELECT INVOICEID INTO TMP_ID FROM INVOICE WHERE INVOICEID = INVOICE_ID;
    IF TMP_ID IS NOT NULL THEN
        BEGIN
            DELETE FROM INVOICE
            WHERE INVOICEID = INVOICE_ID;
            COMMIT;
        END;
    ELSE 
        ROLLBACK TO BEFORE_DO_INVOICE_DELETE;
    END IF;
END;

CREATE OR REPLACE PROCEDURE NEW_CUSTOMER
(CUSTOMER_ID IN NUMBER, FIRST_NAME IN VARCHAR2, LAST_NAME IN VARCHAR2, E_MAIL IN VARCHAR2)
AS
EXIST_CUSTOMERID NUMBER;
BEGIN
    SAVEPOINT BEFORE_NEW_CUSTOMER;
    EXIST_CUSTOMERID := NULL;
    SELECT CUSTOMERID INTO EXIST_CUSTOMERID FROM CUSTOMER WHERE CUSTOMERID = CUSTOMER_ID;
    IF EXIST_CUSTOMERID IS NOT NULL THEN
        BEGIN
            INSERT INTO CUSTOMER(CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL)
            VALUES (CUSTOMER_ID, FIRST_NAME, LAST_NAME, E_MAIL);
            COMMIT;
        END;
    ELSE 
        ROLLBACK TO BEFORE_NEW_CUSTOMER;
    END IF;
END;

--6.1 AFTER/FOR
CREATE OR REPLACE TRIGGER after_insert_employee AFTER INSERT ON employee
BEGIN
    SELECT * FROM employee WHERE NEW.employeeID = count(employee);
END;

CREATE OR REPLACE TRIGGER after_update_album AFTER UPDATE ON album
BEGIN
    SELECT * FROM album WHERE NEW.albumid = count(album);
END;

CREATE OR REPLACE TRIGGER after_delete_customer AFTER DELETE ON customer
BEGIN
    SELECT * FROM customer WHERE customerid = count(customer);
END;

--7.1 INNER
SELECT firstname, lastname, invoiceid FROM customer, invoice WHERE customer.customerid = invoice.customerid;

--7.2 OUTER
SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total 
    FROM customer LEFT OUTER JOIN invoice on customer.customerid = invoice.customerid;

--7.3 RIGHT
SELECT artist.name, album.title FROM album RIGHT OUTER JOIN artist ON album.artistid = artist.artistid;

--7.4 CROSS
SELECT artist.name FROM album CROSS JOIN artist ORDER BY artist.name ASC;

--7.5 SELF
SELECT e.firstname AS emp_first, e.lastname AS emp_last, r.firstname AS sup_first, r.lastname as sup_last FROM employee e, employee r WHERE e.reportsto = r.employeeid;