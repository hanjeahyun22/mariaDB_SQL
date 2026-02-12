
# ************************************************************************************************************************************
# ************************************************************************************************************************************

create table sangdata(
code int primary key,
sang varchar(20),
su int,
dan int);  

insert into sangdata values(1,'장갑',3,10000);
insert into sangdata values(2,'벙어리장갑',2,12000);
insert into sangdata values(3,'가죽장갑',10,50000);
insert into sangdata values(4,'가죽점퍼',5,650000);

SELECT * FROM sangdata;
DESC sangdata;

# ----------------------------------------------------------------------------------

create table buser(
buserno int primary key, 
busername varchar(10) not null,
buserloc varchar(10),
busertel varchar(15));

insert into buser values(10,'총무부','서울','02-100-1111');
insert into buser values(20,'영업부','서울','02-100-2222');
insert into buser values(30,'전산부','서울','02-100-3333');
insert into buser values(40,'관리부','인천','032-200-4444');

SELECT * FROM buser;
DESC buser;

# ----------------------------------------------------------------------------------
create table jikwon(
jikwonno int primary key,
jikwonname varchar(10) not null,
busernum int not NULL,		-- jikwon(busernum), buser(buserno)은 공통 column -->> join 을 위한 준비		-- 편의 상 Foreign Key 라고 적진 않음. --> 구속력이 너무 강해짐.
jikwonjik varchar(10) default '사원', 
jikwonpay int,
jikwonibsail date,
jikwongen varchar(4),
jikwonrating char(3),
CONSTRAINT ck_jikwongen check(jikwongen='남' or jikwongen='여'));

insert into jikwon values(1,'홍길동',10,'이사',9900,'2008-09-01','남','a');
insert into jikwon values(2,'한송이',20,'부장',8800,'2010-01-03','여','b');
insert into jikwon values(3,'이순신',20,'과장',7900,'2010-03-03','남','b');
insert into jikwon values(4,'이미라',30,'대리',4500,'2014-01-04','여','b');
insert into jikwon values(5,'이순라',20,'사원',3000,'2017-08-05','여','b');
insert into jikwon values(6,'김이화',20,'사원',2950,'2019-08-05','여','c');
insert into jikwon values(7,'김부만',40,'부장',8600,'2009-01-05','남','a');
insert into jikwon values(8,'김기만',20,'과장',7800,'2011-01-03','남','a');
insert into jikwon values(9,'채송화',30,'대리',5000,'2013-03-02','여','a');
insert into jikwon values(10,'박치기',10,'사원',3700,'2016-11-02','남','a');
insert into jikwon values(11,'김부해',30,'사원',3900,'2016-03-06','남','a');
insert into jikwon values(12,'박별나',40,'과장',7200,'2011-03-05','여','b');
insert into jikwon values(13,'박명화',10,'대리',4900,'2013-05-11','남','a');
insert into jikwon values(14,'박궁화',40,'사원',3400,'2016-01-15','여','b');
insert into jikwon values(15,'채미리',20,'사원',4000,'2016-11-03','여','a');
insert into jikwon values(16,'이유가',20,'사원',3000,'2016-02-01','여','c');
insert into jikwon values(17,'한국인',10,'부장',8000,'2006-01-13','남','c');
insert into jikwon values(18,'이순기',30,'과장',7800,'2011-11-03','남','a');
insert into jikwon values(19,'이유라',30,'대리',5500,'2014-03-04','여','a');
insert into jikwon values(20,'김유라',20,'사원',2900,'2019-12-05','여','b');
insert into jikwon values(21,'장비',20,'사원',2950,'2019-08-05','남','b');
insert into jikwon values(22,'김기욱',40,'대리',5850,'2013-02-05','남','a');
insert into jikwon values(23,'김기만',30,'과장',6600,'2015-01-09','남','a');
insert into jikwon values(24,'유비',20,'대리',4500,'2014-03-02','남','b');
insert into jikwon values(25,'박혁기',10,'사원',3800,'2016-11-02','남','a');
insert into jikwon values(26,'김나라',10,'사원',3500,'2016-06-06','남','b');
insert into jikwon values(27,'박하나',20,'과장',5900,'2012-06-05','여','c');
insert into jikwon values(28,'박명화',20,'대리',5200,'2013-06-01','여','a');
insert into jikwon values(29,'박가희',10,'사원',4100,'2016-08-05','여','a');
insert into jikwon values(30,'최미숙',30,'사원',4000,'2015-08-03','여','b');

