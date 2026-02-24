/*
문1) 사번   이름    부서  직급  근무년수  고객확보
        1   홍길동  영업부 사원     6           O   or  X
조건 : 직급이 없으면 임시직, 전산부 자료는 제외
위의 결과를 위한 뷰파일 v_exam1을 작성
*/

CREATE OR REPLACE view v_exam1 AS
SELECT DISTINCT jikwon.jikwonno AS 사번, jikwon.jikwonname AS 이름, buser.busername AS 부서, nvl(jikwon.jikwonjik, '임시직') AS 직급, 
YEAR(NOW()) - DATE_FORMAT(jikwon.jikwonibsail, '%Y') AS 근무년수,
case nvl(gogekname, 'a')
	when 'a' then 'X'
	ELSE 'O'
END AS 고객확보
FROM jikwon
LEFT OUTER JOIN buser ON jikwon.busernum = buser.buserno
LEFT OUTER JOIN gogek ON jikwon.jikwonno = gogek.gogekdamsano
WHERE busername <> '전산부' OR busername IS NULL;

SELECT * FROM v_exam1;

/*
문2) 부서명   인원수
       영업부     7
조건 : 직원수가 가장 많은 부서 출력
위의 결과를 위한 뷰파일 v_exam2을 작성
*/

CREATE OR REPLACE VIEW v_exam2 AS
SELECT buser.busername AS 부서명, COUNT(jikwon.busernum) AS 인원수 FROM jikwon
INNER JOIN buser ON jikwon.busernum = buser.buserno
GROUP BY jikwon.busernum
ORDER BY 인원수 DESC
LIMIT 1;

/*
CREATE OR REPLACE VIEW v_exam2 AS
SELECT buser.busername AS 부서명, COUNT(*) AS 인원수 FROM buser
INNER JOIN jikwon ON buser.buserno = jikwon.busernum
GROUP BY busername
HAVING COUNT(*) = (SELECT COUNT(*) FROM jikwon GROUP BY busernum ORDER BY COUNT(*) DESC LIMIT 1);
*/

SELECT * FROM v_exam2;


/*
문3) 가장 많은 직원이 입사한 요일에 입사한 직원 출력
    직원명   요일     부서명   부서전화
    한국인  수요일   전산부   222-2222
위의 결과를 위한 뷰파일 v_exam3을 작성  
*/
CREATE OR REPLACE VIEW v_exam3 AS
SELECT jikwon.jikwonname AS 직원명,
case DATE_FORMAT(jikwon.jikwonibsail, '%w')
	when 0 then '일요일'
	when 1 then '월요일'
	when 2 then '화요일'
	when 3 then '수요일'
	when 4 then '목요일'
	when 5 then '금요일'
	when 6 then '토요일'
	END AS 요일,
buser.busername AS 부서명, SUBSTR(buser.busertel, -8, 8) AS 부서전화
FROM jikwon
LEFT OUTER JOIN buser ON jikwon.busernum = buser.buserno						-- 직원명은 다 나와야 하기 때문에, LEFT OUTER JOIN 사용
WHERE 요일 = (SELECT case DATE_FORMAT(jikwon.jikwonibsail, '%w')
	when 0 then '일요일'
	when 1 then '월요일'
	when 2 then '화요일'
	when 3 then '수요일'
	when 4 then '목요일'
	when 5 then '금요일'
	when 6 then '토요일'
	END
	ORDER BY COUNT(*) DESC LIMIT 1)
;

-- WHERE 요일 = (SELECT v_exam3.요일 FROM v_exam3 GROUP BY 요일 ORDER BY COUNT(v_exam3.요일) DESC LIMIT 1)

SELECT * FROM v_exam3;











