# ************************************************************************************************************************************
# ************************************************************************************************************************************
CREATE TABLE dept(NO INT PRIMARY KEY, NAME VARCHAR(10), tel VARCHAR(15), inwon INT, addr TEXT)CHARSET=UTF8;		-- 테이블 생성

-- ================================ 자료 추가 ================================--
# insert into 테이블명(collum명, ...NO) values(입력자료, ...)
INSERT INTO dept(NO, NAME, tel, inwon, addr) VALUES(1, '인사과', '111-1111', 3, '삼성동12');
INSERT INTO dept VALUES(2, '영업과', '222-2222', 5, '서초동12');
INSERT INTO dept(NO,NAME) VALUES(3,'자재과');
INSERT INTO dept(NO, addr, tel, NAME) VALUES(4,'역삼2동33','111-5555', '자재2과');

-- 에러 케이스 --
INSERT INTO dept VALUES(5,'판매과');	-- 입력자료와 collum 개수 불일치
INSERT INTO dept(NAME, tel) VALUES('판매2과','111-6666');		-- NO(Primary Key) --> 생략 불가
INSERT INTO dept (NO, NAME) VALUES(5,'판매과부서는 사람들이 좋아 일하기 좋은 우수한 부서임');		-- name collum에 10자리로 정의해놨는데, 너무 긺

SELECT * FROM dept;


-- ================================ 자료 수정  ================================--
# update 테이블명 set 수정collum 명 = 수정값, ... where 조건 <<<--- 수정 대상 collum을 지정
-- PK(Primary Key) collum의 자료는 수정 대상에서 제외
SELECT * FROM dept WHERE NO = 1;

UPDATE dept SET tel='123-4567' WHERE NO = 2;
UPDATE dept SET addr='압구정33', inwon=7, tel='777-8888' WHERE NO = 3;

SELECT * FROM dept;


-- ================================ 자료 삭제  ================================--
# delete from 테이블명 where 조건		-- 전체 또는 부분적 레코드 삭제 가능
# truncate table 테이블명	--  where  조건을  사용 x , 전체 레코드 삭제 가능 
DELETE FROM dept WHERE NAME='자재2과';
TRUNCATE TABLE dept;
SELECT * FROM dept;

DROP TABLE dept;		-- table 자체(구조, 자료)가 제거됨


# ************************************************************************************************************************************
# ************************************************************************************************************************************
-- =========================== 무결성 제약 조건 ==============================--
-- 테이블 생성 시, 잘못된 자료 입력을 막고자 다양한 입력 제한 조건을 줄 수 있음

-- 1) 기본키 제약 : Primary Key(PK) 사용, 중복 레코드 입력 방지
CREATE TABLE aa(bun INT PRIMARY KEY, irum CHAR(10));		-- bun : Not null, unique
SELECT * FROM information_schema.table_constraints WHERE TABLE_NAME='aa';
INSERT INTO aa VALUES(1, 'tom');
INSERT INTO aa VALUES(2, 'tom');
INSERT INTO aa(bun) VALUES('3');

-- 에러 케이스 --
INSERT INTO aa VALUES(2, 'tom');		-- 이미 PK 중, 2에 값이 할당되어있는 상태이므로, 다시 값을 주면 에러 발생
INSERT INTO aa(irum) VALUES('tom');	-- PK값으로 선언한 bun 값을 주지 않았기 때문에, insert 시, 에러 발생

SELECT * FROM aa;

DROP TABLE aa;

CREATE TABLE aa(bun INT, irum CHAR(10), CONSTRAINT aa_bun_pk PRIMARY KEY(bun));		-- constraint의 이름 'aa_bun_pk'를 명시적으로 부여할 경우
INSERT INTO aa VALUES(1, 'tom');
SELECT * FROM aa;

DROP TABLE aa;


-- 2) check 제약 : 입력 자료의 특정 collum값 조건 검사
CREATE TABLE aa(bun INT, nai INT CHECK(nai >= 20));
INSERT INTO aa VALUES(1, 23);