SELECT * FROM jikwon;
DESC jikwon;

# ----------------------------------------------------------------------------------

create table gogek(
gogekno int primary key,
gogekname varchar(10) not null,
gogektel varchar(20),
gogekjumin char(14),
gogekdamsano int,
CONSTRAINT FK_gogekdamsano foreign key(gogekdamsano) references jikwon(jikwonno));		-- gogek(gogekdamsano)와 jikwon(jikwonno)를 Foriegn Key로 설정 --> 구속력이 강함

insert into gogek values(1,'이나라','02-535-2580','850612-1156777',5);
insert into gogek values(2,'김혜순','02-375-6946','700101-1054777',3);
insert into gogek values(3,'최부자','02-692-8926','890305-1065777',3);
insert into gogek values(4,'김해자','032-393-6277','770412-2028777',13);
insert into gogek values(5,'차일호','02-294-2946','790509-1062777',2);
insert into gogek values(6,'박상운','032-631-1204','790623-1023777',6);
insert into gogek values(7,'이분','02-546-2372','880323-2558777',2);
insert into gogek values(8,'신영래','031-948-0283','790908-1063777',5);
insert into gogek values(9,'장도리','02-496-1204','870206-2063777',4);
insert into gogek values(10,'강나루','032-341-2867','780301-1070777',12);
insert into gogek values(11,'이영희','02-195-1764','810103-2070777',3);
insert into gogek values(12,'이소리','02-296-1066','810609-2046777',9);
insert into gogek values(13,'배용중','02-691-7692','820920-1052777',1);
insert into gogek values(14,'김현주','031-167-1884','800128-2062777',11);
insert into gogek values(15,'송운하','02-887-9344','830301-2013777',2);

SELECT * FROM gogek;
DESC gogek;

# ************************************************************************************************************************************
# ************************************************************************************************************************************

-- ================= SELECT : DB 서버로부터 클라이언트로 자료를 읽는 명령 ================= 
-- DB 서버에서 개인 pc의 RAM(주기억장치)로 불러 읽어 오고, 불러온 RAM 안의 데이터로 작업
-- 이후에 UPDATE, INSERT 등의 수정 작업을 하더라도, DB 서버에 바로 저장되는게 아니라, RAM 안에 읽어온 데이터 안에서 수정이 일어남
-- 작업 완료한 RAM 속의 데이터를 DB 서버로 갱신
-- SELECTION(DB에서 원하는 column만 불러옴)
-- PROJECTION(DB에서 원하는 record만 불러옴)
SELECT 10, '안녕', 12 / 3 as 결과 FROM DUAL;		-- FROM DUAL : DB서버에서 불러오지 않고 , 가상 table을만듦
SELECT * FROM jikwon;				-- DB 서버에서 RAM으로 데이터를 불러오고, 화면에 보여주기까지 하는 TOOL
SELECT jikwonno, jikwonname FROM jikwon;
SELECT jikwonno, jikwongen, busernum, jikwonname FROM jikwon;		-- SELECTION -- column의 순서를 원하는대로 설정 가능(원본 table의 순서와 상관X)
SELECT jikwonno AS 직원번호, jikwonname AS 직원명 FROM jikwon;		--  python에서는 별명만 인식 가능 -->  DB서버의 data와 RAM에 읽은 data 구분!!
SELECT jikwonname, jikwonpay, jikwonpay * 0.05 AS tax FROM jikwon;
SELECT jikwonname, CONCAT(jikwonname, '님') AS jikwonetc FROM jikwon;		-- 'CONCAT'와 같이, 기존 column을 가공해서 RAM에 읽어올 수 있음


