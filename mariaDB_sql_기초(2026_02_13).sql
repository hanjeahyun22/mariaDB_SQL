# ************************************************************************************************************************************
# ************************************************************************************************************************************

-- ================================== 집계함수 ================================== 
-- 집계함수(복수행 함수)  : 전체 자료를 그룹별로 구분해 통계 결과를 얻기 위한 함수
-- NULL값은 집계함수 계산에 포함 X --> sum은 애초에 0이기 때문에, 영향X
SELECT SUM(jikwonpay) AS 합, AVG(jikwonpay) AS 평균 FROM jikwon;
SELECT MAX(jikwonpay) AS 최댓값, MIN(jikwonpay) AS 최솟값 FROM jikwon;

SELECT * FROM jikwon;
UPDATE jikwon SET jikwonpay = NULL WHERE jikwonno = 5;
DESC jikwon;		-- 모든 column에 NULL값 입력이 가능한게 X --> DESC 로 확인 필요!!

SELECT AVG(jikwonpay), AVG(nvl(jikwonpay, 0)) FROM jikwon;					-- NULL값이 들어있는 값은 평균(AVG) 계산에 포함 X --> 'nvl(colcumn명, 0)'을 통해서 NULL값을 0으로 변환 필요
SELECT sum(jikwonpay) / 29, sum(nvl(jikwonpay, 0)) / 30 FROM jikwon;

SELECT COUNT(jikwonno), COUNT(jikwonpay) FROM jikwon;		-- jikwonpay column에 NULL값이 포함되어 있으므로, COUNT(jikwonpay) = 29
SELECT COUNT(*) AS '인원수' FROM jikwon;			-- COUNT(*) 을 통해서 전체 개수 파악 가능

-- STDDEV(column) : 표준편차 계산
-- VAR_SAMP(column) : 분산 계산
SELECT STDDEV(jikwonno) AS 표준편차, VAR_SAMP(jikwonpay) as 분산 FROM jikwon;
SELECT COUNT(*) AS 인원, VAR_SAMP(jikwonpay) AS 분산 FROM jikwon WHERE busernum = 10;
SELECT COUNT(*) AS 인원, VAR_SAMP(jikwonpay) AS 분산 FROM jikwon WHERE busernum = 20;

-- 집계함수 Example --
-- 과장은 몇명?
SELECT COUNT(*) AS 인원수 FROM jikwon WHERE jikwonjik='과장';
-- 2010년 이전에 입사한 남직원은 몇 명?
SELECT COUNT(*) AS 인원수 FROM jikwon WHERE jikwonibsail < '2010-01-01' AND jikwongen = '남';
-- 2015년 이후 입사한 여직원의 연봉합, 연봉평균, 인원수는?
SELECT SUM(jikwonpay) AS 연봉합, AVG(jikwonpay) AS 연봉평균, COUNT(*) FROM jikwon WHERE YEAR(jikwonibsail) >= 2015 AND jikwongen = '여';


-- ================================== 그룹함수 ==================================
-- 그룹함수 : group by 절 : 소계 출력
-- SELECT 그룹column명, 계산함수, ... FROM table명 WHERE 조건 GROUP BY 그룹column명 HAVING 출력조건
-- 그룹 column 에 대해서 order by 할 수 없음. 단, 출력 결과는 order by 가능
-- order by : SELECT로 가져온 "결과 행들"을 어떤 기준으로 정렬해서 보여줄지 결정하는 문법(ASC(오름차순) / DESC(내림차순))
-- HAVING : 각 GROUP BY 의 결과에 대한 조건을 부여함.

-- 성별 연봉 평균, 인원수를 출력
SELECT jikwongen, AVG(jikwonpay), COUNT(*) FROM jikwon GROUP BY jikwongen;		-- jikwongen column을 출력 해줌 으로서, group by 한 결과값이 어떤 항목별로 됐는지 확인 가능

-- 부서별 연봉합
SELECT busernum, SUM(jikwonpay) FROM jikwon GROUP BY busernum; 

-- 부서별 연봉합 : 연봉합이 35000 이상
SELECT busernum, SUM(jikwonpay) FROM jikwon GROUP BY busernum HAVING SUM(jikwonpay) >= 35000;

-- 부서별 연봉합 : 여성만
SELECT busernum, SUM(jikwonpay) FROM jikwon where jikwongen = '여' GROUP BY busernum;

-- 부서별 연봉합 : 연봉합이 15000이상인 여성만
SELECT busernum AS 부서명, SUM(jikwonpay) as paytotal FROM jikwon WHERE jikwongen = '여' GROUP BY busernum HAVING paytotal >= 15000;


