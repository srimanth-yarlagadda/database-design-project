INSERT INTO LIBRARY_CARD (card_id, date_of_issue, MEMBERSHIP_LEVEL) VALUES
('2120', '2018-05-04', 'GOLD'),
('2109', '2019-06-17', 'GOLD'),
('2103', '2019-05-19', 'GOLD'),
('2122', '2020-11-17', 'GOLD'),
('2130', '2021-12-14', 'GOLD'),
('2124', '2018-04-14', 'SILVER'),
('2214', '2019-02-14', 'SILVER'),
('2216', '2018-08-14', 'SILVER'),
('2102', '2018-10-14', 'SILVER');

SELECT * FROM GOLD;
SELECT * FROM wonder_library.MEMBER;
SELECT * FROM library_card ;
SELECT * FROM BOOK_CATEGORY;
SELECT * FROM BOOKS;

INSERT INTO BOOK_CATEGORY 
(SELECT DISTINCT BOOK_ID, CATEGORY FROM BOOKS);

-- DELETE FROM LIBRARY_CARD WHERE CARD_ID LIKE '2%';