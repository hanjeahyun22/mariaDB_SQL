/*
[문항1] TRUNCATE TABLE 말고 테이블을 삭제하는 일반적인 명령어 형식을 적으시오.
(배점:5)
*/
-- DROP TABLE


/*
[문항2] 외래키가 참조하는 대상은 무엇인가요?
(배점:5)
*/
-- PRIMARY KEY


/*
[문항3] 그룹화 후 조건을 지정하는 명령어는 무엇인가요?
(배점:5)
*/
-- ORDER BY


/*
[문항4] 다음 DDL 문에서 pay의 입력 값을 2000 이상만 입력할 수 있도록 제약 조건을 기술하시오.
(배점:5)
*/
create table emp (eno INT PRIMARY KEY, ename varchar(10), job varchar(9), pay INT CHECK (pay >= 2000))
SELECT * FROM emp;
DROP TABLE emp;


/*
5. MariaDB에서 WHERE 절을 생략하고 UPDATE 문을 실행하면 어떤 일이 발생하는가?
*/
-- 
CREATE VIEW exam_5 AS SELECT * FROM jikwon;
SELECT * FROM exam_5;
UPDATE exam_5 SET jikwonpay = 22222 WHERE jikwonname = '홍길동';
UPDATE exam_5 SET jikwonpay = 22222;
-- UPDATE를 지정한 column 전체 행의 rocord를 변경값으로 수정


/*
[문항6] 테이블 생성 시 부여하는 제약 조건의 종류를 아는 대로 3개 이상 기술하시오.
(배점:5)
*/
-- primary key 제약 	: 중복 레코드 입력 방지
-- foreign key 제약 	: 특정 collum이 다른 table의 collum을 참조
-- check 제약 			: 입력 자료의 특정 collum값 조건 검사
-- unique 제약 			: 특정 collum값 중복 불허
 

/*
[문항7] buser 테이블에서 buserno(부서번호)가 3인 데이터(레코드)를 삭제하는 SQL 구문을 작성하시오.
(배점:5)
*/
SELECT * FROM buser;
DELETE FROM buser WHERE buserno = 30;
DELETE FROM buser WHERE buserno = 3;
ROLLBACK;


/*
[문항8] MariaDB에서 NULL 값과 비교할 때 = 연산자를 사용할 수 없다. 그러면 가능한 연산자는 무엇인가?
(배점:5)
*/
-- nvl(value1, value2)
-- nvl2(value1, value2, value3)


/*
[문항9] jikwon 테이블과 buser 테이블을 이용하여 직급이 '과장'인 직원만 조회하는 query문을 작성하시오.
조건 : join 사용
(배점:5)
출력 형태 예:
  jikwonno  jikwonname  busername  jikwonjik
        3              이순신            영업부            과장
  ...
*/
SELECT jikwon.jikwonno, jikwon.jikwonname, buser.busername, jikwon.jikwonjik FROM jikwon
INNER JOIN buser ON jikwon.busernum = buser.buserno
WHERE jikwon.jikwonjik = '과장';


/*	
[문항10] MariaDB 문자 자료형에서 char과 VARCHAR의 차이점을 간단히 설명하시오.
(배점:5)
*/
-- 모두 문자형임을 나타냄.
-- CHAR(n) 		 :  글자수(n개) 고정 -> 고정 문자
-- VARCHAR(n)	 :  글자수(n개)보다 크거나 작게 입력 가능 -> 가변 문자

/*
[문항11] jikwon 테이블에서 연봉이 5000 이상이고 7000 이하인 직원을 검색하여 직원번호, 직원명, 연봉을 출력하는 SQL문을 두 가지 방법(and, between)으로 작성하시오.
(배점:10)
*/
SELECT jikwonno AS 직원번호, jikwonname AS 직원명, jikwonpay AS 연봉 FROM jikwon
WHERE jikwonpay >= 5000 AND jikwonpay <= 7000;

SELECT jikwonno AS 직원번호, jikwonname AS 직원명, jikwonpay AS 연봉 FROM jikwon
WHERE jikwonpay BETWEEN 5000 AND 7000;


/*
[문항12] jikwon 테이블을 사용하여 평균 연봉보다 연봉이 높은 직원들을 모두 출력하는 select 문(sub query)을 작성하시오. 칼럼은 모두 출력.
(배점:10)
*/
SELECT * FROM jikwon WHERE jikwonpay > (SELECT AVG(jikwonpay) FROM jikwon);


/*
[문항13] 아래 두 개의 ERD를 보고 테이블 생성을 위한 DDL문을 MariaDB 형식에 맞게 작성하시오.
(배점:10)
customers          ----------        orders
==================================
pk  cno  : 정수                            pk  ono : 정수 
---------------------------------------------------------
    cname : 고정문자(10)          odate : 날짜시간
    caddress : 가변문자(50)      oaddress : 가변문자(50)
    cemail  : 고정문자(20)        ophone : 가변문자(20)
    cphone : 가변문자(20)        ostatus : 가변문자(10)
                                 ono_cus : fk
==================================
*/
CREATE TABLE customers(cno INT PRIMARY KEY, cname CHAR(10), caddress VARCHAR(50), cemail CHAR(20), cphone VARCHAR(20));
SELECT * FROM customers;
DESC customers;
DROP TABLE customers;


CREATE TABLE orders(ono INT PRIMARY KEY, odate DATETIME, oaddress VARCHAR(50), ophone VARCHAR(20), ostatus VARCHAR(10),
	ono_cus INT, FOREIGN KEY(ono_cus) REFERENCES customers(cno));
SELECT * FROM orders;
DESC orders;
DROP TABLE orders;

/*
[문항14] jikwon 테이블을 사용하기로 한다.
2015 ~ 2020 년 사이에 입사한 직원을 대상으로 년도별 인원수와 연봉평균을 출력하는 DML문을 기술하시오.
(배점:10)
*/
SELECT YEAR(jikwonibsail) as 입사년도, COUNT(*) AS 인원수, AVG(jikwonpay) FROM jikwon
WHERE DATE_FORMAT(jikwonibsail, '%Y') BETWEEN 2015 AND 2020
GROUP BY YEAR(jikwonibsail);


/*
[문항15] jikwon, gogek 테이블을 사용해 '평균 급여보다 급여가 높은 직원과 그 직원이 담당하는 고객 수'를 조회하는 select 문을 작성하시오.
(배점:10)
출력: 직원명 급여 고객수
예)
직원명  급여  고객수
홍길동  9900    1
한송이  8800    3
김부만  8600    0
한국인  8000    0
이순신  7900    3
...
이유라  5500    0
건수 : 12
힌트: join, subquery, group by 등 사용
*/

SELECT jikwon.jikwonname AS 직원명, jikwon.jikwonpay AS 급여, nvl(COUNT(gogek.gogekdamsano), 0) AS 고객수 FROM jikwon
LEFT OUTER JOIN gogek ON jikwon.jikwonno = gogek.gogekdamsano
GROUP BY gogek.gogekdamsano
HAVING jikwon.jikwonpay > (SELECT AVG(jikwon.jikwonpay) FROM jikwon);


SELECT * FROM jikwon;
SELECT * FROM gogek;

