-- 에러 케이스 --
INSERT INTO aa VALUES(2, 13);		-- check 제약조건에 의해서, nai의 입력 조건을 20살 이상을 제한했기 때문에 err

SELECT * FROM aa;
DROP TABLE aa;


-- 3) unique 제약 : 특정 collum값 중복 불허
CREATE TABLE aa(bun INT, irum CHAR(10) NOT NULL UNIQUE);
INSERT INTO aa VALUES(1, 'tom')
INSERT INTO aa VALUES(2, 'john')

-- 에러 케이스 --
INSERT INTO aa VALUES(3, 'john')		-- unique 제약조건에 의해서, 'john'을 중복으로 적으면 err

SELECT * FROM aa;
DROP TABLE aa;


-- 4) foreign ky(fk), 외부키, 참조키  제약 : 특정 collum이 다른 table의 collum을 참조
-- fk 대상은 pk다!!! --> table을 정규화 작업을 할 때, PK가 존재하지 않는 새로운 table을 만들 때, 이 곳에도 Unique한 collum이 있어야되는데, 이를 forign key 라고 한다.
-- fk의 type은 pk 랑 동일
CREATE TABLE jikwon(bun INT PRIMARY KEY, irum VARCHAR(10) NOT NULL, buser CHAR(10) NOT NULL);
INSERT INTO jikwon VALUES(1, '한송이', '인사과');
INSERT INTO jikwon VALUES(2, '이기자', '인사과');
INSERT INTO jikwon VALUES(3, '한송이', '판매과');
SELECT * FROM jikwon;

CREATE TABLE gajok(CODE INT PRIMARY KEY, NAME VARCHAR(10) NOT NULL, birth DATETIME, jikwonbun INT, FOREIGN KEY(jikwonbun) REFERENCES jikwon(bun));
INSERT INTO gajok VALUES(10, '한가해', '2015-05-12', 3)
INSERT INTO gajok VALUES(20, '공기밥', '2011-12-12', 2)
INSERT INTO gajok VALUES(30, '심심해', '2010-05-12', 3)
SELECT * FROM gajok;

DELETE FROM jikwon WHERE bun=1;
SELECT * FROM jikwon;

-- 에러 케이스 --
INSERT INTO gajok VALUES(30, '김밥', '2013-12-12', 5)		-- ㅇ참조하는 PK의  index 중에서 5번 X
DELETE FROM jikwon WHERE bun=2;		-- gajok table에서 FK로 참조한 jikwon table의 PK bun = 2, 3 번은 삭제 불가
DROP TABLE jikwon;						-- 마찬가지로 jikwon table 자체 삭제 불가

-- bun=2 가족을 지우려고함
DELETE FROM gajok WHERE jikwonbun=2;		-- jikwon table 중, bun=2인 행을 삭제하기 위해서, gajok table에서 FK로 참조했던 jikwonbun=2 삭제
DELETE FROM jikwon WHERE bun=2;
SELECT * FROM jikwon;
SELECT * FROM gajok;

-- 참고 --
-- CREATE TABLE gajok(CODE INT PRIMARY KEY, ...) on delete cascade
-- jikwon table 중에서 자료를 삭제하면, 관련있는 gajok table 에서 관련 자료도 함께 삭제

DROP TABLE gajok;
DROP TABLE jikwon;


-- 5) default : 특정 collum에 초기치 부여. null 예방 (제약조건은 X)
CREATE TABLE aa(bun INT AUTO_INCREMENT PRIMARY KEY, juso CHAR(20) DEFAULT '강남구 역삼동');		-- bun INT AUTO_INCREMENT : bun 에서 숫자(int)는 자동으로 증가
INSERT INTO aa VALUES(1, '서초구 서초2동');
INSERT INTO aa(juso) VALUES('서초구 서초3동');		-- AUTO_INCREMENT 에 의해서, bun에는 자료를 입력한 순서대로 int 자동 증가 입력
INSERT INTO aa(juso) VALUES('서초구 서초4동');
INSERT INTO aa(bun) VALUES(5);		-- '강남구 역삼동'을 default에 의해서 초기값으로 지정했기 때문.
INSERT INTO aa(bun) VALUES(6);

