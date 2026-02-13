SELECT * FROM jikwon;
SELECT * FROM gogek;
SELECT * FROM buser;


/*
문1) 총무부에서 관리하는 고객수 출력 (고객 30살 이상만 작업에 참여)
*/

SELECT buser.busername AS 부서명, COUNT(*) AS 고객수 FROM jikwon 
INNER JOIN buser ON jikwon.busernum = buser.buserno
INNER JOIN gogek ON jikwon.jikwonno = gogek.gogekdamsano
WHERE buser.busername = '총무부' AND YEAR(NOW())-SUBSTR(gogek.gogekjumin, 1, 2)-1900 >= 30
GROUP BY buser.busername;

/*
문2) 부서명별 고객 인원수 (부서가 없으면 "무소속")
*/

SELECT nvl(busername,'무소속') AS 부서명, COUNT(gogek.gogekno) AS 고객수
FROM jikwon 
LEFT OUTER JOIN buser ON jikwon.busernum = buser.buserno
INNER JOIN gogek ON jikwon.jikwonno = gogek.gogekdamsano
GROUP BY buser.busername;


/*
문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면  담당직원 자료 출력  

        :    ~ WHERE GOGEK_NAME='강나루'
출력 ==>  직원명    직급   부서명  부서전화    성별
*/

SELECT jikwon.jikwonname AS 직원명, jikwon.jikwonjik AS 직급, buser.busername AS 부서명, buser.busertel AS 부서전화, jikwon.jikwongen AS 성별
FROM jikwon
INNER JOIN buser ON jikwon.busernum = buser.buserno
INNER JOIN gogek ON jikwon.jikwonno = gogek.gogekdamsano
WHERE gogek.gogekname = '강나루';


/*
문4) 부서와 직원명을 입력하면 관리고객 자료 출력
        ~ WHERE BUSER_NAME='영업부' AND JIKWON_NAME='이순신'
출력 ==>  고객명    고객전화      성별
         강나루   123-4567       남
*/




















