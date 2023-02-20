create table customer(
	custid INT not null,
	name VARCHAR(40),
	address VARCHAR(50),
	phone VARCHAR(20),
	primary key(custid)
);

create table book(
	bookid INT not null,
	bookname VARCHAR(40),
	publisher VARCHAR(40),
	price INT,
	primary key(bookid)
);

create table orders(
	orderid INT not null,
    custid INT not null,
    bookid INT not null,
    saleprice INT,
    orderdate DATE,
    primary key(orderid),
    foreign key(custid) references customer(custid),
    foreign key(bookid) references book(bookid)
);
INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');  
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000, STR_TO_DATE('2014-07-01','%Y-%m-%d')); 
INSERT INTO Orders VALUES (2, 1, 3, 21000, STR_TO_DATE('2014-07-03','%Y-%m-%d'));
INSERT INTO Orders VALUES (3, 2, 5, 8000, STR_TO_DATE('2014-07-03','%Y-%m-%d')); 
INSERT INTO Orders VALUES (4, 3, 6, 6000, STR_TO_DATE('2014-07-04','%Y-%m-%d')); 
INSERT INTO Orders VALUES (5, 4, 7, 20000, STR_TO_DATE('2014-07-05','%Y-%m-%d'));
INSERT INTO Orders VALUES (6, 1, 2, 12000, STR_TO_DATE('2014-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (7, 4, 8, 13000, STR_TO_DATE( '2014-07-07','%Y-%m-%d'));
INSERT INTO Orders VALUES (8, 3, 10, 12000, STR_TO_DATE('2014-07-08','%Y-%m-%d')); 
INSERT INTO Orders VALUES (9, 2, 10, 7000, STR_TO_DATE('2014-07-09','%Y-%m-%d')); 
INSERT INTO Orders VALUES (10, 3, 8, 13000, STR_TO_DATE('2014-07-10','%Y-%m-%d'));

select *
from book
where publisher = "굿스포츠" or publisher = "대한미디어";

select *
from book
where publisher <> "굿스포츠" and publisher <> "대한미디어";

select bookname, publisher
from book
where bookname = "축구의 역사";

select bookname, publisher
from book
where bookname like "%축구%";

select *
from book
where bookname like '_구%';

select *
from book
where bookname like '%축구%' and price > 20000;

select *
from book
where publisher = '굿스포츠' or publisher = '대한미디어';

select *
from book
order by bookname;

select *
from book
order by price, bookname;

select *
from book
order by price desc, publisher;

select sum(saleprice) as 총매출
from orders;


select sum(saleprice) as 총매출
from orders
where custid = 2;

select sum(saleprice) as Total, avg(saleprice) as Average, min(saleprice) as Minimum, max(saleprice) as Maximum
from orders;

select count(*) 
from orders;

select custid, count(*) as 총수량, sum(saleprice) as 총액
from orders
group by custid with rollup;

select custid, count(*) as 도서수량
from orders
where saleprice >= 8000
group by custid
having count(*) >= 2;

select *
from customer, orders
where customer.custid = orders.custid;

select name, sum(saleprice)
from customer, orders
where customer.custid = orders.custid
group by customer.name
order by customer.name;

select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and book.bookid = orders.bookid;

select customer.name, book.bookname
from customer, orders, book
where customer.custid = orders.custid and orders.bookid = book.bookid and book.price = 20000;

select customer.name, saleprice
from customer left outer join orders
on customer.custid = orders.custid;

select customer.name, saleprice
from customer left outer join orders
on customer.custid = orders.custid
where saleprice is null;

select bookname
from book
where price = (select max(price)
			   from book);
                
select name 
from customer
where custid in (select custid
				 from Orders);
                 
select distinct name 
from customer natural join orders;

select name
from customer
where custid in (select custid
				 from orders
				 where bookid in (select bookid
								  from book
                                  where publisher = '대한미디어'));

select name
from customer
where address like '대한민국%'
union
select name
from customer
where custid in (select custid from orders);

select name
from customer
where address like '대한민국%' and
		name not in (select name 
					 from customer
					 where custid in (select custid from orders));

select name
from customer
where address like '대한민국%' and
		name in (select name 
					 from customer
					 where custid in (select custid from orders));