-- =====  그룹함수 주의 ===== --
SELECT busernum, SUM(jikwonpay) FROM jikwon ORDER BY busernum GROUP BY busernum;		-- 에러 발생 --GROUP BY 전에는 ORDER BY를 하면 안됨. --> 이미 GROUP BY 내부에서 정렬을 하고 있으므로.
SELECT busernum, SUM(jikwonpay) FROM jikwon GROUP BY busernum  ORDER BY SUM(jikwonpay) DESC;


     

# ************************************************************************************************************************************
#																	table 2개 Join
# ************************************************************************************************************************************
-- Join : 하나 이상의 테이블에서 원하는 자료 추출
-- 반드시 공통 column 필요.

DESC buser;
DESC jikwon;
DESC gogek;

SELECT * FROM buser;
INSERT INTO buser(buserno, busername) VALUES (50, '기획실');			-- 마지막 행 추가

SELECT * FROM jikwon;
ALTER TABLE jikwon MODIFY busernum INT NULL;
UPDATE jikwon SET busernum = NULL WHERE jikwonno = 5;
SELECT * FROM jikwon;

SELECT test.jikwon.jikwonname FROM jikwon;
SELECT mytab.jikwonname from jikwon AS mytab;


-- ================================== CROSS Join ================================== 
-- Cross Join : 한 쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 Join하는 기능
SELECT jikwonname, busername FROM jikwon, buser;		-- 구분이 가능하기 때문에, jikwon.jikwonname, buser.busername 이런 식으로 안써도 괜찮음.

-- 정석적인 문법
SELECT jikwonname, busername FROM jikwon CROSS JOIN buser;

-- CROSS JOIN 중 self join
SELECT a.jikwonname, b.jikwonname FROM jikwon a, jikwon b;


-- ================================== EQUI Join ================================== 
-- Equi Join : Join 조건식에 '='을 사용. 두 테이블은 '같다' 조건으로 join
-- 대부분의 PK-FK Join은 EQIO Join 사용.
SELECT jikwonname, busername FROM jikwon, buser WHERE jikwon.busernum = buser.buserno;


-- non-EQUI Join : Join 조건 식에 '=' 이외에 관계 연산자를 사용
CREATE TABLE paygrade(grade INT PRIMARY KEY, lpay INT, hpay INT);
INSERT INTO paygrade VALUES(1, 0, 1999);
INSERT INTO paygrade VALUES(2, 2000, 2999);
INSERT INTO paygrade VALUES(3, 3000, 3999);
INSERT INTO paygrade VALUES(4, 4000, 4999);
INSERT INTO paygrade VALUES(5, 5000, 9999);
SELECT * FROM paygrade;

SELECT jiktab.jikwonname, jiktab.jikwonpay, paytab.grade
FROM jikwon AS jiktab, paygrade AS paytab
WHERE jiktab.jikwonpay >= paytab.lpay AND jiktab.jikwonpay <= paytab.hpay;


-- inner join : 두 테이블을 join 할 때, 두 테이블에 모두 지정한 column의 데이터가 있는 경우만 추출
-- MariaDB 표준 X
SELECT jtab.jikwonno, jtab.jikwonname, btab.busername FROM jikwon AS jtab, buser AS btab
WHERE jtab.busernum = btab.buserno;		-- oracle에서 주로 사용 --> MariaDB 표준 X

SELECT jikwonno, jikwonname, busername FROM jikwon, buser
WHERE busernum = buserno AND jikwongen = '남';		-- where 조건에 join조건 + record 제한 조건 --> 가독성이 떨어짐

-- MariaDB 표준 문법(ANSI)
SELECT jikwonno, jikwonname, busername from jikwon INNER JOIN buser ON busernum = buserno WHERE jikwongen = '남';


-- outer join : 두 테이블을 join 할 때, 1개의 테이블에만 자료가 있어도 결과 추출
-- Left outer join
SELECT jikwonno, jikwonname, busername FROM jikwon, buser WHERE busernum = buserno(+);		-- orqcle 전용  --> MariaDB 사용 X
-- Right outer join
SELECT jikwonno, jikwonname, busername FROM jikwon, buser WHERE busernum(+) = buserno;		-- orqcle 전용  --> MariaDB 사용 X

-- Left outer join
SELECT jikwonno, jikwonname, busername FROM jikwon LEFT OUTER JOIN buser ON busernum = buserno;
-- Right outer join
SELECT jikwonno, jikwonname, busername FROM jikwon RIGHT OUTER JOIN buser ON busernum = buserno;
-- Full outer join
SELECT jikwonno, jikwonname, busername FROM jikwon FULL OUTER JOIN buser ON busernum = buserno;		-- MariaDB에서는 FULL OURTER JOIN 기능 X
-- > MariaDB에서 Full Outer Join을 쓸 수는 방법 : UNION 사용
SELECT jikwonno, jikwonname, busername FROM jikwon LEFT OUTER JOIN buser ON busernum = buserno
UNION
SELECT jikwonno, jikwonname, busername FROM jikwon RIGHT OUTER JOIN buser ON busernum = buserno;