-- ================================== 정렬(sort) ================================== 
-- ORDER BY : DATAB가 특성 별로 묶임
# order by column명 ASC(오름차순)/DESC(내림차순)	-- ASC는 생략 가능
-- DISTINCT : SELECT로 읽어 올 column 자료 중에서, 중복 배제
SELECT * FROM jikwon ORDER BY jikwonpay ASC;
SELECT * FROM jikwon ORDER BY jikwonpay;
SELECT * FROM jikwon ORDER BY jikwonpay DESC;
SELECT * FROM jikwon ORDER BY jikwonjik ASC;
SELECT * FROM jikwon ORDER BY jikwonjik ASC, busernum DESC, jikwongen ASC, jikwonpay;		
-- 가장 먼저, jikwonjik을 가나다 오름차순으로 정렬 -->> 중복 데이터에서는 busernum 내림차순 정렬
--  -->> 중복 데이터에서는 jikwongen 오름차순 -->> 중복 데이터에서는 jikwonpay 오름차순
SELECT jikwonname, jikwonpay, jikwonpay / 100 AS pay FROM jikwon ORDER BY pay DESC; -- 'jikwonpay / 100'을 'pay'라는 별명을 붙이고, 내림차순으로 정렬 -->> 별명 도 ORDER BY에 사용 가능
SELECT DISTINCT jikwonjik FROM jikwon;		-- 중복 배제
SELECT DISTINCT jikwonjik, jikwonname FROM jikwon;		-- 에러 발생


-- ================= 연산자 : '()' > '산술(*,/,+,-)' > '관계(비교)' > 'isnull, like in' > 'between, not' > 'and' > 'or'  ================= 
SELECT * FROM jikwon WHERE jikwonjik='대리';		-- where   조건문을 통해서, 원하는 record 만 select
SELECT * FROM jikwon WHERE jikwonno=3;
SELECT * FROM jikwon WHERE jikwonibsail='2010-03-03';
SELECT * FROM jikwon WHERE jikwonno = 5 OR jikwonno = 7;
SELECT * FROM jikwon WHERE jikwonno = 5 AND jikwonno = 7; -- 에러 발생
SELECT * FROM jikwon WHERE jikwonjik = '사원' AND jikwongen = '여' AND jikwonpay <= 3000;
SELECT * FROM jikwon WHERE jikwonjik = '사원' AND (jikwongen = '여' OR jikwonibsail >= '2017-01-01');

SELECT * FROM jikwon WHERE jikwonno >= 5 AND jikwonno <= 10;
SELECT * FROM jikwon WHERE jikwonno BETWEEN 5 AND 10;
SELECT * FROM jikwon WHERE jikwonibsail BETWEEN '2015-01-01' AND '2017-12-31';

SELECT * FROM jikwon WHERE jikwonno < 5 OR jikwonno > 20;
SELECT * FROM jikwon WHERE jikwonno not BETWEEN 5 AND 20;		-- 'not'을 통해서 연산자를 부정할 수 있음 --> 연산 속도가 떨어짐
-- 위의 두개 명령이 똑같은 의미 / 하지만 긍정적 형태의 조건이 연산 속도를 향상시킴.

SELECT * FROM jikwon WHERE jikwonpay > 5000;
SELECT * FROM jikwon WHERE jikwonpay > 3000 + 2000;		-- 산술 연산자의 우선선위가 관계연산자 보다 빠르기 때문에, 위와 동일한 결과
SELECT * FROM jikwon WHERE jikwonname >= '박';		-- '박' 이라는 문자도 숫자로 표현됨.
SELECT ASCII('a'), ASCII('A'), ASCII('가'), ASCII('나') FROM DUAL;		-- FROM DUAL : DB서버에서 불러오지 않고 , 가상 table을만듦
SELECT * FROM jikwon WHERE jikwonname BETWEEN '김'AND '이';

