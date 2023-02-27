alter table j drop primary key;

show index from orders;

select abs(-78), abs(78);

select round(4.872, 1);

select  custid '고객번호', round(sum(saleprice) / count(*), -2) '평균금액'
from orders
group by custid;

select bookid, replace(bookname, '야구', '농구') bookname, publisher, price
from book;

select bookname '제목', char_length(bookname) '문자수', length(bookname) '바이트수'
from book
where publisher='굿스포츠';

select substr(name, 1, 1) '성', count(*) '인원'
from customer
group by substr(name, 1, 1);

select orderid '주문번호', orderdate '주문일',
	adddate(orderdate, interval 10 day) ' 확정'
from orders;

select orderid '주문번호', str_to_date(orderdate, '%Y-%m-%d') '주문일', custid '고객번호', bookid '도서번호'
from orders
where orderdate = date_format('20140707', '%Y%m%d');

select sysdate(), date_format(sysdate(), '%Y/%m/%d %M %h:%s') 'sysdate_1';

select name '이름', ifnull(phone, '연락처없음') '전화번호'
from customer;


set @seq := 0;
select (@seq = @seq + 1) '순번', custid, name, phone
from customer
where @seq < 2;

select custid, (select name
			    from customer cs
			    where cs.custid = od.custid) name, sum(saleprice) 'total'
from orders od
group by custid;

select od.custid, name, sum(saleprice) 'total'
from customer cs, orders od
where cs.custid = od.custid
group by od.custid;

select cs.name, sum(od.saleprice) 'total'
from (select custid, name
	  from customer
      where custid <= 2) cs, orders od
where cs.custid = od.custid
group by cs.name;

select orderid, saleprice
from orders
where saleprice <= (select avg(saleprice)
				    from orders);
                    
select orderid, custid, saleprice
from orders od
where saleprice > (select avg(saleprice)
from orders so
where od.custid=so.custid);

select sum(saleprice) 'total'
from orders
where custid in (select custid
				 from customer
                 where address like'%대한민국%');
                 
select orderid, saleprice
from orders
where saleprice > all (select saleprice
					   from orders
                       where custid = '3');
                       
select sum(saleprice) 'total'
from orders od
where exists (select *
			  from customer cs
              where address like '%대한민국%' and cs.custid = od.custid);
              
create view vw_book
as select *
from book
where bookname like '%축구%';

CREATE VIEW  vw_Orders (orderid, custid, name, bookid, bookname, saleprice, orderdate) 
AS SELECT od.orderid, od.custid, cs.name, od.bookid, bk.bookname, od.saleprice, od.orderdate 
FROM Orders od, Customer cs, Book bk 
WHERE od.custid =cs.custid AND od.bookid =bk.bookid;

create or replace view vw_customer(custid, name, address)
as select custid, name, address
from customer
where address like '%영국%';

