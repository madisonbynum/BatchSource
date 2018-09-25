DROP TABLE USERS;
CREATE TABLE USERS(
    USER_ID NUMBER PRIMARY KEY,
    SSN VARCHAR2(9),
    USERNAME VARCHAR2(20),
    PASSWORD VARCHAR2(40),
    FIRSTNAME VARCHAR2(30), 
    LASTNAME VARCHAR2(30),
    PHONE VARCHAR2(30),
    ADDRESS VARCHAR2(100),
    STATE VARCHAR2(2),
    COUNTRY VARCHAR2(30),
    EMAIL VARCHAR(40),
    CONSTRAINT FK_USERNAME FOREIGN KEY (USERNAME) REFERENCES LOGIN(USERNAME),
    CONSTRAINT FK_PASSWORD FOREIGN KEY (PASSWORD) REFERENCES LOGIN(PASSWORD)
    );
    
CREATE SEQUENCE USERS_PK
START WITH 1
INCREMENT BY 1;

DROP TABLE LOGIN;
CREATE TABLE LOGIN(
    LOGIN_ID NUMBER PRIMARY KEY,
    USERNAME VARCHAR2(20) UNIQUE,
    PASSWORD VARCHAR2(40)UNIQUE
);
CREATE SEQUENCE LOGIN_PK
START WITH 1
INCREMENT BY 1;

DROP TABLE ADMIN;
CREATE TABLE ADMIN(
    ADMIN_ID NUMBER PRIMARY KEY,
    FIRSTNAME VARCHAR2(30), 
    LASTNAME VARCHAR2(30),
    USERNAME VARCHAR2(20),
    PASSWORD VARCHAR2(40),
    PHONE VARCHAR2(30),
    ADDRESS VARCHAR2(100),
    STATE VARCHAR2(2),
    COUNTRY VARCHAR2(30),
    EMAIL VARCHAR(40),
    CONSTRAINT FK_ADMINUSERNAME FOREIGN KEY (USERNAME) REFERENCES LOGIN(USERNAME),
    CONSTRAINT FK_ADMINPASSWORD FOREIGN KEY (PASSWORD) REFERENCES LOGIN(PASSWORD)
);

CREATE SEQUENCE ADMIN_PK
START WITH 1
INCREMENT BY 1;

--MISSING KEYWORD
DROP TABLE TRANSACTIONS;
CREATE TABLE TRANSACTIONS(
    TRANSACTION_ID NUMBER PRIMARY KEY, 
    ACCOUNT_ID NUMBER UNIQUE,
    DATE_OF_TRANSACTION DATE,
    TRANSACTION_TYPE_ID NUMBER UNIQUE,
    CURRENT_BALANCE NUMBER(10,2),
    CONSTRAINT FK_TRANSACTION_TYPE_ID FOREIGN KEY (TRANSACTION_TYPE_ID) REFERENCES TRANSACTION_TYPES(TRANSACTION_TYPE_ID),
    CONSTRAINT FK_ACCOUNT_ID FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNT(ACCOUNT_ID)
);
    
CREATE SEQUENCE TRANSACTIONS_PK
START WITH 1
INCREMENT BY 1;

DROP TABLE ACCOUNT;
CREATE TABLE ACCOUNT(
    ACCOUNT_ID NUMBER PRIMARY KEY,
    USER_ID NUMBER,
    ACCOUNT_TYPE_ID NUMBER,
    ACCOUNT_NAME VARCHAR2(30),
    CURRENT_BALANCE NUMBER,
    CONSTRAINT FK_ACCOUNT_TYPE_ID FOREIGN KEY (ACCOUNT_TYPE_ID) REFERENCES ACCOUNT_TYPES(ACCOUNT_TYPE_ID),
    CONSTRAINT FK_USER_ID FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)
);
CREATE SEQUENCE ACCOUNT_PK
START WITH 1
INCREMENT BY 1;

DROP TABLE TRANSACTION_TYPES;
CREATE TABLE TRANSACTION_TYPES(
    TRANSACTION_TYPE_ID NUMBER PRIMARY KEY, 
    TRANSACTION_NAME VARCHAR2(20)
);

CREATE SEQUENCE TRANSACTION_TYPES_PK
START WITH 1
INCREMENT BY 1;

DROP TABLE ACCOUNT_TYPES;
CREATE TABLE ACCOUNT_TYPES(
    ACCOUNT_TYPE_ID NUMBER PRIMARY KEY, 
    ACCOUNT_NAME VARCHAR2(20)
);

INSERT INTO LOGIN VALUES (1, 'dino', 'THE DINOSAUR');
CREATE SEQUENCE ACCOUNT_TYPESSEQ;
CREATE SEQUENCE LOGINSEQ;
CREATE SEQUENCE USERSSEQ;


CREATE OR REPLACE PROCEDURE INSERTACCOUNT_TYPES(NAME IN VARCHAR2)
AS
BEGIN
INSERT INTO ACCOUNT_TYPES VALUES(ACCOUNT_TYPESSEQ.NEXTVAL, NAME);
COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE INSERTLOGIN(USERNAME IN VARCHAR2, PASSWORD IN VARCHAR2)
AS
BEGIN
INSERT INTO LOGIN VALUES(LOGINSEQ.NEXTVAL, USERNAME, PASSWORD);
COMMIT;
END;
/

    
CREATE OR REPLACE PROCEDURE INSERTUSERS(SSN IN VARCHAR2, USERNAME IN VARCHAR2, PASSWORD IN VARCHAR2, 
FIRSTNAME IN VARCHAR2, LASTNAME IN VARCHAR2, PHONE IN VARCHAR2, ADDRESS IN VARCHAR2, 
STATE IN VARCHAR2, COUNTRY IN VARCHAR2, EMAIL IN VARCHAR2)
AS
BEGIN
INSERT INTO USERS VALUES(USERSSEQ.NEXTVAL, SSN, USERNAME, PASSWORD, FIRSTNAME, LASTNAME, PHONE, ADDRESS, STATE, COUNTRY, EMAIL);
COMMIT;
END;
/

CREATE SEQUENCE ACCOUNTSEQ;
CREATE OR REPLACE PROCEDURE INSERTACCOUNT(accountName IN VARCHAR2, userID IN NUMBER, accounttypeID IN NUMBER, currentBalance IN NUMBER)
AS
BEGIN
INSERT INTO USERS VALUES(ACCOUNTSEQ.NEXTVAL, accountName, userID, accounttypeID, currentBalance);
COMMIT;
END;
/

CREATE SEQUENCE TRANSACTIONTYPESSEQ;
CREATE OR REPLACE PROCEDURE INSERTTRANSACTIONTYPES(TRANSACTIONNAME IN VARCHAR2)
AS
BEGIN
INSERT INTO ACCOUNT_TYPES VALUES(TRANSACTIONTYPESSEQ.NEXTVAL, TRANSACTIONNAME);
COMMIT;
END;
/