create table members(
memid varchar(10) not null,
memname varchar(20) not null,
passwd varchar(128),
passwdmdt datetime(6),
jumin varchar(64),
addr varchar(100),
birthday date,
jobcd char(1),
mileage decimal(7, 0) unsigned default 0,
stat enum('Y', 'N') default 'Y',
enterdtm datetime(6),
leavedtm datetime(6),
primary key(memid)
);
create table goodsinfo(
goodscd char(5) not null, 
goodsname varchar(20) not null, 
unitcd char(2),
unitprice decimal(5, 0), 
stat enum('Y', 'N') default 'Y',
insdtm datetime(6),
moddtm datetime(6),
primary key(goodscd)
);
create table order_h(
orderno char(9) not null, 
orddt date not null, 
memid varchar(10) not null, 
ordamt decimal(7, 0) unsigned default 0 not null, 
cancelyn char(1),
canceldtm datetime(6),
insdtm datetime(6),
moddtm datetime(6),
primary key(orderno)
);
create table order_d(
orderno char(9) not null,
goodscd char(5) not null,
unitcd char(2),
unitprice decimal(5, 0) unsigned default 0 not null,
qty decimal(3, 0) unsigned default 0 not null,
amt decimal(7, 0) unsigned default 0 not null,
insdtm datetime(6),
moddtm datetime(6),
primary key(orderno, goodscd)
);
CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (ID)
);
insert into persons values(1, 'Hansen', 'ola', 30);
insert into persons values(2, 'Svendson', 'Tove', 23);
insert into persons values(3, 'Pettersen', 'Kari', 20);

CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES Persons(ID)
);

insert into orders value(1, 77895, 3);
insert into orders value(2, 44678, 3);
insert into orders value(3, 22456, 2);
insert into orders value(4, 24562, 1);