-- in 멤버 조건 연산
SELECT * FROM jikwon WHERE jikwonjik='대리' OR jikwonjik='과장' OR jikwonjik='부장';
SELECT * FROM jikwon WHERE jikwonjik IN('대리', '과장', '부장');
-- OR 연산자가 연속적으로 나오는 경우, IN 연산자 활용
SELECT * FROM jikwon WHERE jikwonno IN(3, 12, 29);

-- like 조건 연산 : %(0개 이상의 문자열), _(한개 문자)
SELECT * FROM jikwon WHERE jikwonname LIKE '이%';		-- '이'로 시작하는 jikwonname SELECT ->  '이' 뒤에 0개 이상 문자가 오는 항목 SELECT
SELECT * FROM jikwon WHERE jikwonname LIKE '이순%';
SELECT * FROM jikwon WHERE jikwonname LIKE '%라';
SELECT * FROM jikwon WHERE jikwonname LIKE '이%라';		-- 첫번째 글자가 '이'이고, 마지막 글자가 '라'인 글자 전부 --> 가운데 글자는 0개 이상--> 4, 5, 6 ... 글자 모두 출력
SELECT * FROM jikwon WHERE jikwonname LIKE '이__';
SELECT * FROM jikwon WHERE jikwonname LIKE '이_라';		-- _ 한 개당 한 글자 --> '이'로 시작하고, '라'로 끝나는 총 세글자 이름만  SELECT
SELECT * FROM jikwon WHERE jikwonname LIKE '__';		-- 두글자 이름만 SELECT
SELECT * FROM jikwon WHERE jikwonpay LIKE '3___';		-- 연봉 3,000 대 data만 SELECT
SELECT * FROM jikwon WHERE jikwonpay LIKE '3%';		-- 연봉의 제일 앞자리수가 3으로 시작하는 data SELECT
SELECT * FROM gogek;
SELECT * FROM gogek WHERE gogekjumin LIKE '_____1%';		-- 8째자리수가 1인 data SELECT
SELECT * FROM gogek WHERE gogekjumin LIKE '%-1%';		-- '-1'을 갖는 모든 data SELECT

-- NULL, IS NULL
SELECT * FROM jikwon;
UPDATE jikwon SET jikwonjik = NULL WHERE jikwonno = 5;
SELECT * FROM jikwon;
SELECT * FROM jikwon WHERE jikwonjik = NULL;		-- 아무 값도 출력 X
SELECT * FROM jikwon WHERE jikwonjik = IS NULL;		-- NULL 값을 확인하고 싶으면, 'IS NULL' 연산자를 사용해야됨.

-- LIMIT
# LIMIT(시작행, 갯수)
SELECT * FROM jikwon LIMIT 3;
SELECT * FROM jikwon ORDER BY jikwonno DESC LIMIT 3;		-- 'LIMIT' : 마지막 ""개 자료만 SELECT
SELECT * FROM jikwon LIMIT 5, 3;		--  6행 부터 3개 행 SEELCT

SELECT jikwonno AS 직원번호, jikwonname AS 직원명, jikwonjik AS 직급, jikwonpay AS 연봉, jikwonpay / 12 AS 보너스, jikwonibsail AS 입사일 FROM jikwon
WHERE jikwonjik IN('과장', '부장', '사원')
AND jikwonpay >= 4000 AND jikwonibsail BETWEEN '2015-01-01' AND '2019-12-31'
ORDER BY jikwonjik, jikwonpay DESC LIMIT 3;

# ************************************************************************************************************************************
# ************************************************************************************************************************************

