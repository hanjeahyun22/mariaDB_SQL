SELECT * FROM jikwon;
SELECT * FROM gogek;
SELECT * FROM buser;


/*
JIKWON, BUSER, GOGEK 테이블을 사용한다.
문1) 2010년 이후에 입사한 남자 중 급여를 가장 많이 받는 직원은?

 */
 
SELECT * FROM jikwon
WHERE jikwongen = '남' AND jikwonibsail >= '2010-01-01'
	AND jikwonpay = (SELECT MAX(jikwonpay) FROM jikwon WHERE jikwongen = '남' AND jikwonibsail >= '2010-01-01');
 
 
/*
문2)  평균급여보다 급여를 많이 받는 직원은?
*/
SELECT * FROM jikwon WHERE jikwonpay > (SELECT AVG(jikwonpay) FROM jikwon); 


/*
문3) '이미라' 직원의 입사 이후에 입사한 직원은?
*/

SELECT * FROM jikwon WHERE jikwonibsail >= (SELECT jikwonibsail FROM jikwon WHERE jikwonname = '이미라') ORDER BY jikwonibsail;

/*
문4) 2010 ~ 2015년 사이에 입사한 총무부(10),영업부(20),전산부(30) 직원 중 급여가 가장 적은 사람은?
(직급이 NULL인 자료는 작업에서 제외)
*/

SELECT * FROM jikwon WHERE jikwonibsail BETWEEN '2010-01-01' AND '2015-12-31' 
	AND busernum IN (10, 20, 30)
	AND jikwonpay = (SELECT MIN(jikwonpay) FROM jikwon WHERE jikwonibsail BETWEEN '2010-01-01' AND '2015-12-31' AND busernum IN (10, 20, 30)) 
	AND jikwonjik IS NOT NULL;

/*
문5) 한송이, 이순신과 직급이 같은 사람은 누구인가?
*/

SELECT * FROM jikwon WHERE jikwonjik IN (SELECT jikwonjik FROM jikwon WHERE jikwonname IN ('한송이', '이순신'));
	
/*
문6) 과장 중에서 최대급여, 최소급여를 받는 사람은?
*/

SELECT * FROM jikwon WHERE jikwonjik  = '과장'
	AND jikwonpay IN ((SELECT MAX(jikwonpay) FROM jikwon WHERE jikwonjik = '과장'), (SELECT MIN(jikwonpay) FROM jikwon WHERE jikwonjik = '과장'));
	

/*
문7) 10번 부서의 최소급여보다 많은 사람은?
*/

SELECT * FROM jikwon WHERE jikwonpay > (SELECT MIN(jikwonpay) FROM jikwon WHERE busernum = 10);


/*
문8) 30번 부서의 평균급여보다 급여가 많은 '대리' 는 몇명인가?
*/

SELECT * FROM jikwon WHERE jikwonjik = '대리'
AND busernum = 30
AND jikwonpay > (SELECT AVG(jikwonpay) FROM jikwon WHERE busernum = 30);



/*
문9) 고객을 확보하고 있는 직원들의 이름, 직급, 부서명을 입사일 별로 출력하라.
*/
/*
LEFT OUTER JOIN 
SELECT DISTINCT gogekdamsono FROM gogek
*/

SELECT jikwon.jikwonname AS 이름, jikwon.jikwonjik AS 직급, buser.busername AS 부서명, jikwon.jikwonibsail AS 입사일 FROM jikwon
LEFT OUTER JOIN buser ON jikwon.busernum = buser.buserno
WHERE jikwon.jikwonno IN (SELECT DISTINCT gogek.gogekdamsano FROM gogek)
ORDER BY jikwonibsail;

/*
문10) 이순신과 같은 부서에 근무하는 직원과 해당 직원이 관리하는 고객 출력
(고객은 나이가 30 이하면 '청년', 50 이하면 '중년', 그 외는 '노년'으로 표시하고, 고객 연장자 부터 출력)
출력 ==>  직원명    부서명     부서전화     직급      고객명    고객전화    고객구분
          한송이    총무부     123-1111    사원      백송이    333-3333    청년   
*/

/*
inner join
order by (YEAR(NOW()) - (1900 + SUBSTR(gogekjumin, 1, 2))) DESC
*/





