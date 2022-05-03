-- QUERY 1
SELECT P.*, E.START_DATE
FROM EMPLOYEE E
LEFT JOIN PERSON P ON E.PERSON_ID = P.PERSON_ID
WHERE DESIGNATION = 'LIBRARY SUPERVISOR'
AND START_DATE >= CURRENT_DATE - INTERVAL 2 MONTH;

-- QUERY 2
SELECT CONCAT(P.FIRST_NAME, ' ' ,P.LAST_NAME) NAME, B.ISSUE_DATE AS BORROW_DATE, BK.BOOK_TITLE
FROM BOOK_ISSUE B
INNER JOIN PERSON P ON B.MEMBER_ID = P.PERSON_ID
INNER JOIN BOOKS BK ON B.BOOK_ID = BK.BOOK_ID
WHERE MEMBER_ID IN (SELECT PERSON_ID FROM EMPLOYEE)
AND ISSUE_DATE >= CURRENT_DATE - INTERVAL 1 MONTH;

-- QUERY 3
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

-- QUERY 4
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

-- QUERY 5
SELECT BOOK_TITLE
FROM BOOKS WHERE BOOK_ID NOT IN 
(SELECT DISTINCT BOOK_ID
FROM BOOK_ISSUE
WHERE ISSUE_DATE >= CURRENT_DATE - INTERVAL 5 MONTH);


-- QUERY 6
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





-- QUERY 7
SELECT CONCAT(P.FIRST_NAME,' ', P.MIDDLE_NAME, ' ', P.LAST_NAME) AS NAME, M.CARD_ID, TOTAL_NO_OF_GUESTS FROM
(SELECT G.GOLD_CARD_ID, COUNT(GL.GUEST_ID) AS TOTAL_NO_OF_GUESTS FROM GOLD G, GUEST_LOG GL
WHERE G.GOLD_CARD_ID = GL.CARD_ID
GROUP BY G.GOLD_CARD_ID) AS T, PERSON P, MEMBER M 
WHERE TOTAL_NO_OF_GUESTS = (SELECT MAX(B.TOTAL) FROM (SELECT G.GOLD_CARD_ID, COUNT(GL.GUEST_ID) AS TOTAL FROM GOLD G, GUEST_LOG GL
WHERE G.GOLD_CARD_ID = GL.CARD_ID
GROUP BY G.GOLD_CARD_ID) AS B) AND P.PERSON_ID = M.PERSON_ID AND T.GOLD_CARD_ID = M.CARD_ID;


-- QUERY 8
SELECT * FROM 
 (SELECT YEAR(ISSUE_DATE), COUNT(YEAR(ISSUE_DATE)) AS TOTAL_ISSUES FROM BOOK_ISSUE
 GROUP BY YEAR(ISSUE_DATE)) AS T
 WHERE TOTAL_ISSUES = (SELECT MAX(B.TOTAL_ISSUES) FROM (SELECT YEAR(ISSUE_DATE), COUNT(YEAR(ISSUE_DATE)) AS TOTAL_ISSUES FROM BOOK_ISSUE
 GROUP BY YEAR(ISSUE_DATE)) AS B);



-- QUERY 9
 SELECT DISTINCT CONCAT(P.FIRST_NAME,' ', P.MIDDLE_NAME,' ', P.LAST_NAME) AS MEMBER_NAME FROM POPULARBOOKS PB, PERSON P, BOOK_ISSUE B
 WHERE PB.BOOK_ID = B.BOOK_ID AND P.PERSON_ID = B.MEMBER_ID;

 -- QUERY 14
SELECT CATALOGING_MANAGER_ID, SUM(CAT_COUNT)
FROM (
SELECT CATALOGING_MANAGER_ID, CONCAT(YEAR(DATE), '-'  ,WEEK(DATE)) AS WEEK_ID, COUNT(DISTINCT CATEGORY) AS CAT_COUNT
FROM (SELECT B.*, C.CATEGORY
		FROM BOOK_CATALOG B
		LEFT JOIN BOOK_CATEGORY C ON B.BOOK_ID = C.BOOK_ID
        WHERE DATE >= CURRENT_DATE - INTERVAL 4 WEEK
        ) BCAT
GROUP BY CONCAT(YEAR(DATE), '-'  ,WEEK(DATE)), CATALOGING_MANAGER_ID) T
GROUP BY 1
HAVING SUM(CAT_COUNT) = (SELECT 4*COUNT(DISTINCT CATEGORY) FROM BOOKS WHERE BOOK_ID IN (SELECT DISTINCT BOOK_ID FROM BOOK_CATALOG));



