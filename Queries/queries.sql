SELECT P.*, E.START_DATE
FROM EMPLOYEE E
LEFT JOIN PERSON P ON E.PERSON_ID = P.PERSON_ID
WHERE DESIGNATION = 'LIBRARY SUPERVISOR'
AND START_DATE >= CURRENT_DATE - INTERVAL 2 MONTH;

SELECT CONCAT(P.FIRST_NAME, ' ' ,P.LAST_NAME) NAME, B.ISSUE_DATE AS BORROW_DATE, BK.BOOK_TITLE
FROM BOOK_ISSUE B
INNER JOIN PERSON P ON B.MEMBER_ID = P.PERSON_ID
INNER JOIN BOOKS BK ON B.BOOK_ID = BK.BOOK_ID
WHERE MEMBER_ID IN (SELECT PERSON_ID FROM EMPLOYEE)
AND ISSUE_DATE >= CURRENT_DATE - INTERVAL 1 MONTH;


SELECT AVG(BORROWED) AS AVERAGE_BORROW_TOP_5
FROM
(SELECT P.FIRST_NAME, P.LAST_NAME, P.PERSON_ID, BORROWED
FROM
(SELECT BI.MEMBER_ID AS PERSON_ID, COUNT(DISTINCT BI.BOOK_ID) AS BORROWED
FROM BOOK_ISSUE BI
WHERE BI.ISSUE_DATE >= (CURRENT_DATE - INTERVAL 1 MONTH)
GROUP BY BI.MEMBER_ID
HAVING COUNT(DISTINCT BI.BOOK_ID) > 5) TOP
LEFT JOIN PERSON P ON TOP.PERSON_ID = P.PERSON_ID 
LEFT JOIN MEMBER M ON TOP.PERSON_ID = M.PERSON_ID
LEFT JOIN LIBRARY_CARD LC ON M.CARD_ID = LC.CARD_ID
ORDER BY BORROWED DESC
LIMIT 5) B;

SELECT PUBLISHER_NAME, BOOK_TITLE FROM
(SELECT *, ROW_NUMBER() OVER (PARTITION BY PUBLISHER_ID ORDER BY BOOK_ISSUED_COUNT DESC) AS POPULARITY
FROM
(SELECT BI.BOOK_ID, PUBLISHER_ID, BOOK_TITLE, COUNT(1) BOOK_ISSUED_COUNT
FROM BOOK_ISSUE BI
LEFT JOIN BOOKS B ON BI.BOOK_ID = B.BOOK_ID
GROUP BY BI.BOOK_ID, PUBLISHER_ID, BOOK_TITLE
ORDER BY 4 DESC) C) D
LEFT JOIN PUBLISHER PUB ON D.PUBLISHER_ID = PUB.PUBLISHER_ID
WHERE POPULARITY = 1;

SELECT BOOK_TITLE
FROM BOOKS WHERE BOOK_ID NOT IN 
(SELECT DISTINCT BOOK_ID
FROM BOOK_ISSUE
WHERE ISSUE_DATE >= CURRENT_DATE - INTERVAL 5 MONTH);


SELECT DISTINCT MEMBER_ID FROM BOOK_ISSUE WHERE MEMBER_ID NOT IN
(SELECT MEMBER_ID FROM
(SELECT AB.MEMBER_ID, BI.BOOK_ID
FROM (SELECT DISTINCT BOOK_ID, MEMBER_ID FROM BOOK_ISSUE) BI
RIGHT JOIN (
	SELECT DISTINCT BOOK_ID, MEMBER_ID
	FROM WRITES_BOOK
    CROSS JOIN (SELECT DISTINCT MEMBER_ID FROM BOOK_ISSUE) MEM
	WHERE AUTHOR_ID IN 
	(SELECT AUTHOR_ID
	FROM WRITES_BOOK
	WHERE BOOK_ID = 
	(SELECT BOOK_ID
	FROM BOOK_ISSUE
	GROUP BY BOOK_ID
	ORDER BY COUNT(1) DESC
	LIMIT 1)
	)
) AB ON BI.BOOK_ID = AB.BOOK_ID
	 AND BI.MEMBER_ID = AB.MEMBER_ID) F WHERE BOOK_ID IS NULL);


-- 11
SELECT P.FIRST_NAME, P.LAST_NAME
FROM
(SELECT CARD_ID FROM LIBRARY_CARD
WHERE DATE_OF_ISSUE <= CURRENT_DATE - INTERVAL 5 YEAR) LC
LEFT JOIN MEMBER M ON LC.CARD_ID = M.CARD_ID
LEFT JOIN PERSON P ON M.PERSON_ID = P.PERSON_ID;



SELECT DISTINCT MEMBER_ID FROM BOOK_ISSUE;

