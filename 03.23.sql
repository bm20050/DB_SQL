use pnusw45;

create table user (
	uid varchar(20) primary key,
    uname varchar(20) not null,
    email varchar(30) not null,
    rdate datetime default current_timestamp
);
drop table user;
drop table deluser;
create table deluser (
	uid varchar(20) not null,
    uname varchar(20) not null,
    email varchar(30) not null,
    wdate datetime default current_timestamp
);

delimiter //
create procedure InsertUser (
	in _uid varchar(20),
    in _uname varchar(20),
    in _email varchar(30)
)
begin
	insert into user(uid, uname, email) values(_uid, _uname, _email);
end;
// delimiter ;

call InsertUser('1', 'a', 'aa@gmail.com');
call InsertUser('2', 'c', 'cc@gmail.com');
select * from user;

delimiter //
create procedure DeleteUser (
	in _uid varchar(20)
)
begin
	delete from user where uid = _uid;
end;
// delimiter ;

drop trigger AfterDeleteUser;

delimiter //
create trigger BeforeDeleteUser
before delete on user for each row
begin
	insert into deluser(uid, uname, email) values(old.uid, old.uname, old.email);
end;
// delimiter ;

call DeleteUser('2');
select * from user;
delete from deluser;
select * from deluser;

delimiter //
create procedure SearchUserOne (
	in _uid varchar(20)
)
begin
	select * from user where uid = _uid;
end;
// delimiter ;

call SearchUserOne('1');
select * from user;

delimiter //
create procedure SearchUser (
)
begin
	select * from user;
end;
// delimiter ;

call SearchUser();
select * from user;



delimiter //
create procedure UpdateUser (
	in _uid varchar(20),
    in _uname varchar(20),
    in _email varchar(30)
)
begin
	update user set uname = _uname, email = _email where uid = _uid;
end;
// delimiter ;
call UpdateUser('2', 'd', 'dd@gmail.com');
select * from user;