SELECT * FROM aa;
DROP TABLE aa;


# ************************************************************************************************************************************
# ************************************************************************************************************************************

CREATE TABLE professor(prof_code INT PRIMARY KEY ,
prof_name VARCHAR(10), class_num INT CHECK(100 <= class_num AND class_num <= 500));
SELECT * FROM professor;


CREATE TABLE subject(sub_code INT PRIMARY KEY AUTO_INCREMENT, sub_name VARCHAR(10) UNIQUE,
book_name VARCHAR(10), main_prof INT, FOREIGN KEY(main_prof) REFERENCES professor(prof_code));
SELECT * FROM subject;

CREATE TABLE student(stu_num INT PRIMARY KEY, stu_name VARCHAR(10), listening_class INT,
 FOREIGN KEY(listening_class) REFERENCES SUBJECT(sub_code), grade_num INT DEFAULT 1 check(1 <= grade_num AND grade_num <= 4))
SELECT * FROM student;

INSERT INTO professor(prof_code, class_num) VALUES(1, 101);
INSERT INTO professor(prof_code, class_num) VALUES(3, 120);

INSERT INTO subject(book_name) VALUES('유체역학');
INSERT INTO subject(book_name) VALUES('고체역학');

INSERT INTO student(stu_num, stu_name, grade_num) VALUES(2, 'KIM', 2);
INSERT INTO student(stu_num, stu_name, grade_num) VALUES(6, 'HAN', 5);

DROP TABLE professor;
DROP TABLE subject;
DROP TABLE student;


# ************************************************************************************************************************************
# ************************************************************************************************************************************

-- index (색인) : 검색 속도 향상을 우해 특정 column에 색인 부여 가능 --
-- PK column 은 자동으로 인덱싱됨(ascending sort : 오름차순 정렬)
-- index를 자제해야 하는 경우 : 입력, 수정, 삭제 등의 작업이 빈번한 경우

CREATE TABLE aa(bun INT PRIMARY KEY, irum VARCHAR(10) NOT NULL, juso VARCHAR(50));
INSERT INTO aa VALUES(1, '신선해', '테헤란로 111');
ALTER TABLE aa ADD INDEX ind_juso(juso);				-- juso column에 index를 부여함

SELECT * FROM aa;
EXPLAIN SELECT * FROM aa;
DESC aa;
SHOW INDEX from aa;

ALTER TABLE aa DROP INDEX ind_juso;
DROP TABLE aa;


# ************************************************************************************************************************************
# ************************************************************************************************************************************

-- 테이블 관련 주요 명령 --
# CREATE table 테이블명(...)
# ALTER table 테이블명(...)
# DROP table 테이블명(...)
CREATE TABLE aa(bun INT, irum VARCHAR(10), juso VARCHAR(50));
INSERT INTO aa VALUES(1, 'tom', 'seoul');

SELECT * FROM aa;

ALTER TABLE aa RENAME kbs;		-- table의 이름을 'aa'에서 'kbs'로 변경
SELECT * FROM aa;
ALTER TABLE kbs RENAME aa;


-- column 관련 명령 --
ALTER TABLE aa ADD (job_id INT DEFAULT 10);		-- column 추가
SELECT * FROM aa;
ALTER TABLE aa CHANGE job_id job_num INT;			-- column 수정 (이름이나 type 변경 가능)
ALTER TABLE aa MODIFY job_num VARCHAR(10);
DESC aa;			-- Describe - table의 각 항목 type을 알려줌

ALTER TABLE aa DROP COLUMN job_num;					-- column 삭제
DESC aa;

DROP TABLE aa;
	



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


create table jikwon(
jikwonno int primary key,
jikwonname varchar(10) not null,
busernum int not null,
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


create table gogek(
gogekno int primary key,
gogekname varchar(10) not null,
gogektel varchar(20),
gogekjumin char(14),
gogekdamsano int,
CONSTRAINT FK_gogekdamsano foreign key(gogekdamsano) references jikwon(jikwonno));

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