-- 내장함수 : 데이터 조작의 효율성 증진이 목적
-- 단일 행 함수 : 각 행에 대해 작없한다. 행 단위 처리

-- ================================== 문자 함수  ================================== 
-- LOWER : 소문자, UPPER : 대문자
SELECT LOWER('hello'), UPPER('hello') FROM DUAL;

-- SUBSTR('문자열', 시작 할 자리 수, SELECT할 문자 개수') : 문자열 중에 선택
SELECT SUBSTR('hello world', 3), SUBSTR('hello world', 3, 3), SUBSTR('hello world', -3, 3) FROM DUAL;

-- LENGTH : 문자열 길이, INSTR('문자열', '찾을 문자')
SELECT LENGTH('hello world'), INSTR('hello world', 'e') FROM DUAL;

-- RELACE('문자열', '기존 문자', '치환 할 문자') : 문자열 치환
SELECT REPLACE('010.111.1234', '.', '-') FROM DUAL;


-- 예시)  jikwon 테이블에서 이름에 '이'가 포함된 직원이 있으면 '이'부터 두글자 출력하기
SELECT jikwonname, SUBSTR(jikwonname, INSTR(jikwonname, '이'),2) 
FROM jikwon WHERE jikwonname LIKE '%이%';
-- --> 서버에서 함수를 이용해서 위와같이 작업을 할 경우, 부하를 줌. --> 데이터를 가져와서 python에서 작업할 지 선택!!


-- ================================== 숫자 함수  ==================================
-- ROUND(숫자, 반올림 할 자리수)
SELECT ROUND(45.678, 2), ROUND(45.678), ROUND(45.678, 0), ROUND(45.678, -1) FROM DUAL;
SELECT jikwonname, jikwonpay, jikwonpay * 0.25 AS tax, ROUND(jikwonpay * 0.25, 0) FROM jikwon;

-- TRUNCATE(숫자, 버릴 자리수)
SELECT TRUNCATE(45.678, 0), TRUNCATE(45.678, 1), TRUNCATE(45.678, -1) FROM DUAL;

-- MOD(숫자, 나눌 수)
SELECT MOD(15, 2), 15 / 2 FROM DUAL;

-- GREATEST(숫자열) : 가장 큰 수
-- LEAST(숫자열) : 가장 작은 수
SELECT GREATEST(23, 25, 5, 1, 12), LEAST(23, 25, 5, 1, 12) FROM DUAL;


-- ================================== 날짜 함수  ==================================
-- NOW() : 지금의 년-월-일 시-분-초
-- SYSDATE() : 시스템이 갖고있는 년-월-일 시-분-초
-- CURDATE() : 지금의 년-월-일
SELECT NOW(), NOW() + 2, SYSDATE(), CURDATE() FROM DUAL;

-- SLEEP(얼마나 기다렸다가 명령을 수행할지)
SELECT NOW(), SLEEP(3), NOW() FROM DUAL;				-- 하나의 query 내에서는 동일 값 출력		-- 2026-02-12 13:00:38 / 2026-02-12 13:00:38
SELECT SYSDATE(), SLEEP(3), SYSDATE() FROM DUAL;	-- 실행 시점 값 출력								-- 2026-02-12 13:01:10 / 2026-02-12 13:01:13

-- ADDDATE('년-월-일', 추가할 일 수)
-- SUBDATE('년-월-일', 뺄 일 수)
SELECT ADDDATE('2020-08-01',3), ADDDATE('2020-08-01',-3), SUBDATE('2020-08-01', 3) FROM DUAL;

-- DATE_ADD('DATE 정보', INTERVAL '숫자' MINUTE/DAY/MONTH/YEAR) : 'DATE 정보'에 더할 값
SELECT DATE_ADD(NOW(), INTERVAL 1 MINUTE),
 DATE_ADD(NOW(), INTERVAL 5 DAY), 
 DATE_ADD(NOW(), INTERVAL 5 MONTH) FROM DUAL;

