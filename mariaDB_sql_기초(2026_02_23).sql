# ************************************************************************************************************************************
#																	SUBQUERY
# ************************************************************************************************************************************

-- ==========================쿼리문은 동일한 결과를 여러 방법으로 수행가능======================= 

-- 총무부에 근무하는 직원들이 관리하는 고객 출력
-- subquery 사용
SELECT gogekno, gogekname, gogektel FROM gogek
WHERE gogekdamsano IN (SELECT jikwonno FROM jikwon WHERE busernum = (SELECT buserno FROM buser WHERE busername = '총무부'));

-- join 사용
SELECT gogekno, gogekname, gogektel FROM gogek
INNER JOIN jikwon ON jikwon.jikwonno = gogek.gogekdamsano
INNER JOIN buser ON jikwon.busernum = buser.buserno
WHERE buser.busername = '총무부';


-- ================================== any, all 연산자 ================================== 
-- and, all 연산자 : null 인 자료는 제외하고 작업한다.	'<=' 도 가능
-- < any : subquery의 반환값 중 최대값 보다 작은 ~
-- > any : subquery의 반환값 중 최소값 보다 큰 ~
-- < all : subquery의 반환값 중 최대값 보다 작은 ~
-- > all : subquery의 반환값 중 최소값 보다 큰 ~

-- '대리'의 최소값보다 작은 연복을 받는 직원은?
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon
WHERE jikwonpay < ANY (SELECT jikwonpay FROM jikwon WHERE jikwonjik = '대리');

-- 30번 부서의 최고 연봉자보다 연봉을 많이 받는 직원은?
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon
WHERE jikwonpay > ALL (SELECT jikwonpay FROM jikwon WHERE jikwonno = 30);

-- 30번 부서의 최저 연봉자보다 연봉을 많이 받는 직원은?
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon
WHERE jikwonpay > ANY (SELECT jikwonpay FROM jikwon WHERE jikwonno = 30);


-- ================================== exists 연산자 ================================== 
-- EXISTS : True값 반환
-- NOT EXISTS : False값 반환

-- 직원이 있는 부서 출력
SELECT busername, buserloc FROM buser bu
WHERE EXISTS (SELECT 'imsi' FROM jikwon WHERE jikwon.busernum = bu.buserno);

-- 직원이 없는 부서 출력
SELECT busername, buserloc FROM buser bu
WHERE not EXISTS (SELECT 'imsi' FROM jikwon WHERE jikwon.busernum = bu.buserno);


-- ================================== FROM 절에 사용하는 subquery ================================== 

-- 전체 평균 연봉과 최대 연봉 사이의 연봉을 받는 직원 출력
SELECT jikwonno, jikwonname, jikwonpay FROM jikwon a, (SELECT AVG(jikwonpay) avgs, MAX(jikwonpay) maxs FROM jikwon) b
WHERE a.jikwonpay BETWEEN b.avgs AND b.maxs;


-- ================================== GROUP BY 의 HAVING 절에 포함된 subquery ================================== 

-- 부서별 평균 연봉 중 30번 부서의 평균 연봉보다 큰 자료(부서) 출력
SELECT busernum, AVG(jikwonpay) FROM jikwon
GROUP BY busernum
HAVING AVG(jikwonpay) > (SELECT AVG(jikwonpay) FROM jikwon WHERE busernum = 30);


-- ================================== 상관 subquery ================================== 
-- 상관 subquery : OUTER query의 각 행을 inner query에서 참조하여 수행하는 subquery
-- 안쪽 질의에서 바깥쪽 질의를 참조하고, 다시 안쪽의 결과를 바깥쪽 질의에서 참조하는 형태

-- 각 부서의 최대 연봉자는?
SELECT * FROM jikwon a
WHERE a.jikwonpay = (SELECT MAX(b.jikwonpay) FROM jikwon b WHERE a.busernum = b.busernum);

-- 연봉 순위 3위 이내의 직원 출력(descending)
SELECT a.jikwonno, a.jikwonname, a.jikwonpay FROM jikwon a
WHERE 3 > (SELECT COUNT(*) FROM jikwon b WHERE b.jikwonpay > a.jikwonpay)
AND jikwonpay IS NOT NULL
ORDER BY jikwonpay DESC;


-- ================================== subquery를 이용한 table 생성 및 insert 수행 ==================================
-- 물리적으로 동일한 table을 만들기 때문에, 메모리를 차지함.
CREATE TABLE jiktab1 AS (SELECT * FROM jikwon);		-- jikwon과 동일한 테이블 생성
DESC jiktab1;		-- jikwon table의 Primary Ket제외
DESC jikwon;	
SELECT * FROM jiktab1;

CREATE TABLE jiktab2 AS (SELECT * FROM jikwon WHERE 1 = 0);		-- jikwon과 동일한 구조의 테이블 생성	-- 1=0 조건을 만족하는 값이 없기 때문.
SELECT * FROM jiktab2;
DESC jiktab2;