-- JOIN Example)
SELECT jikwonno AS 직원번호, jikwonname AS 직원명, busername AS 부서명 
from jikwon INNER JOIN buser ON busernum = buserno WHERE jikwongen = '남' AND jikwonname LIKE '김%';

SELECT SUM(jikwonpay) AS hap, COUNT(*) AS COUNT 
FROM jikwon INNER JOIN buser ON busernum=buserno 
WHERE jikwongen = '남';

SELECT * FROM gogek;		-- buser 테이블과는 join 불가(공통 column X)


# ************************************************************************************************************************************
#																	table 3개 Join
# ************************************************************************************************************************************
-- 두 개를 먼저 join 후에, 그 결과와 나머지 table을 join.

SELECT jikwonname, busername, gogekname FROM jikwon, buser, gogek
WHERE busernum = buserno AND jikwonno = gogekdamsano;						-- 직원 중에 고객을 관리하지 않는 직원은 제외

SELECT jikwonname, busername, gogekname FROM jikwon 
INNER JOIN buser ON busernum = buserno
INNER JOIN gogek ON jikwonno = gogekdamsano;



# ************************************************************************************************************************************
#																	UNION Join
# ************************************************************************************************************************************
-- union : 구조가 일치하는 두 개 이상의 테이블 자료를 합쳐 출력. --> 원래의 테이블 계속 유지
-- pum1(INT, VARCHAR(20))
CREATE TABLE pum1(bun INT, pummok VARCHAR(20));
INSERT INTO pum1 VALUES(1, '귤');
INSERT INTO pum1 VALUES(2, '한라봉');
INSERT INTO pum1 VALUES(2, '바나나');
SELECT * FROM pum1;
-- pum2(INT, VARCHAR(20))
CREATE TABLE pum2(mum INT, sangpum VARCHAR(20));
INSERT INTO pum2 VALUES(10, '토마토');
INSERT INTO pum2 VALUES(20, '딸기');
INSERT INTO pum2 VALUES(30, '참외');
INSERT INTO pum2 VALUES(40, '수박');
SELECT * FROM pum2;

SELECT bun AS 번호, pummok AS 품명 FROM pum1
UNION
SELECT mum , sangpum FROM pum2;



# ************************************************************************************************************************************
#																	SUBQUERY
# ************************************************************************************************************************************
-- Subquery : query 내에 query가 있는 형태(주로 안쪽 질의 결과를 바깥쪽 질의에서 참조)
-- 다른 테이블의 결과를 조건으로 쓰고 싶을 때
-- 계산된 값을 이용하고 싶을 때
-- 복잡한 조건을 단계적으로 나눠 처리하고 싶을 때

-- > where 안에 있는 subquery
-- '이미라' 직원과 직급이 같은 직원 출력
SELECT jikwonjik FROM jikwon WHERE jikwonname='이미라';		-- '이미라' 직원은 '대리'
SELECT * FROM jikwon WHERE jikwonjik='대리';

SELECT * FROM jikwon WHERE jikwonjik=(SELECT jikwonjik FROM jikwon WHERE jikwonname='이미라');

-- 직급이 대리 중에서 가장 먼저 입사한 직원은?
SELECT * FROM jikwon
WHERE jikwonjik = '대리' AND
jikwon.jikwonibsail = (SELECT MIN(jikwon.jikwonibsail) FROM jikwon WHERE jikwonjik = '대리');	
-- (SELECT MIN(jikwon.jikwonibsail) FROM jikwon WHERE jikwonjik = '대리') = '2013-02-05' 만을 주기 때문에, jikwonjik = '대리' 추가로 조건 필요


-- 인천에 근무하는 직원 출력
SELECT * FROM jikwon WHERE busernum = (SELECT buserno FROM buser WHERE buserloc = '인천');		-- where안의 조건을 다른 table에서도 얻을 수 있음

-- 인천 이외에 근무하는 직원 출력
SELECT * FROM jikwon WHERE busernum in (SELECT buserno FROM buser WHERE not buserloc = '인천')	-- WHERE not : 뒤의 조건 부정
-- > (SELECT buserno FROM buser WHERE not buserloc = '인천') 의 결과가 (10, 20, 30) 여러개 이므로, '='이 아니라, 'in'으로 조건 받음

SELECT * FROM jikwon
WHERE busernum <> (SELECT buserno FROM buser WHERE buserloc = '인천')		--'<>' 기호도 부정을 의미함.
 
 -- 고객 중 '차일호'와 나이가 같은 고객 자료 출력
SELECT * FROM gogek
WHERE SUBSTR(gogekjumin, 1, 2) = (SELECT SUBSTR(gogekjumin, 1, 2) FROM gogek WHERE gogekname = '차일호');



