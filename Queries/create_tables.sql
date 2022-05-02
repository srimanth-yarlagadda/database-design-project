USE WONDER_LIBRARY;

DROP TABLE IF EXISTS WONDER_LIBRARY.PAYMENT;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.PAYMENT
(   
    PAYMENT_ID              VARCHAR(50)     NOT NULL,
    RECEPTIONIST_ID         VARCHAR(20)     NOT NULL,
    MEMBER_ID               VARCHAR(20)     NOT NULL,
    ISSUE_DATE              DATE            NULL,
    DUE_DATE                DATE GENERATED ALWAYS AS (ISSUE_DATE + INTERVAL 30 DAY) NULL,
    PAYMENT_METHOD          VARCHAR(20)     NULL,
    PAYMENT_TIME            DATETIME        NOT NULL,
    AMOUNT                  DECIMAL(10,2)   NOT NULL,
    
    PRIMARY KEY (PAYMENT_ID),
    FOREIGN KEY(RECEPTIONIST_ID) REFERENCES WONDER_LIBRARY.RECEPTIONIST(PERSON_ID)
);

DROP TABLE IF EXISTS WONDER_LIBRARY.BOOK_ISSUE;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.BOOK_ISSUE
(   
    BOOK_ID     VARCHAR(20)     NOT NULL,
    MEMBER_ID   VARCHAR(20)     NOT NULL,
    ISSUE_DATE  DATE        NOT NULL,
    PAYMENT_ID  VARCHAR(50)     NULL,
    PRIMARY KEY(BOOK_ID, MEMBER_ID, ISSUE_DATE),
    FOREIGN KEY(PAYMENT_ID) REFERENCES WONDER_LIBRARY.PAYMENT(PAYMENT_ID),
    FOREIGN KEY(MEMBER_ID) REFERENCES WONDER_LIBRARY.MEMBER(PERSON_ID)
);


DROP TABLE IF EXISTS WONDER_LIBRARY.BOOK_CATALOG;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.BOOK_CATALOG
(
    BOOK_ID     VARCHAR(20)     NOT NULL,
    DATE        DATE            NOT NULL,
    CATALOGING_MANAGER_ID   VARCHAR(20) NOT NULL,
    PRIMARY KEY(BOOK_ID, DATE)
);

DROP TABLE IF EXISTS WONDER_LIBRARY.BOOK_CATEGORY;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.BOOK_CATEGORY
(
    BOOK_ID     VARCHAR(20)     NOT NULL,
    CATEGORY    VARCHAR(20)     NOT NULL,
    PRIMARY KEY(BOOK_ID)
);



DROP TABLE IF EXISTS WONDER_LIBARARY.PUBLISHER;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.PUBLISHER
(
    PUBLISHER_ID         VARCHAR(20)    NOT NULL,
    PUBLISHER_NAME       VARCHAR(255)   NOT NULL,
    ADDRESS              VARCHAR(255)   NOT NULL,     
    EMAIL                VARCHAR(100)   NOT NULL,
    CONTACT              VARCHAR(14)    NOT NULL,
    PRIMARY KEY (PUBLISHER_ID)
);


DROP TABLE IF EXISTS WONDER_LIBARARY.BOOKS;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.BOOKS
(
    BOOK_ID         VARCHAR(20),
    BOOK_TITLE      VARCHAR(255)   NOT NULL,
    BOOK_EDITION    VARCHAR(50)    NOT NULL,     
    PUBLISHER_ID    VARCHAR(20)    NOT NULL,
    CATEGORY        VARCHAR(20)    NOT NULL,
    PRIMARY KEY (BOOK_ID)
    FOREIGN KEY(PUBLISHER_ID) REFERENCES WONDER_LIBRARY.PUBLISHER(PUBLISHER_ID)
);



DROP TABLE IF EXISTS WONDER_LIBRARY.WRITES_BOOK;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.WRITES_BOOK
(
    BOOK_ID     VARCHAR(20),
    AUTHOR_ID   VARCHAR(20),
    PRIMARY KEY (BOOK_ID, AUTHOR_ID),
    FOREIGN KEY(AUTHOR_ID) REFERENCES WONDER_LIBRARY.AUTHOR(AUTHOR_ID),
    FOREIGN KEY(BOOK_ID)   REFERENCES WONDER_LIBRARY.BOOKS(BOOK_ID)
);


DROP TABLE IF EXISTS WONDER_LIBRARY.COMMENTS;
CREATE TABLE IF NOT EXISTS WONDER_LIBRARY.COMMENTS
(
    COMMENT_ID     VARCHAR(20),
    COMMENT_TIME   DATETIME      NOT NULL,
    COMMENT_TEXT   VARCHAR(255)     NULL,
    RATING_SCORE   INTEGER          NULL,
    PERSON_ID      VARCHAR(20)      NOT NULL,
    BOOK_ID        VARCHAR(20)      NOT NULL,
    PRIMARY KEY (COMMENT_ID),
    FOREIGN KEY (PERSON_ID) REFERENCES WONDER_LIBRARY.PERSON(PERSON_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES WONDER_LIBRARY.BOOKS(BOOK_ID),
    CHECK (RATING_SCORE <= 5)
);



SHOW CREATE TABLE WONDER_LIBRARY.BOOKS;
select COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME
from information_schema.KEY_COLUMN_USAGE
where TABLE_NAME = 'WRITES_BOOK';

-- INSERT INTO WONDER_LIBRARY.PAYMENT (PAYMENT_ID, RECEPTIONIST_ID, MEMBER_ID,
-- ISSUE_DATE, PAYMENT_METHOD, PAYMENT_TIME, AMOUNT)
-- VALUES ("ABC", "EDF", "KKJ", '1998-01-23', "VAD", '1998-01-23 12:45:56', 500.22);

SELECT * FROM WONDER_LIBRARY.PAYMENT;