INSERT INTO jiktab2 (SELECT * FROM jikwon WHERE jikwonjik = '과장');		-- insert + subquery
SELECT * FROM jiktab2;

INSERT INTO jiktab2(jikwonno, jikwonname, busernum)
(SELECT jikwonno, jikwonname, busernum FROM jikwon WHERE jikwonjik = '대리');		-- jikwonjik의 default값이'대리'로 되어있기 때문에 '대리' 조건을 충족하는 값이 없으면 '대리'로 출력
SELECT * FROM jiktab2;

SELECT * FROM jiktab1;
UPDATE jiktab1 SET jikwonjik = (SELECT jikwonjik FROM jiktab1 WHERE jikwonname = '이순신') WHERE jikwonno = 2;

DELETE FROM jiktab1 WHERE jikwonno IN (SELECT DISTINCT gogekdamsano FROM gogek);
SELECT * FROM jiktab1;


# ************************************************************************************************************************************
#									 			트랜잭션 : DB의 상태를 변경시키는 논리적인 작업 단위
# ************************************************************************************************************************************
-- 트랜잭션의 4가지 특징 : ACID
-- Insert, Update, Delete 시, 트랜잭션이 시작됨
-- commit, rollback으로 트랜잭션 종료
-- 서버종료, 타임아웃 등이 발생해도 트랜잭션 종료함
SHOW VARIABLES LIKE 'autocommit%';		-- autocommit 설정 확인 필요 -- 기본값 on
SET autocommit = TRUE		-- autocommit 설정
SET autocommit = FALSE		-- autocommit 해제

-- 트랜잭션 연습
CREATE TABLE jiktab3 AS SELECT * FROM jikwon;
SELECT * FROM jiktab3;		-- 연습용 테이블

SET autocommit = FALSE

-- 연습 1
DELETE FROM jiktab3 WHERE jikwonno = 3;
SELECT * FROM jiktab3;
-- ROLLBACK;		-- 트랜잭션 종료 (DB 서버와 관련없이 해당 컴퓨터(Cleint)에서만 진행)
COMMIT;		-- 트랜잭션 종료 (DB 서버에 현재 컴퓨터(Cleint)의 내용을 근거로 원본 갱신)
SELECT * FROM jiktab3;

SET autocommit = TRUE;


-- 연습2  : 부분적 transaction 처리 가능(savepoint, 즉 저장점을 이용)
SET autocommit  = FALSE;
SELECT * FROM jiktab3 WHERE jikwonno = 4;
UPDATE jiktab3 SET jikwonpay = 7777 WHERE jikwonno = 4;			-- 트랜잭션 시작
SAVEPOINT a;													
UPDATE jiktab3 SET jikwonpay = 8888 WHERE jikwonno = 5;
SELECT * FROM jiktab3;
ROLLBACK TO SAVEPOINT a;									-- 부분 작업 취소 : a 시점으로 rollback		-- 트랜잭션 종료X	
SELECT * FROM jiktab3 WHERE jikwonno <= 6;
ROLLBACK;														-- 전체 작업 취소 : a 보다 더 이전 시점으로 rollback		-- 트랜잭션 종료 O
SELECT * FROM jiktab3 WHERE jikwonno <= 6;			

UPDATE jiktab3 SET jikwonpay = 8888 WHERE jikwonno = 5;		-- 트랜잭션 시작
COMMIT;																		-- 트랜잭션 종료

SET autocommit = TRUE;
SHOW VARIABLES LIKE 'autocommit%';


-- 교착상태(DeadLock) : 두 개 이상의 트랜젝션이 서로 상대방이 가진 락(Lock)을 기다리면서 영원히 진행하지 못하는 상태
/*
-- MariaDB Prompt를 통해서 두명의 사용자가 DBserver 사용 상황 가정
mariadb -h 127.0.0.1 -u root -p
enter password
use test
*/
-- 해결책은 트랜젝션을 수행완료 또는 취소하면 됨.
-- 일관성(Consistenty) 유지가 중요

SET autocommit = FALSE;
SELECT * FROM jiktab3 WHERE jikwonno = 7;
UPDATE jiktab3 SET jikwonpay = 21654 WHERE jikwonno = 7;
SELECT * FROM jiktab3 WHERE jikwonno = 7;
COMMIT;
SELECT * FROM jiktab3;
SET autocommit = TRUE;



# ************************************************************************************************************************************
#									 			VIEW 파일
# ************************************************************************************************************************************
-- 물리적인 테이블을 근거로 select 문(조건 포함)을 파일로 저장하여, 가상의 테이블로 사용한다.
-- 물리적인 테이블이 아니므로 메모리 소모가 거의 없다.
-- 복잡하고 긴 쿼리문을 단순화 가능, 보안 강화, 자료의 독립성 확보
-- 형식 : create [or replace] view 뷰파일명 as select문
-- 		 alter view 뷰파일명 ~
-- 		 drop view 뷰파일명 ~

SELECT jikwonno, jikwonname, jikwonpay FROM jikwon WHERE jikwonibsail < '2010-12-31';

