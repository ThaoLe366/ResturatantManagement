---------------------Tạo 2 role chủ cửa hàng và nhân viên
EXEC sp_addrole 'RoleChuCuaHang'
EXEC sp_addrole 'RoleThuNgan'
-------------Phần tạo Procedure để tạo user khi tạo mới nhân viên
go
create procedure dbo.CreateLoginAndUser(
        @login varchar(100),
        @password varchar(100))
as
declare @sql nvarchar(max)
set @sql = 'use ManagementRestaurant;' +
           'create login ' + @login + 
               ' with password = ''' + @password + '''; ' +
           'create user ' + @login + ' from login ' + @login + ';'+
		   'EXEC sp_addrolemember ''RoleChuCuaHang'','''+@login+''';'
exec (@sql)

go
create TRIGGER createlogin ON Employees
after INSERT
AS 
begin
	declare @login_ varchar(100),@password_ varchar(100)
	select @login_=userName,@password_=passWord
	from inserted;
	EXEC CreateLoginAndUser @login=@login_,@password=@password_;
end

----------------Tạo tài khoản chủ cửa hàng---------------
CREATE LOGIN quanlynhahang WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO

USE ManagementRestaurant
GO
CREATE USER quanlynhahang FOR LOGIN quanlynhahang
GO

ALTER USER quanlynhahang WITH DEFAULT_SCHEMA=[dbo]
GO

USE ManagementRestaurant
ALTER SERVER ROLE [sysadmin] ADD MEMBER quanlynhahang;
GO

USE ManagementRestaurant
ALTER SERVER ROLE [serveradmin] ADD MEMBER quanlynhahang;
GO

USE ManagementRestaurant
ALTER SERVER ROLE [setupadmin] ADD MEMBER quanlynhahang;
GO

USE ManagementRestaurant
ALTER SERVER ROLE [processadmin] ADD MEMBER quanlynhahang;
GO

USE ManagementRestaurant
ALTER SERVER ROLE [diskadmin] ADD MEMBER quanlynhahang;
GO

USE ManagementRestaurant
ALTER SERVER ROLE [securityadmin] ADD MEMBER quanlynhahang;
GO

USE ManagementRestaurant
ALTER SERVER ROLE [dbcreator] ADD MEMBER quanlynhahang;
GO


EXEC sp_addrolemember 'RoleChuCuaHang', 'quanlynhahang'


create view getallBill select * from Bill


exec addEmployees @idMan=2,@userName='Nhanvien1',@passWord='123',@name='kkk',@sex='F',@phone='123',@address='qwe',@salary=123,@level=0,@state='1'

-----Phân Quyền cho chủ cửa hàng
GRANT EXECUTE ON dbo.pro_searchEmployee TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.AddDishes TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.EditDishes TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.isExistUsername TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.addCustomer TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.AddDishes TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.AddCustomers TO RoleChuCuaHang WITH GRANT OPTION
grant EXECUTE ON dbo.addEmployees TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.addEvents TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.addItemOrderDetail TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.AddNewSeat TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.addOrder TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.addOrderDetail TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.ChangeSeat TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.ChangeStateSeat TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.check_Orderdetail TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.checkAccount TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.CreateLoginAndUser TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.deleteEmployees TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.deleteOrderDetail TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.DisableTable TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.editAreaName TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.EditCustomers TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.EditDishes TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.EditEvents TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.EnableTable TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getCustomerByID TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getCustomerPoint TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.GETDATA TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getDishesofaOrder TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getlastid TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getLastOrder TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getLevelAccount TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getnameDishbyID TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getOrderDetail TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getOrderDetailBySeatId TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.GetOrders TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.load_Invoice TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_addNewBill TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_addTypeFood TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_editTypeFood TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_findTypeFoodByName TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_loadDishInBill TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_loadTypeFood TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_loadTypeFoodByName TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.updateCustomerOrder TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.updateEmployees TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.updateOrderDetail TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.updatequantityOrder TO RoleChuCuaHang WITH GRANT OPTION
------------------function nhé
GRANT SELECT  ON dbo.fn_billByDateTime TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billById TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billByNameCus TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billByNameEmp TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billByState TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_getEmpByID TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_getStatisticBySpecificalFood TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_getStatisticByTypeFood TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_RevenuePerDay TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_RevenurePerDay TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.loadBill TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.loadTypeFood TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT  ON dbo.loadTypeFoodByName TO RoleChuCuaHang WITH GRANT OPTION

GRANT EXECUTE ON dbo.fn_getDiscountpercent TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.fn_getQuantityDish TO RoleChuCuaHang WITH GRANT OPTION
GRANT EXECUTE ON dbo.getlastidOrderDetail TO RoleChuCuaHang WITH GRANT OPTION
----------phân quyền trên bảng nhá
GRANT SELECT, INSERT, UPDATE, DELETE ON Area TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Bill TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Customers TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Dishes TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Employees TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Events TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON OrderDetail TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Revenue TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Seats TO RoleChuCuaHang WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON TypeFoods TO RoleChuCuaHang WITH GRANT OPTION






-----Phân Quyền cho thu ngân
GRANT EXECUTE ON dbo.pro_searchEmployee TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.addCustomer TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.AddCustomers TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.addItemOrderDetail TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.addOrder TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.addOrderDetail TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.ChangeSeat TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.ChangeStateSeat TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.check_Orderdetail TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.checkAccount TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.CreateLoginAndUser TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.deleteOrderDetail TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.EditCustomers TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getCustomerByID TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getCustomerPoint TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.GETDATA TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getDishesofaOrder TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getlastid TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getLastOrder TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getLevelAccount TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getnameDishbyID TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getOrderDetail TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getOrderDetailBySeatId TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.GetOrders TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.load_Invoice TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_addNewBill TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_findTypeFoodByName TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_loadDishInBill TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_loadTypeFood TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.pro_loadTypeFoodByName TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.updateCustomerOrder TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.updateOrderDetail TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.updatequantityOrder TO RoleThuNgan WITH GRANT OPTION

---------function
GRANT SELECT  ON dbo.fn_billByDateTime TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billById TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billByNameCus TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billByNameEmp TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_billByState TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_getEmpByID TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_getStatisticBySpecificalFood TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_getStatisticByTypeFood TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_RevenuePerDay TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.fn_RevenurePerDay TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.loadBill TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.loadTypeFood TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT  ON dbo.loadTypeFoodByName TO RoleThuNgan WITH GRANT OPTION

GRANT EXECUTE ON dbo.fn_getDiscountpercent TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.fn_getQuantityDish TO RoleThuNgan WITH GRANT OPTION
GRANT EXECUTE ON dbo.getlastidOrderDetail TO RoleThuNgan WITH GRANT OPTION
----------phân quyền trên bảng nhá
GRANT SELECT ON Area TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT, INSERT ON Bill TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE ON Customers TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT ON Dishes TO RoleThuNgan WITH GRANT OPTION
grant SELECT ON Employees TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT ON Events TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE ON OrderDetail TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT, INSERT, UPDATE ON Revenue TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT ON Seats TO RoleThuNgan WITH GRANT OPTION
GRANT SELECT ON TypeFoods TO RoleThuNgan WITH GRANT OPTION


-------------Lệnh để hiện tất cả các tài khoản đang có trong sql
exec sp_helpuser


-----------------------Bổ sung thêm các trigger và procedure mới
create trigger tg_updateBookingRevenue on Seats for update
as
	 begin
			
			if CAST( getDate() as DATE) not in (select r.statisticDate from Revenue r )
					INSERT INTO Revenue VALUES (CAST( getDate() as DATE), 0,0,0,0)
			DECLARE @day DATETIME, @state int
			select @day =cast( GETDATE() as DATE)
			select @state=state from inserted
			if @state=3
			begin
				update Revenue set numBooking+=1 where @day=Revenue.statisticDate;
			end
	 end

create trigger tg_updateBookingRevenue on Seats for update
as
begin
	declare @state int
	select @state=state from inserted
	if @state=3
	begin
	update Revenue set numBooking+=1 
	end
end

---TÌM KIẾM NHÂN VIÊN
--theo giới 

CREATE PROC pro_searchEmployee (@key nvarchar (50), @condition nvarchar(20))
as
BEGIN
	if(@key ='null')
	begin
		if(@condition=N'Tất cả' or @condition='')
			select * from Employees
		if(@condition= N'Nam')		
			select * from Employees where sex='M'
	    if (@condition=N'Nữ')
			select * from Employees where sex='F'
		if(@condition=N'Quản lí')
			select * from Employees where level=1
		if(@condition=N'Nhân viên')
			select * from Employees where level=0
		if(@condition=N'Đang làm việc')
			select * from Employees where state=1
		if(@condition=N'Đã nghĩ' )
			select * from Employees where state=0
	end
	else

	begin
		if(@condition =N'Tất cả')
			select * from Employees where (name LIKE '%' +@key+'%' OR phone LIKE '%'+@key + '%' OR address LIKE '%' + @key + '%')
		if(@condition= 'Nam')		
			select * from Employees where sex='M' and (name LIKE '%' +@key+'%' OR phone LIKE '%'+@key + '%' OR address LIKE '%' + @key + '%')
	    if (@condition=N'Nữ')
			select * from Employees where sex='F' and (name LIKE '%' +@key+'%' OR phone LIKE '%'+@key + '%' OR address LIKE '%' + @key + '%')
		if(@condition=N'Quản lí')
			select * from Employees where level=1 and (name LIKE '%' +@key+'%' OR phone LIKE '%'+@key + '%' OR address LIKE '%' + @key + '%')
		if(@condition=N'Nhân viên')
			select * from Employees where level=0 and (name LIKE '%' +@key+'%' OR phone LIKE '%'+@key + '%' OR address LIKE '%' + @key + '%')
		if(@condition=N'Đang làm việc')
			select * from Employees where state=1 and (name LIKE '%' +@key+'%' OR phone LIKE '%'+@key + '%' OR address LIKE '%' + @key + '%')
		if(@condition=N'Đã nghĩ' )
			select * from Employees where state=0 and (name LIKE '%' +@key+'%' OR phone LIKE '%'+@key + '%' OR address LIKE '%' + @key + '%')
	end
END
GO








create PROC AddDishes @name nvarchar(30),@price int,@idType int,@state nvarchar(15),@img_source nvarchar(100)
as
begin
	insert into Dishes (name,price,idType,state,image) values (@name,@price,@idType,@state,@img_source)
end

create proc EditDishes @id int, @name nvarchar(30),@price int,@idType int,@state nvarchar(15),@img_source nvarchar(100)
as
begin
	update Dishes set name=@name,price=@price,idType=@idType,state=@state,image=@img_source where id=@id
end


alter trigger tg_updateAllDish on TypeFoods for update
as
begin
	declare @TypeState bit,@id int
	select @TypeState=i.state,@id=i.id from inserted i
	if(@TypeState=0)
	update Dishes set state=1
	where idType=@id
end

------------------------
drop proc pro_addTypeFood
create proc pro_addTypeFood(@name nvarchar(30),@state bit)
as
begin
	insert into TypeFoods values (@name,@state)
end
-------------------------





-------------
ALTER PROC GETDATA (@table varchar(30))
AS 
	if (@table ='Dishes')
	begin		
		select * from Dishes
		return
	end
	else if (@table ='TypeFoods')
	begin
		select * from TypeFoods where state='False'
		return
	end
	else if (@table ='Manager')
	begin
		select * from Employees as a 
		where Exists(select * 
				from Employees b 
				where a.id= b.idMan)  
		 return
	 end
    else if(@table='Events')
	begin
		select * from Events
		where endDate>GETDATE()
		return
	end
	else if(@table ='Bill')
	begin
		select * from Bill
		return 
	end
	else if(@table='Area')
	begin
		select * from Area
		return
	end
	else if (@table='Employees')
		begin 
		select * from Employees
		return 
		end

	else if (@table='Customers')
	begin
	select * from Customers
	return
	end
GO
--------kiểm tra user name tồn tại hay chưa
CREATE proc isExistUsername(@username varchar(15))
as 
BEGIN

	SELECT userName From Employees
	where userName= @username;
END
GO


drop trigger same_Username on Employees for insert 
as begin
	declare @username varchar(15);
	select @username=userName from INSERTED;
	if exists(select * from Employees where userName=@username) 
	BEGIN
	RAISERROR('lỖI',@username,-1,-1);
	ROLLBACK TRANSACTION;
	end
end
for each row
begin
if (:new.NGAYHD > sysdate) then
raise_application_error(-20205,'Ngay xuat hoa don khong duoc lon hon ngay hien tai');
end if;
end;




USE [ManagementRestaurant]
GO
/****** Object:  StoredProcedure [dbo].[isExistUsername]    Script Date: 12/26/2020 9:12:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[isExistUsername](@username varchar(15))
as 
BEGIN

	SELECT userName From Employees
	where userName= @username;
END


