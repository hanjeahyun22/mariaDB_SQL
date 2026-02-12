SELECT * FROM jikwon;
DESC jikwon;
SELECT TIMESTAMPDIFF(YEAR, jikwonibsail, NOW()) AS 근무년수 FROM jikwon;
SELECT * FROM buser;

SELECT jikwonname AS 직원명,
  YEAR(NOW()) - YEAR(jikwonibsail) AS 근무년수,
case
when YEAR(NOW()) - YEAR(jikwonibsail) >= 5 then '감사합니다'
ELSE '열심히' END
 AS 표현,
 case
when YEAR(NOW()) - YEAR(jikwonibsail) >= 5 then ROUND(jikwonpay * 0.05, 0)
ELSE ROUND(jikwonpay * 0.03, 0) END
 AS 특별수당 
   FROM jikwon where DATE_FORMAT(jikwonibsail, '%Y') > 2010;
   


SELECT jikwonname AS 직원명, jikwonjik AS 직급, 
DATE_FORMAT(jikwonibsail, '%Y.%m.%d') AS 입사년원일,
 case
 when YEAR(NOW()) - YEAR(jikwonibsail) >= 8 then '왕고참'
 when YEAR(NOW()) - YEAR(jikwonibsail) >= 5 then '고참'
 when YEAR(NOW()) - YEAR(jikwonibsail) >= 3 then '보통'
 ELSE '일반' 
 END AS 구분,
 case busernum
 when 10 then '총무부'
 when 20 then '영업부'
 when 30 then '전산부'
 ELSE '관리부' END AS 부서
 FROM jikwon;


SELECT jikwonno AS 사번, jikwonname AS 직원명, busernum AS 부서, ROUND(jikwonpay,0) AS 연봉,
case jikwonno
when 10 then ROUND(jikwonpay * 1.1)
when 30 then ROUND(jikwonpay * 1.2)
ELSE jikwonpay
END AS 인상연봉,
case
when YEAR(NOW()) - YEAR(jikwonibsail) >= 8 then 'O'
ELSE 'X'
END AS 장기근속
FROM jikwon;