CREATE OR REPLACE VIEW v_a AS SELECT jikwonno, jikwonname, jikwonpay FROM jikwon WHERE jikwonibsail < '2010-12-31';		-- 'OR REPLACE'를 붙이면, 동일 이름의 View 파일이 이미 있더라도, 덮어쓰기로 생성 가능
SHOW TABLES;
SELECT * FROM v_a;
DESC v_a;

SHOW FULL TABLES IN test WHERE table_type LIKE 'view';		-- VIEW 파일 목록만 볼 수 있음
SELECT SUM(jikwonpay) AS 연봉합 FROM v_a;

CREATE VIEW v_b AS (SELECT * FROM jikwon WHERE jikwonname LIKE '김%' OR jikwonname LIKE '이%' OR jikwonname LIKE '박%');
SELECT * FROM v_b;
SELECT jikwonno, jikwonname, jikwonpay FROM v_b WHERE jikwonjik = '사원';

-- VIEW 파일의 원본 데이터가 손상되면, VIEW 실행 시, 에러 발생
ALTER TABLE jikwon RENAME kbs;
SELECT * FROM v_b;
ALTER TABLE kbs RENAME jikwon;

CREATE VIEW v_c AS (SELECT * FROM jikwon ORDER BY jikwonpay DESC);
SELECT * FROM v_c;

CREATE VIEW v_d AS (SELECT jikwonno, jikwonname, jikwonpay * 10000 as ypay FROM jikwon ORDER BY jikwonpay DESC);
SELECT * FROM v_d;

CREATE VIEW v_e AS SELECT jikwonname, ypay FROM v_d WHERE ypay >= 50000000;
SELECT * FROM v_e;

UPDATE v_e SET jikwonname = '김치국' WHERE jikwonname = '김부만';		-- v_e 파일을 수정하면 원본 파일(jikwon 테이블)도 수정됨.
SELECT * FROM v_e;
SELECT * FROM v_d;
SELECT * FROM jikwon;


DELETE FROM v_d WHERE jikwonname = '김이화';		-- '김이화'는 gogek table과 Foriegn Key로 설정되어 있기 때문에, 삭제 불가능 -> 에러 발생
DELETE FROM v_d WHERE jikwonname = '최미숙';
SELECT * FROM v_d;
SELECT * FROM jikwon;
DELETE FROM v_d WHERE ypay = 41000000;				-- 계산을 거친 값이라도, 삭제하면 원본 테이블에서도 삭제
SELECT * FROM v_d;
SELECT * FROM jikwon;

SELECT * FROM v_d;
UPDATE v_d SET ypay = 1111 WHERE jikwonname = '홍길동';		-- View 테이블에 계산에 의해 만들어진 column은 수정 불가능 -> 에러 발생

CREATE OR REPLACE view v_e AS (SELECT jikwonno, jikwonname, busernum, jikwonpay FROM jikwon);
SELECT * FROM v_e;
INSERT INTO v_e VALUES(31, '김밥', 20, 5000);		-- View 의 inserts는 원본 table의 NOT NULL에 주의.
SELECT * FROM v_e;
SELECT * FROM jikwon;		-- jikwonjik만 default로 '사원'이 들어가게 되어있고, 그 외 나머지 값들은 NULL

DESC jikwon;					-- 원본 테이블(jikwon)의 jikwonname 은 NOT NULL로 설정되어 있음.

CREATE OR REPLACE VIEW v_f AS (SELECT jikwonno, jikwonname, busernum, jikwonpay, jikwonibsail FROM jikwon WHERE jikwonibsail < '2015-01-01');
SELECT * FROM v_f;

INSERT INTO v_f VALUES (32, '공기밥', 10, 6000, '2014-05-06');
-- 원본 테이블(jikwon)에는 추가 됐지만, View 테이블에서는 'jikwonibsail < '2015-01-01'' 조건 때문에, 제외
INSERT INTO v_f VALUES (33, '주먹밥', 10, 7000, '2025-05-06');	
SELECT * FROM jikwon;

CREATE VIEW v_group AS (SELECT jikwonjik, SUM(jikwonpay) AS hap, AVG(jikwonpay) AS ave FROM jikwon GROUP BY jikwonjik);
SELECT * FROM v_group;			-- GROUP BY에 의한 view는 참조만 가능(insert, update, delete 불가능)

CREATE OR REPLACE VIEW v_join AS 
(SELECT jikwonno, jikwonname, busername, jikwonjik FROM jikwon 
	INNER JOIN buser ON jikwon.busernum = buser.buserno 
	WHERE jikwon.busernum IN (10, 20));
SELECT * FROM v_join;

UPDATE v_join SET jikwonname = '손오공' WHERE jikwonname = '박명화'; 

-- join 에 의한 view는 한 개의 테이블만 수정에 참여 가능
-- MariaDB에서는 불가능
UPDATE v_join SET jikwonname = '사오정', busername  = '영업부' WHERE jikwonname = '손오공';		-- busername column은 buser 테이블에 속해있음. -> 에러 발생
DELETE FROM v_join WHERE jikwonname = '손오공';







