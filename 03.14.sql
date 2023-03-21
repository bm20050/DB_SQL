use db0220;


drop procedure if exists InsertCustomer;
delimiter //
create procedure InsertCustomer (
	in _custid int,
    in _name varchar(40),
    in _address varchar(50),
    in _phone varchar(20)
)
begin 
	insert into customer(custid, name, address, phone)
    values (_custid, _name, _address, _phone);
end;
// delimiter ;


Drop procedure if exists BookInsertOrUpdate;
delimiter //
CREATE PROCEDURE BookInsertOrUpdate(
	 myBookID INTEGER,
	 myBookName VARCHAR(40),
	 myPublisher VARCHAR(40),
	 myPrice INT
)
BEGIN
	 DECLARE mycount INTEGER;
	 SELECT count(*) INTO mycount FROM Book
	 WHERE bookname LIKE myBookName;
	 IF mycount!=0 THEN
	 SET SQL_SAFE_UPDATES=0; /* DELETE, UPDATE 연산에 필요한 설정 문 */
	 UPDATE Book SET price = myPrice
	 WHERE bookname LIKE myBookName;
	 ELSE
	 INSERT INTO Book(bookid, bookname, publisher, price)
	 VALUES(myBookID, myBookName, myPublisher, myPrice);
	 END IF;
END;
//
delimiter ; 


-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 25000);
SELECT * FROM Book; -- 15번 투플 삽입 결과 확인
-- BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분
CALL BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 20000);
SELECT * FROM Book; -- 15번 투플 가격 변경 확인


drop procedure if exists db0220.cursor_pro3;

delimiter $$
create procedure cursor_pro3 ()
begin 
	declare myname varchar(40);
    declare myprice int;
    declare endofrow boolean default false;
    declare bookcursor cursor for select bookname, price from book where publisher = '이상미디어';
    declare continue handler for not found set endofrow=true;
    open bookcursor;
    cursor_loop: loop
		fetch bookcursor into  myname, myprice;
        if endofrow then leave cursor_loop;
        end if;
        select myname, myprice;
	end loop cursor_loop;
    close bookcursor;
end $$ 
delimiter ;

call cursor_pro3;


drop procedure if exists db0220.pro4;
delimiter //
create procedure pro4()
begin
	declare mypublisher varchar(40);
    declare totalprice int;
    declare endofrow boolean default false;
    declare pcursor cursor for select publisher, sum(saleprice) from book, orders where book.bookid = orders.bookid group by publisher;
    declare continue handler for not found set endofrow=true;
    open pcursor;
    cursor_loop: loop 
		fetch pcursor into mypublisher, totalprice;
        if endofrow then leave cursor_loop;
        end if;
        select mypublisher, totalprice;
	end loop cursor_loop;
    close pcursor;
end //
delimiter ;

call pro4;


drop procedure if exists db0220.pro5;
delimiter //
create procedure pro5()
begin
	declare _bookname varchar(40);
    declare endofrow boolean default false;
    declare ncursor cursor for 
		select b1.bookname 
        from book b1 
        where b1.price > (select avg(b2.price)
						  from book b2
                          where b2.publisher = b1.publisher);
	declare continue handler for not found set endofrow=true;
	open ncursor;
    cursor_loop: loop
		fetch ncursor into _bookname;
        if endofrow then leave cursor_loop;
        end if;
        select _bookname;
	end loop cursor_loop;
    close ncursor;
end //
delimiter ;

call pro5;

drop procedure if exists db0220.pro6;
delimiter //
create procedure pro6()
begin
	declare _custid varchar(40);
    declare endofrow boolean default false;
    declare ncursor cursor for 
		select custid, count(*) as 구매권수, sum(saleprice)
        from orders
        group by custid;
	declare continue handler for not found set endofrow=true;
	open ncursor;
    cursor_loop: loop
		fetch ncursor into _bookname;
        if endofrow then leave cursor_loop;
        end if;
        select _bookname;
	end loop cursor_loop;
    close ncursor;
end //
delimiter ;

call pro6;

-- (7) 주문이 있는 고객의 이름과 주문 총액을 출력하고, 주문이 없는 고객은 이름만 출력하는 프로시저를 작성하시오.

drop procedure if exists db0220.pro7;
delimiter //
create procedure pro7()
begin
	declare done boolean default false;
    declare v_sum int;
    declare v_id int;
    declare v_name varchar(20);
    -- select한 결과를 cursor1로 정의
    declare cursor1 cursor for select custid, name from customer;
    declare continue handler for not found set done = true;
    open cursor1;
    my_loop: loop
    -- loop하며 cursor1의 데이터를 불러와 변수에 넣는다.
    fetch cursor1 into v_id, v_name;
		select sum(saleprice) into v_sum from orders where custid = v_id;
        if done then leave my_loop;
        end if;
        select v_name, v_sum;
	end loop my_loop;
	close cursor1;
end; //
delimiter ;

call pro7;

book
SET GLOBAL log_bin_trust_function_creators = 1;  -- ON

delimiter // 
CREATE FUNCTION fnc_Interest(
Price INTEGER) RETURNS INT
BEGIN 
DECLARE myInterest INTEGER; 
IF Price >= 30000 THEN SET myInterest = Price * 0.1; 
ELSE SET myInterest := Price * 0.05; 
END IF; 
RETURN myInterest; 
END; // 
delimiter ;


/* Orders 테이블에서 각 주문에 대한 이익을 출력 */ 
SELECT custid, orderid, saleprice, fnc_Interest(saleprice) interest 
FROM Orders;


-- (8) 고객의 주문 총액을 계산하여 20,000원 이상이면 '우수', 20,000원 미만이면 '보통'을 반환하는 함수 Grade()를 작성하시오. 
-- Grade()를 호출하여 고객의 이름과 등급을 보이는 SQL 문도 작성하시오.
drop function if exists Grade;
delimiter //
create function Grade(
total int) returns varchar(20)
begin
declare grd varchar(20);
if total >= 20000 then set grd := '우수';
else set grd := '보통';
end if;
return grd;
end; //
delimiter ;

select name, customer.custid, sum(saleprice), Grade(sum(saleprice)) as grade
from orders, customer
where orders.custid = customer.custid
group by customer.custid;


delimiter //
create function Grade(cid int) 
returns varchar(10)
begin
	declare total int;
    select sum(saleprice) into total from orders where custid = cid;
    if total >= 20000 then
		return '우수';
	else
		return '보통';
	end if;
end; //
delimiter ;