-- DATEDIFF('DATE 정보', '비교 할 DATE 정보')  
SELECT DATEDIFF(NOW(), '2025-05-05') FROM DUAL;


-- ================================== 형변환  함수  ==================================
-- DATE_FORMAT
SELECT NOW(), DATE_FORMAT(NOW(), '%Y%m%d'), DATE_FORMAT(NOW(), '%Y년%m월%d일') FROM DUAL;
SELECT jikwonname, jikwonibsail, DATE_FORMAT(jikwonibsail, '%Y') FROM jikwon WHERE busernum=10;

-- STR_TO_DATE
SELECT STR_TO_DATE('2026-02-12', '%Y-%m-%d') FROM DUAL;
SELECT STR_TO_DATE('2026-02-12 13:16:34', '%Y-%m-%d %H:%i:%S') FROM DUAL;



-- ================================== 기타  함수  ==================================
-- RANK() : 순위 결정
SELECT jikwonno, jikwonname, jikwonpay,
 RANK() OVER (ORDER BY jikwonpay) AS result1,				-- 동점자가 발생하면, 카운트 해서 그 다음 순위 카운트
 RANK() OVER (ORDER BY jikwonpay ASC) AS result2,
 RANK() OVER (ORDER BY jikwonpay DESC) AS result3,
 dense_RANK() OVER (ORDER BY jikwonpay) AS result4		-- 동점자가 발생하더라도, 계속 이어서 카운트
  FROM jikwon;

-- nvl(value1, value2) : value1이 'NULL'값이면, value2를 취함.
SELECT jikwonname, jikwonjik, nvl(jikwonjik, '임시직') FROM jikwon;

-- nvl2(value1, value2, value3) : value1이 'NULL'값이 아니라면, value2 값을 취하고, 'NULL'값이면, value3을 취함.
SELECT jikwonname, jikwonjik, nvl2(jikwonjik, '정규직', '임시직') FROM jikwon;

-- NULLIF(value1, value2) : 두 개의 값이 일치하면 NULL, 아니면 value1을 취함.
SELECT jikwonname, jikwonjik, NULLIF(jikwonjik, '대리') FROM jikwon;



# ************************************************************************************************************************************
# ************************************************************************************************************************************

-- 조건 표현식
-- ================================== case ================================== 
-- 형식 1)
-- case 표현식 when 비교값 1 then 결과값 1 when 비교값 2 then 결과값 2 ... [else 결과값 n] end as 별명
SELECT case 10 / 5
 when 5 then '안녕' 
 when 2 then '반가워' 
 ELSE '잘가' 
 END
  AS 결과 FROM DUAL;

SELECT jikwonname, jikwonpay, jikwonjik, 
case jikwonjik
when '이사' then jikwonpay * 0.05
when '부장' then jikwonpay * 0.04
when '과장' then jikwonpay * 0.03
ELSE jikwonpay * 0.02 END 
as donation FROM jikwon

-- 형식 2)
-- case when 조건1 then 결과값1 when 조건2 then 결과값2 ... [else 결과값 n] end as 별명
SELECT jikwonname, case when jikwongen='남' then '남성' when jikwongen='여' then '여성' END AS gender FROM jikwon;

SELECT jikwonname, jikwonpay,
case
when jikwonpay >= 7000 then '우수 연봉'
when jikwonpay >= 5000 then '보통 연봉'
ELSE '저조'
END
AS reslut , jikwongen FROM jikwon WHERE jikwonjik IN ('대리', '과장');


-- ================================== if ================================== 
-- if(조건) 참값, 거짓값 as 별명
SELECT jikwonname, TRUNCATE(jikwonpay/1000 ,0) >= 5, 'good', 'normal' FROM jikwon;

SELECT jikwonname, jikwonpay, jikwonjik,
if (TRUNCATE(jikwonpay/1000, 0) >= 5, 'good', 'normal') AS result FROM jikwon;



