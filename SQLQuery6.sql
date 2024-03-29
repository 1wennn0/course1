--第一題
SELECT KEEPER_ID AS KeeperId,USER_CNAME AS CName,USER_ENAME AS EName,YEAR(LEND_DATE) AS BorrowYear,COUNT(LEND_DATE) AS BorrowCnt
FROM BOOK_LEND_RECORD,MEMBER_M
WHERE MEMBER_M.USER_ID=BOOK_LEND_RECORD.KEEPER_ID
GROUP BY KEEPER_ID,USER_CNAME,USER_ENAME,YEAR(LEND_DATE)
ORDER BY KeeperId,BorrowYear;

--第二題
SELECT top(5) BOOK_LEND_RECORD.BOOK_ID AS BookId,BOOK_NAME,COUNT(LEND_DATE) AS Cnt
FROM BOOK_LEND_RECORD,BOOK_DATA
WHERE BOOK_LEND_RECORD.BOOK_ID=BOOK_DATA.BOOK_ID
GROUP BY BOOK_LEND_RECORD.BOOK_ID,BOOK_NAME
ORDER BY Cnt DESC;

--第三題
SELECT [Quarter],count([Quarter])AS Cnt
FROM (SELECT
       CASE
             WHEN DATEPART(QUARTER,LEND_DATE)= 1 THEN '2019/01~2019/03'
             WHEN DATEPART(QUARTER,LEND_DATE)= 2 THEN '2019/04~2019/06'
          WHEN DATEPART(QUARTER,LEND_DATE)= 3 THEN '2019/07~2019/09'
                WHEN DATEPART(QUARTER,LEND_DATE)= 4 THEN '2019/10~2019/12'
       END AS [Quarter]
         FROM  BOOK_LEND_RECORD
         WHERE YEAR([LEND_DATE])='2019') B
GROUP BY [Quarter]
ORDER BY [Quarter]

--第四題
SELECT *
FROM(
     SELECT ROW_NUMBER() over(PARTITION BY BOOK_CLASS_NAME ORDER BY COUNT(LEND_DATE) DESC) AS Seq,BOOK_CLASS_NAME AS BOOK_CLASS,L.BOOK_ID,BOOK_NAME,COUNT(LEND_DATE) AS Cnt
     FROM BOOK_CLASS C,BOOK_LEND_RECORD L,BOOK_DATA D
     WHERE C.BOOK_CLASS_ID=D.BOOK_CLASS_ID
     AND D.BOOK_ID=L.BOOK_ID
     GROUP BY BOOK_CLASS_NAME,L.BOOK_ID,BOOK_NAME
    ) AS BOOKINFO
WHERE BOOKINFO.Seq<='3'
ORDER BY BOOKINFO.BOOK_CLASS,BOOKINFO.Cnt DESC;

--第五題
SELECT ClassId,ClassName,SUM(Cnt2016) AS Cnt2016,SUM(Cnt2017) AS Cnt2017,SUM(Cnt2018) AS Cnt2018,SUM(Cnt2019) AS Cnt2019
FROM(
     SELECT C.BOOK_CLASS_ID AS ClassId,C.BOOK_CLASS_NAME AS ClassName,
          CASE
              WHEN YEAR(LEND_DATE)='2016' THEN 1 ELSE 0 END AS Cnt2016,
          CASE
                 WHEN YEAR(LEND_DATE)='2017' THEN 1 ELSE 0 END AS Cnt2017,
          CASE
                 WHEN YEAR(LEND_DATE)='2018' THEN 1 ELSE 0 END AS Cnt2018,
          CASE
                 WHEN YEAR(LEND_DATE)='2019' THEN 1 ELSE 0 END AS Cnt2019
     FROM BOOK_CLASS C,BOOK_LEND_RECORD L,BOOK_DATA D
     WHERE C.BOOK_CLASS_ID=D.BOOK_CLASS_ID
     AND D.BOOK_ID=L.BOOK_ID) AS V
GROUP BY ClassId,ClassName
ORDER BY ClassId;

--第六題
SELECT ClassId,ClassName,ISNULL([2016],0)AS CNT2016,ISNULL([2017],0)AS CNT2017,ISNULL([2018],0)AS CNT2018,ISNULL([2019],0)AS CNT2019
FROM(SELECT C.BOOK_CLASS_ID AS ClassId,C.BOOK_CLASS_NAME AS ClassName,YEAR(L.LEND_DATE) AS LEND,count(LEND_DATE) AS QTY
     FROM   BOOK_CLASS C,BOOK_LEND_RECORD L,BOOK_DATA D
        WHERE  C.BOOK_CLASS_ID=D.BOOK_CLASS_ID AND D.BOOK_ID=L.BOOK_ID
        GROUP BY C.BOOK_CLASS_ID,C.BOOK_CLASS_NAME,YEAR(L.LEND_DATE))AS D
PIVOT(SUM(QTY) FOR LEND
     IN ([2016],[2017],[2018],[2019])) AS B
ORDER BY ClassId;

--第七題
SELECT DISTINCT D.BOOK_ID AS '書本ID',CONVERT(VARCHAR(11),D.BOOK_BOUGHT_DATE,111) AS '購書日期',CONVERT(VARCHAR(11),L.LEND_DATE,111) AS '借閱日期',D.[BOOK_CLASS_ID]+'-'+C.[BOOK_CLASS_NAME] AS '書籍類別',M.[USER_ID]+'-'+M.[USER_CNAME]+'('+M.USER_ENAME+')' AS '借閱人',CO.[CODE_ID]+'-'+CO.CODE_NAME AS '狀態',D.BOOK_AMOUNT AS '購書金額'
FROM BOOK_CLASS C,BOOK_CODE CO,BOOK_DATA D,BOOK_LEND_RECORD L,MEMBER_M M
WHERE C.BOOK_CLASS_ID=D.BOOK_CLASS_ID
AND   CO.CODE_ID=D.BOOK_STATUS
AND   D.BOOK_ID=L.BOOK_ID
AND  M.USER_ID=L.KEEPER_ID
AND  M.USER_CNAME='李四'
ORDER BY '書本ID' DESC;

--第八題
INSERT INTO BOOK_LEND_RECORD([BOOK_ID],[KEEPER_ID],[LEND_DATE],[CRE_DATE],[CRE_USR],[MOD_DATE],[MOD_USR])
Values (2004,N'0002','2016/04/09 00:00:00','',N'','',N'')
UPDATE BOOK_LEND_RECORD
SET LEND_DATE='2019/01/02 00:00:00'
WHERE BOOK_ID=2004 AND KEEPER_ID=N'0002';

--第九題
DELETE FROM BOOK_LEND_RECORD
WHERE BOOK_ID=2004 AND KEEPER_ID=N'0002';
