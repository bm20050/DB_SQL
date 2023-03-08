-- 상품 테이블 작성
CREATE TABLE 상품 (상품코드 VARCHAR(6) NOT NULL PRIMARY KEY, 상품명 VARCHAR(30)  NOT NULL, 제조사 VARCHAR(30) NOT NULL, 소비자가격  INT, 재고수량  INT DEFAULT 0);

-- 입고 테이블 작성
CREATE TABLE 입고 (입고번호 INT PRIMARY KEY, 상품코드 VARCHAR(6) NOT NULL REFERENCES 상품(상품코드), 입고일자 DATE,입고수량 INT,입고단가 INT);

-- 판매 테이블 작성
CREATE TABLE 판매 (판매번호 INT  PRIMARY KEY,상품코드  VARCHAR(6) NOT NULL REFERENCES 상품(상품코드), 판매일자 DATE,판매수량 INT,판매단가 INT);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES ('EEEEEE', '프린터', '삼싱', 200000);


-- [입고] 테이블에 상품이 입고가 되면 [상품] 테이블에 상품의 재고수량이 수정되는 트리거
delimiter //
create trigger AfterInsert입고
after insert on 입고 for each row
begin
	update 상품 
    set 재고수량 = 재고수량 + NEW.입고수량 
    where 상품코드 = NEW.상품코드; 
end; // delimiter ;

INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가) VALUES (1, 'AAAAAA', '2004-10-10', 5, 50000);


-- [입고] 테이블에 수량이 수정되면 [상품] 테이블에 상품의 재고수량이 수정되는 트리거
delimiter //
create trigger AfterUpdate입고
after update on 입고 for each row
begin 
	update 상품
    set 재고수량 = 재고수량 - OLD.입고수량 + NEW.입고수량
    where 상품코드 = NEW.상품코드;
end; // delimiter ;

UPDATE 입고 SET 입고수량 = 30 where 입고번호 = 1;


-- [입고] 테이블에서 삭제(취소)하면 [상품]테이블에서 재고수량을 수정하는 트리거
delimiter //
create trigger AfterDelete입고
after delete on 입고 for each row
begin
	update 상품
    set 재고수량 = 재고수량 - old.입고수량
    where 상품코드 = old.상품코드;
end; // delimiter ;



-- [판매] 테이블에 자료가 변경 되면 [상품] 테이블에 상품의 재고수량이 변경되는 트리거
-- delimiter //
-- create trigger BeforeUpdate판매
-- before update on 판매 for each row
-- begin
-- 	update 상품
--     set 재고수량 = 재고수량 
-- end;



-- 트랜잭션
commit;
rollback;

select @@autocommit;

set autocommit = 1;

create table book1 ( select * from book );
create table book2 ( select * from book );

drop table book1;

delete from Book1;
delete from Book2;
rollback;

start transaction;
delete from Book1;
delete from Book2;
rollback;

start transaction;
savepoint A;
delete from Book1;
savepoint B;
delete from Book2;
rollback to savepoint B;
rollback to savepoint A;
commit;


create table account (
	accNum char(10) primary key,
    amount int not null default 0
);

drop table account;

insert into account values('A', 45000);
insert into account values('B', 100000);

update account set amount = amount - 40000 where accNum = 'A';
update account set amount = amount + 40000 where accNum = 'B';


delimiter //
create procedure `account_transaction` (
	in sender char(15),
    in recip char(15),
    in iamount int
)
begin 
	declare exit handler for sqlexception rollback;
	start transaction;
    update account set amount = amount - iamount where accNum = sender;
	update account set amount = amount + iamount where accNum = recip;
    commit;
end; // delimiter ;

drop procedure account_transaction;

delimiter //
create trigger `account_BEFORE_UPDATE`
before update on `account` for each row 
begin
	if (new.amount < 0) 
    then signal sqlstate '45000';
    end if;
end; // delimiter ;