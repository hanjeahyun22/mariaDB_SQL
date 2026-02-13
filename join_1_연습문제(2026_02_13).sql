SELECT * FROM jikwon;
SELECT * FROM gogek;
SELECT * FROM buser;


/*

JOIN 연습1 ---------------

문1) 직급이 '사원' 인 직원이 관리하는 고객자료 출력
출력 ==>  사번   직원명   직급      고객명    고객전화    고객성별
           3     한국인   사원       우주인    123-4567       남
*/

SELECT jikwon.jikwonno AS 사번, jikwon.jikwonname AS 직원명, gogek.gogekname AS 고객명, gogek.gogektel AS 고객전화, 
case
	when gogek.gogekjumin LIKE ('%-2%') then '여'
	ELSE '남'
	END AS 고객성별
 FROM jikwon INNER JOIN gogek ON jikwon.jikwonno = gogek.gogekdamsano;


/*
문2) 직원별 고객 확보 수  -- GROUP BY 사용
    - 모든 직원 참여
*/

SELECT * FROM jikwon;
SELECT * FROM gogek;
SELECT * FROM buser;

SELECT jikwon.jikwonname AS 직원, COUNT(*) AS 고객확보수 FROM jikwon LEFT OUTER JOIN gogek on jikwon.jikwonno = gogek.gogekdamsano GROUP BY jikwon.jikwonname;		-- 동명 이인 발생
SELECT jikwon.jikwonno AS 직원, COUNT(*) AS 고객확보수 FROM jikwon LEFT OUTER JOIN gogek on jikwon.jikwonno = gogek.gogekdamsano GROUP BY jikwon.jikwonno;			-- Pramary Key로 해서 동명이인 누락 방지


/*
문3) 고객이 담당직원의 자료를 보고 싶을 때 즉, 고객명을 입력하면,  담당직원 자료 출력  

        :    ~ WHERE GOGEK_NAME='강나루'
출력 ==>  직원명       직급
          한국인       사원
*/


SELECT jikwon.jikwonname AS 직원명, jikwon.jikwonjik AS 직급 FROM gogek INNER JOIN jikwon ON jikwon.jikwonno = gogek.gogekdamsano WHERE gogek.gogekname='강나루';


/*
문4) 직원명을 입력하면 관리고객 자료 출력
       : ~ WHERE JIKWON_NAME='이순신'
출력 ==> 고객명   고객전화          주민번호           나이
         강나루   123-4567    700512-1234567      38
 */

SELECT gogek.gogekname AS 고객명, gogek.gogektel AS 고객전화, gogek.gogekjumin AS 주민번호, YEAR(NOW())-SUBSTR(gogek.gogekjumin,1, 2)-1900 AS 나이
FROM jikwon INNER JOIN gogek ON jikwon.jikwonno = gogek.gogekdamsano WHERE jikwon.jikwonname = '이순신';







