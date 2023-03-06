-- 테이블의 색인 정보를 확인
show index from dept_emp;

-- 테이블과 관련된 정보를 조회
show table status like 'dept_emp';

-- 'dept_emp' 
alter table dept_emp drop foreign key dept_emp_ibfk_1;
alter table dept_emp drop foreign key dept_emp_ibfk_2;
drop index dept_no on dept_emp;

-- 테이블을 다시 분석해서 관련 정보를 업데이트하고 테이블의 색인 정보를 확인

-- 테이블의 기본키 정보까지 삭제
alter table `dept_emp` drop primary key;

-- 테이블에서 첫 번째 행의 데이터를 조회
select * from dept_emp order by emp_no asc limit 1;

-- 테이블에서 마지막 행의 데이터를 조회
select * from dept_emp order by emp_no desc limit 1;

-- 첫 번째 행과 마지막 행의 실행 계획의 결과? Full scan
select count(*) from dept_emp;
explain select * from dept_emp where emp_no = 10001;
explain select * from dept_emp where emp_no = 499999;

-- 모두 삭제한 색인 중 기본키를 다시 설정
alter table dept_emp add primary key (emp_no, dept_no);


-- 색인을 이용하여 데이터를 조회하면 조회하려는 데이터만 읽고 비교하여 결과를 반환하기 때문에 데이터를 조회하는 시간이 최소화된다. 이것이 색인 index를 사용하는 목적이다.

-- 색인이 설정되지 않은 'dept_no' 열을 사용하여 데이터를 조회하는 쿼리
select count(*) from dept_emp where dept_no = 'd006';
explain select * from dept_emp where dept_no = 'd006';

create index dept_emp on dept_emp(dept_no);
explain select * from dept_emp where dept_no = 'd006';

-- 하나의 테이블에 많은 색인을 생성하면 insert, update 및 delete 하는 시간이 많이 소요되기 때문에 검색 조건과 색인 생성을 조화롭게 해야한다. 

select * from dept_emp where dept_no = 'd006' and from_date = '1996-11-24';
explain select * from dept_emp where dept_no = 'd006' and from_date = '1996-11-24';

create index from_date on dept_emp(from_date);
explain select * from dept_emp where dept_no = 'd006' and from_date = '1996-11-24';

explain select a.emp_no, b.first_name, b.last_name
from dept_emp a inner join employees b
on a.emp_no = b.emp_no; 


delimiter // 
CREATE PROCEDURE InsertBook(
	IN myBookID INTEGER, 
    IN myBookName VARCHAR(40), 
	IN myPublisher VARCHAR(40), 
	IN myPrice INTEGER
) 
BEGIN INSERT INTO Book(bookid, bookname, publisher, price) 
VALUES(myBookID, myBookName, myPublisher, myPrice); 
END; // delimiter ;

/* 프로시저 InsertBook을 테스트하는 부분 */ 
CALL InsertBook(13, '스포츠과학', '마당과학서적', 25000); 
SELECT * FROM Book;


delimiter // 
CREATE PROCEDURE BookInsertOrUpdate( 
	myBookID INTEGER,
    myBookName VARCHAR(40), 
    myPublisher VARCHAR(40), 
    myPrice INT
)
BEGIN DECLARE mycount INTEGER; 
SELECT count(*) INTO mycount 
FROM Book 
WHERE bookname LIKE myBookName; 
IF mycount!=0 THEN SET SQL_SAFE_UPDATES=0; 
/* DELETE, UPDATE 연산에 필요한 설정 문 */ 
UPDATE Book SET price = myPrice 
WHERE bookname LIKE myBookName; 
ELSE INSERT INTO Book(bookid, bookname, publisher, price) 
VALUES(myBookID, myBookName, myPublisher, myPrice); 
END IF; END; // delimiter ;

-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 25000); 
SELECT * FROM Book; 
-- 15번 투플 삽입 결과 확인 
-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분
 CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 20000); 
 SELECT * FROM Book; -- 15번 투플 가격 변경 확인
 
 delimiter // 
 create procedure 새학과(
	in 새학과번호 char(2),
    in 새학과명 char(20),
    in 새전화번호 char(20)
)
begin insert into 학과(학과번호, 학과명, 전화번호)
values(새학과번호, 새학과명, 새전화번호);
end; // delimiter ;

/* 프로시저 InsertBook을 테스트하는 부분 */ 
CALL 새학과('08', '컴퓨터보안학과', '022-200-7000'); 
SELECT * FROM 학과;