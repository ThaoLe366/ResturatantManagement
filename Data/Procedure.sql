
-- Lấy danh sách tất cả cả Bill
create or alter function loadBill()
returns table
as
	return select b.id as idBill, e.name as nameEmp, c.name as nameCus,count(o.id) as Quantity, 
		b.timeCheckOut,b.deal, 
		b.totalCost, b.state, b.loyalFriend from Bill b,
		OrderDetail o, Employees e, Customers c
			WHERE   b.id  = o.idBill and e.id =b.idEmp and b.idCus=c.id
		GROUP BY  b.id,e.name, c.name, b.timeCheckOut,b.totalCost,b.state ,b.deal,b.loyalFriend
go

-- Lấy ds các hóa đơn theo ID

create or alter function fn_billById(@id int) 
returns table
as
	return select b.id as idBill , e.name as nameEmp, c.name as nameCus,count(o.id) as Quantity, 
		b.timeCheckOut,b.deal, 
		b.totalCost, b.state, b.loyalFriend from Bill b,
		OrderDetail o, Employees e, Customers c
			WHERE (SELECT CHARINDEX(cast (@id as NVARCHAR), CAST (b.id as NVARCHAR)))>0 and b.id  = o.idBill and e.id =b.idEmp and b.idCus=c.id
		GROUP BY  b.id, e.name, c.name, b.timeCheckOut,b.totalCost,b.state ,b.deal,b.loyalFriend
go

-- Tìm kiếm ds hóa đơn theo tên nhân viên thu ngân
CREATE or ALTER function fn_billByNameEmp(@name nvarchar(30)) 
returns table
as  RETURN	select b.id as idByBill, e.name as nameEmp, c.name as nameCus,COUNT(o.id) as Quantity, 
		b.timeCheckOut,b.deal, 
		b.totalCost, b.state, b.loyalFriend from Bill b,
		OrderDetail o, Employees e, Customers c
			WHERE (select CHARINDEX(@name, e.name))>0 and b.id = o.idBill
			and e.id =b.idEmp and b.idCus=c.id and e.state=0
		GROUP BY  b.id, e.name, c.name, b.timeCheckOut,b.totalCost,b.state,b.deal,b.loyalFriend
go

----------
-- Tìm ds hóa đơn theo tên khách hàng
CREATE or ALTER function fn_billByNameCus(@name nvarchar(30)) 
returns table
as  RETURN	select b.id as idByBill, e.name as nameEmp, c.name as nameCus,COUNT(o.id) as Quantity, 
		b.timeCheckOut,b.deal, 
		b.totalCost, b.state, b.loyalFriend from Bill b,
		OrderDetail o, Employees e, Customers c
			WHERE (select CHARINDEX(@name, c.name))>0 and b.id  = o.idBill
			and e.id =b.idEmp and b.idCus=c.id 
		GROUP BY  b.id, e.name, c.name, b.timeCheckOut,b.totalCost,b.state ,b.deal,b.loyalFriend
		go

--Tìm kiếm hóa đơn theo trạng thái (hoàn thành- hủy)
create or alter function fn_billByState(@state BIT)
returns table
as  RETURN   select	 b.id as idBill,  e.name as nameEmp, c.name as nameCus,COUNT(b.id) as Quantity, 
		b.timeCheckOut,b.deal, 
		b.totalCost, b.state, b.loyalFriend from Bill b,
		OrderDetail o, Employees e, Customers c
			WHERE b.state = @state and b.id = o.idBill and e.id =b.idEmp and b.idCus=c.id
		GROUP BY   b.id, e.name, c.name, b.timeCheckOut,b.totalCost,b.state ,b.deal,b.loyalFriend
		go
	
-- Tìm Bill (hóa đơn) theo khoản thời gian
create or alter function fn_billByDateTime(@start DATETIME,@end DATETIME)
returns table
as  RETURN	(Select b.id as idBill,e.name as nameEmp, c.name as nameCus,COUNT(b.id) as Quantity, 
		b.timeCheckOut,b.deal, 
		b.totalCost, b.state, b.loyalFriend from Bill b,
		OrderDetail o, Employees e, Customers c
			WHERE b.timeCheckOut >= @start and b.timeCheckOut <= @end and b.id  = o.idBill and e.id =b.idEmp and b.idCus=c.id
		GROUP BY b.id, e.name, c.name, b.timeCheckOut,b.totalCost,b.state ,b.deal,b.loyalFriend)
		go

-- Tạo Trigger cho bản doanh thu mỗi khi có bill được thanh toán
create trigger tg_updateRevenue on Bill after Insert
as
	 begin
			
			if CAST( getDate() as DATE) not in (select r.statisticDate from Revenue r )
					INSERT INTO Revenue VALUES (CAST( getDate() as DATE), 0,0,0,0)
			DECLARE @day DATETIME,@mStateBill bit, @stateBill DATETIME, @cost int
			select @day =cast( GETDATE() as DATE)
			SELECT @stateBill = state From inserted
			select  @cost = totalCost FROM INSERTED
			if (@stateBill =1)
				BEGIN
					update Revenue SET numCancel = numCancel +1 WHERE  CAST(statisticDate as DATE)= @day
				END
			update Revenue SET numBill = numBill +1 WHERE  cast (statisticDate as DATE) = @day
			UPDATE Revenue SET sumRevenue = sumRevenue + @cost  WHERE  cast (statisticDate as DATE) = @day
	 end
go
-- Thống  kê doanh thu,... theo loại thứ ăn
go
create or ALTER FUNCTION fn_getStatisticByTypeFood(@start DATETIME, @end DATETIME)
RETURNS TABLE
AS
	return select top 7 t.name, SUM(odt.quantity) as number,SUM(odt.price*odt.quantity) as totalRevenue  from TypeFoods t, Dishes d, Bill b, OrderDetail odt
	WHERE CAST( b.timeCheckOut as DATE)>= CAST( @start AS DATE) and CAST( b.timeCheckOut as DATE)<=Cast( @end as date) and b.id=odt.idBill AND odt.idDish= d.id AND t.id = d.idType 
	GROUP by t.name
go

go
------------- Thống  kê doanh thu,... theo loại thứ ăn
create or ALTER FUNCTION fn_getStatisticBySpecificalFood(@start DATETIME, @end DATETIME)
RETURNS TABLE
AS
	return select top 7 d.name, SUM(odt.quantity) as number,SUM(odt.quantity* odt.price) as totalRevenue  from  Dishes d, Bill b, OrderDetail odt
	WHERE CAST( b.timeCheckOut as DATE)>= CAST( @start AS DATE) and CAST( b.timeCheckOut as DATE)<=Cast( @end as date) and b.id=odt.idBill AND odt.idDish= d.id 
	GROUP by d.name
go

---------- Lấy doanh thu theo ngày
go
CREATE or alter FUNCTION fn_RevenurePerDay (@day DATETIME)    
RETURNS TABLE
AS 
	return select * FROM Revenue WHERE  CAST(@Day as DATE) = Revenue.statisticDate


---------- Lấy doanh thu theo khoảng thời gian
go
CREATE or alter FUNCTION fn_RevenuePerDay (@start DATETIME, @end DATETIME)    
RETURNS  TABLE 
AS 
	return select id, statisticDate, sumRevenue, numCancel, numBill, numBooking 
		FROM Revenue 
		WHERE  CAST(@start as DATE) <= Revenue.statisticDate and  CAST(@end as DATE) >= Revenue.statisticDate
	
go		
SELECT * from dbo.fn_RevenuePerDay('2020-12-09 00:00:00.000', '2020-12-09 00:23:00.000')



--------- Lấy loại món ăn
go
CREATE or ALTER function loadTypeFood ()
returns table
as 
	return select t.id, t.name, COUNT(d.id) as quantity, t.state as stateService
					from TypeFoods t, Dishes d 
					WHERE t.id = d.idType
					GROUP by t.id, t.name, t.state
					go


CREATE or ALTER PROCEDURE pro_loadTypeFood @state NVARCHAR =NULL
as 
	begin
	if (@state is NULL)
		select t.id, t.name, COUNT(d.id) as quantity, t.state as stateService
						from TypeFoods t LEFT JOIN  Dishes d ON  t.id = d.idType
					
						GROUP by t.id, t.name, t.state

	ELSE
		select t.id, t.name, COUNT(d.id) as quantity, t.state as stateService
						from TypeFoods t LEFT JOIN  Dishes d ON  t.id = d.idType
						where t.state = cast(@state as bit)
						GROUP by t.id, t.name, t.state
	end
	
-- Tìm kiếm loại món ăn theo tên
go
create or alter function loadTypeFoodByName(@name nvarchar(30))
returns table
as 
return SELECT t.id, t.name, COUNT(d.id) as quantity, t.state as stateService from TypeFoods t, Dishes d 
		WHERE (select charindex(@name, t.name))>0 and t.id = d.idType
		group by t.id, t.name, t.state
		go

CREATE or alter PROCEDURE pro_loadTypeFoodByName @name NVARCHAR(30), @state NVARCHAR =NULL
AS	
	BEGIN
		if (@state is not NULL)  --fliter with condition
			SELECT t.id, t.name, COUNT(d.id) as quantity, t.state as stateService from TypeFoods t, Dishes d 
			WHERE   (cast(@state as bit)) = t.state and (select charindex(@name, t.name))>0 and t.id = d.idType 
			group by t.id, t.name, t.state
		ELSE
			SELECT t.id, t.name, COUNT(d.id) as quantity, t.state as stateService from TypeFoods t, Dishes d 
			WHERE (select charindex(@name, t.name))>0 and t.id = d.idType 
			group by t.id, t.name, t.state
	END
go
	
----- Lấy danh sách món ăn của một loại món ăn cụ thể

create or alter PROCEDURE pro_findTypeFoodByName(@id int)
as	
		BEGIN
			SELECT d.id,d.name,d.price,t.id, d.state,t.name,d.image FROM Dishes d, TypeFoods t
			WHERE t.id=@id AND t.id=d.idType 
		END

		DECLARE @type INT
		set @type= 4
		EXECUTE pro_findTypeFoodByName @type
go
--- Chỉnh sữa loại món ăn
create or alter procedure pro_editTypeFood(@id int, @name NVARCHAR(30), @state bit )
as	
	begin
		update TypeFoods  set name= @name, state= @state where @id = id
	end	

--tg: Update ngưng bán các món ăn của loại món ăn nếu loại món ăn đó ngưng phục vụ
go
Create trigger tg_updateALlDish on TypeFoods for  UPDATE
as
	begin
		declare @TypeState bit, @id int
		Select @TypeState=i.state, @id= i.id from inserted i 
		if (@TypeState = 1)
			update  Dishes set state =cast( @TypeState as NVARCHAR(1))WHERE  idType =@id
	end
go
--Kiểm tra các món ăn bị disable có ảnh hưởng đến tình trạng của loại món ăn hay không
--drop trigger tg_updateAllDishChangeType
--go
--	CREATE TRIGGER tg_updateAllDishChangeType on Dishes for INSERT, UPDATE
--		as
--		begin 
--			Declare @ItemState NVARCHAR(15), @opItemState NVARCHAR(15), @idType INT

--			SELECT @ItemState= state, @idType=idType FROM INSERTED
--			if (@ItemState='0') --0: available
--				SELECT @opItemState= '1'
--			ELSE
--				SELECT @opItemState='0'
				
--			if (select count(d.id) from Dishes d WHERE d.state= @opItemState AND @idType= d.idType) <= 0
--				update  TypeFoods set state = cast (@ItemState as BIT) WHERE id= @idType
			
--		end
--		DROP TRIGGER tg_updateAllDishChangeType
--		go
--		CREATE TRIGGER tg_updateAllDishChangeType on Dishes AFTER INSERT, UPDATE
--		as
--		begin 
--			Declare @ItemState NVARCHAR(15), @opItemState NVARCHAR(15), @idType INT

--			SELECT @ItemState= state, @idType=idType FROM INSERTED
--			if (@ItemState='0') --0: available
--				BEGIN
--					if (select t.state from TypeFoods t WHERE @idType= t.id) = 1
--						update  TypeFoods set state = cast (@ItemState as BIT) WHERE id= @idType 
--				END
--			ELSE
--				BEGIN
--					if (select count(d.id) from Dishes d WHERE d.state= '0' AND @idType= d.idType) <= 0
--						update  TypeFoods set state = cast (@ItemState as BIT) WHERE id= @idType
--				END
			
--		end
--go
	
------------------------------ invoice 
--Lấy thông tin cụ thể của một hóa đơn
CREATE OR ALTER procedure load_Invoice (@id int)
as 
	BEGIN
		select b.id, b.timeCheckOut	, c.name as CusName, c.phone, e.id as EmpId, e.name EmpName, eve.name as PromName, eve.discount, b.loyalFriend, b.totalCost
			FROM Bill b,  Customers c, Employees e, Events eve
			WHERE  b.id =@id and b.idCus =c.id and b.idEmp =e.id and b.deal =eve.id 
	END

--Lấy các món ăn của một hóa đơn
go
CREATE or ALTER PROCEDURE pro_loadDishInBill(@id int)
as
	BEGIN
		select d.name, odt.price, odt.quantity from Bill b, OrderDetail odt, Dishes d
				where @id=b.id AND b.id= odt.idBill AND odt.idDish =d.id 
	END
go
		
--add new typefood
go
create or alter  PROC pro_addTypeFood(@name nvarchar(30), @state bit)
as
	BEGIN
		insert into TypeFoods VALUES (@name, @state);
	END
go
	
	--********************************BÌNH *****************************************

---------------tạo procedure kiểm tra tài khoản
go
create procedure checkAccount (@userName VARCHAR(15),@passWord VARCHAR(15))
as
begin
	Select *
	from Employees
	where userName=@userName and passWord=@passWord and state=1;
end
--------------tạo procedure lấy level của account
go
create procedure getLevelAccount (@userName VARCHAR(15),@passWord VARCHAR(15))
as
begin
	Select *
	from Employees
	where userName=@userName and passWord=@passWord and state=1 and level=0
end

--------------tạo procedure disable cái bàn
go
create procedure DisableTable @id int
as
begin
	UPDATE Seats set state=4 where id=@id
end
go
----------------tạo procedure để enable lại cái bàn
create procedure EnableTable @id int
as
begin
	UPDATE Seats set state=1 where id=@id
end
go
-------------tạo procedure để thay đổi state của seat
create procedure ChangeStateSeat @id int,@state int
as
begin
	UPDATE Seats set state=@state where id=@id
end
go
--tạo procedure thêm 1 bàn


----tạo trigger kiểm tra khi thay đổi trạng thái của bàn
create trigger tr_ChangeStateTable on Seats for update
as
begin
	declare @idban int
	select @idban=id from inserted
	IF(Select state from inserted)=4
	begin
		if(Select state from deleted)=1
		begin
			update Seats set state =4 where id=@idban
		end
		else
			rollback tran
	end
end
-----tạo proc để chuyển bàn
create proc ChangeSeat @id1 int,@id2 int
as
begin
	--chuyển trạng thái bàn 1 qua trống
	update Seats set state=1 where id=@id1;
	--chuyển trạng thái bàn 2 qua có khách
	update Seats set state=2 where id=@id2;
	--chuyển id seats trong order từ bàn 1 sang bàn 2
	update Orders set idSeat=@id2 where idSeat=@id1

end
create proc MergeSeat @id1 int,@id2 int
as
begin
	
end
-----lấy order detail thông qua id bàn
create proc getOrderDetailBySeatId @id int
as
begin
	select OrderDetail.idDish,OrderDetail.quantity,OrderDetail.idOrder
	from OrderDetail, Orders
	where OrderDetail.idOrder=Orders.id and Orders.idSeat=@id
end
---------update order detail------
create proc updateOrderDetail @idDish int,@quantity int,@idOrder int
as
begin
	update OrderDetail set quantity=quantity+@quantity
	where idDish=@idDish and idOrder=@idOrder;
end

execute updateOrderDetail @idDish =1,@quantity =4,@idOrder=8
--------------add item for order detail--------
create proc addItemOrderDetail @idDish int,@quantity int,@idOrder int
as
begin
	declare @price int;
	select @price=price
	from Dishes
	where id=@idDish;
	INSERT INTO OrderDetail(idOrder,idDish,quantity,price) VALUES (@idOrder,@idDish,@quantity,@price);
end
--------------xóa 1 order detail sau khi gộp bàn
create proc deleteOrderDetail @idOrder int
as
begin
	delete from OrderDetail where idOrder=@idOrder;
end
go
--===================phaafn orrder
 create proc addOrder @idSeat int,@idEmp int
as
begin
	insert into Orders (idSeat,idEmp,timeOrder) values (@idSeat,@idEmp,GETDATE());
end
go


----------------lấy cái dòng cuối cùng của bảng order
create proc getLastOrder
as
begin
	SELECT TOP 1 * FROM Orders ORDER BY id DESC
end
GO
---------------lấy 1 order
create proc GetOrders @idSeat int
as
begin
	Select * from Orders where idSeat=@idSeat;
end
GO
----------------Kiểm tra cái orderdetail khi nhấn order 1 bàn
create proc check_Orderdetail
as
begin
	declare @idOrder int
	select @idOrder=id
	from (SELECT TOP 1 * FROM Orders ORDER BY id DESC) as A
	if NOT EXISTS (SELECT *
				FROM OrderDetail
				WHERE idOrder=@idOrder)
	begin
		Delete from Orders where id=@idOrder; 
	end
end
GO
------------chỉnh sửa tên 1 khu vực
create proc editAreaName @idArea int,@nameArea nvarchar(50)
as
begin
	update Area set name=@nameArea
	where id=@idArea;
end
GO
------------cập nhập lại idCustomer khi nhấn vào bếp
CREATE proc updateCustomerOrder @phone varchar(12)
as
begin
	declare @idOrder int,@idCustomer int
	select @idOrder=id
	from (SELECT TOP 1 * FROM Orders ORDER BY id DESC) as A;
	if (@phone='null')
		set @idCustomer=1
	else
	begin
		select @idCustomer=id
		from Customers
		where phone=@phone;
	end
	update Orders set idCus=@idCustomer where id=@idOrder;
end
GO

----******************************Phần của HOÀNG*******************************

--------LẤY DỮ LIỆU BẰNG PROC
--******************* NHÂN VIÊN **********************

----------------Thêm nhân viên --------------

CREATE PROC addEmployees(
							@idMan int, 
							@userName nvarchar(15), 
							@passWord varchar(15),
							@name nvarchar(30),
							@sex nvarchar(2),
							@phone varchar(12), 
							@address nvarchar(100), 
							@salary  int,
							@level int, 
							@state nvarchar(15))
As
Begin
	Insert into Employees values ( @idMan, @userName,
								  @passWord, @name, @sex, 
								  @phone, @address, @salary,
								  @level,@state);
End

go


--*****************PROC lấy dữ liệu *************************


CREATE OR ALTER PROC GETDATA (@table varchar(30))
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


Drop PROC getlistManager
GO


-----------------Xóa nhân viên-------------------

CREATE or ALTER PROC deleteEmployees(@ID INT)
AS
BEGIN
	DELETE Employees WHERE Employees.id=@ID;
END
go

------------------Chỉnh sửa thông tin nhân viên--------------------

CREATE OR ALTER PROC updateEmployees(@id int, 
							@idMan int, 
							@userName nvarchar(15), 
							@passWord varchar(15),
							@name nvarchar(30),
							@sex CHAR(1),
							@phone varchar(12), 
							@address nvarchar(100), 
							@salary  int,
							@level int, 
							@state nvarchar(15))
As
Begin
	
	UPDATE Employees 
	SET
	idMan=@idMan,
	userName=@userName,
	passWord=@passWord,
	name=@name,
	sex=@sex,
	phone=@phone,
	address=@address,
	salary=@salary,
	level= @level,
	state=@state
	where id=@id;
END
GO


--****************************KHÁCH HÀNG *******************************

------------Procedure thêm khách hàng------------------
CREATE PROC addCustomer (@phone varchar(10),
						 @name nvarchar(30),
						 @point int)
AS
BEGIN
		INSERT INTO Customers VALUES (@phone, @name ,@point)
END
GO

CREATE PROC getCustomerPoint (@id int)
AS
BEGIN
	SELECT point from Customers where id=@id
END
go

CREATE PROC getCustomerByID(@id int)
AS
BEGIN
	SELECT * FROM Customers where id=@id
END
GO
--***********************   ORDER  ***************************

-------------------Procedure lấy orderdetail-------------------------
CREATE PROC getOrderDetail 
as
BEGIN
	SELECT * FROM OrderDetail ;
END
go

------------------Procedure thêm vào bảng orderdetail----------------
CREATE PROC addOrderDetail ( 
							 @idOrder int,
							 @idDish int,
							 @quantity int,
							 @price int)
AS
BEGIN
	INSERT INTO OrderDetail VALUES (@idOrder,null,@idDish,@quantity, @price)

END
go							
---------------Lấy id cuối --------------------

CREATE PROC getlastid (@table varchar(20))
as
begin 
	
	select dbo.getlastidOrderDetail(@table);
end
go

-----------------Lấy Orderdetail của một idOrder-----------

CREATE PROC getDishesofaOrder (@idorder int )
AS
BEGIN
	SELECT * FROM OrderDetail 
	where idOrder=@idorder
END
go
------------------Lấy tên món ăn bằng id ----------------------
CREATE PROC getnameDishbyID (@id int)
as
BEGIN
	SELECT name
	FROM Dishes
	WHERE id= @id
END
GO

--------------------Update số lượng đặt món----------------------
CREATE PROC updatequantityOrder (@id int, @quantity int)
AS
BEGIN
	UPDATE OrderDetail SET quantity=@quantity where id=@id;
END
GO

-----------------Thêm bill mới-----------------------

CREATE OR ALTER PROC pro_addNewBill ( @deal int, @totalcost int, @idem int, @idcus int, @state int, @loyalFriend int, @idOrder int)
AS
BEGIN
	if(@state !=0 and @state!=1) 
		set @state=0;
	if(@idcus=0)
		set @idcus = null;
	INSERT INTO Bill VALUES ( GETDATE(),@deal ,@totalcost,@idem,@idcus,@state, @loyalFriend );
	Declare @idbill int ;
	set @idbill= (SELECT TOP 1 id FROM Bill
	ORDER BY id DESC);
	update OrderDetail set idBill=@idbill where idOrder=@idOrder
	
END
GO

------------------------------------FUNCTION-------------------------------------

---------------------------Lấy id cuối---------------

ALTER or CREATE FUNCTION getlastidOrderDetail (@table varchar(20))
returns int
as
BEGIN
Declare @id int;
	if(@table ='Customers')
	begin
		if (EXISTS(select * from Customers))		
		begin
				select @id=MAX(id)
				from Customers;
				return @id;
		end
		else
			return 0;
	end

	if(@table='OrderDetail')
	begin
	if(EXISTS(SELECT * FROM OrderDetail))
		begin
			select @id= Max(id)
			from OrderDetail;
			return @id;
		end
		else return 0;
	end

	if(@table ='Employees')
	begin
		if(EXISTS(Select * from Employees))
			Begin
				select @id= Max(id)
				from Employees;
				return @id;
			end
		else return 0;
	end
	
	if(@table='Orders')
	begin
		if(EXISTS (Select * from Orders))
			begin
				select @id= Max(id)
				from Orders;
				return @id;
			end
		else return 0;
	end
	
	if(@table='Bill')
	begin
	if(EXISTS(Select * from Bill))
		begin
			select @id= Max(id)
			from Bill;
			return @id;
			end
		else return 0;
	end

	if(@table='Dishes')
	begin
	if(EXISTS(Select * from Dishes))
		begin
			select @id= Max(id)
			from Dishes;
			return @id;
			end
		else return 0;
	end

	if(@table='TypeFoods')
	begin
	if(EXISTS(Select * from TypeFoods))
		begin
			select @id= Max(id)
			from TypeFoods;
			return @id;
			end
		else return 0;
	end

	if(@table='Events')
	begin
	if(EXISTS(Select * from Events))
		begin
			select @id= Max(id)
			from Events;
			return @id;
			end
		else return 0;
	end

	return null;
END
GO

-----------------------Best seller--------------------------------

CREATE OR ALTER PROC getBestSeller (@idType int)
as
BEGIN
	select top(5) id, name, price, idType, state, image, TongDia
	from Dishes,(select sum(quantity) as TongDia, idDish
				from OrderDetail ,  Dishes
				where Dishes.id=idDish AND Dishes.idType= @idType and idBill IS not NULL
				Group by idDish) as t
	where Dishes.id =t.idDish
	order by t.TongDia Desc
END

GO

---------------Lấy danh sách nhân viên bằng id --------------

CREATE OR ALTER FUNCTION fn_getEmpByID (@id int)
RETURNS TABLE
AS 
RETURN SELECT * FROM Employees WHERE id=@id
GO

---------------------Lấy số lượng món ăn----------------

CREATE Or ALTER FUNCTION fn_getQuantityDish (@idDish int, @idOrder int)
RETURNS INT
AS
BEGIN
	DECLARE @QUAN INT;	
	SELECT @QUAN=quantity from OrderDetail where idDish= @idDish and idOrder= @idOrder;
	RETURN @QUAN;
END
GO


------------------Lấy value discount trong Events----------
go
CREATE OR ALTER FUNCTION fn_getDiscountpercent (@idEvent int)
RETURNS Decimal (5,2)
AS
BEGIN
	DECLARE @a Decimal(5,2);
	SELECT @a= discount
	FROM Events WHERE id=@idEvent;
	return @a;
END
go


GO
--------------------TRIGGER ----------------------------------------

CREATE OR ALTER TRIGGER DELETEOrder on OrderDetail for Update
as
BEGIN
	Declare @idbill int, @idorder int, @olquant int, @nequant int;
	select @idbill= i.idBill ,@idorder= i.idOrder ,@olquant= d.quantity, @nequant=i.quantity from inserted as i, deleted as d;
	if(@idbill is not null and @idorder is not null and @olquant=@nequant)
		begin
		Update OrderDetail set idOrder=NULL where idOrder= @idOrder
		Delete from Orders where id=@idorder; 
		end
END 
GO


---------Thay đổi trạng thái bàn về emty sau khi xóa order-----------
CREATE OR ALTER TRIGGER tg_changestateseat on Orders for Delete
as
BEGIN
	Declare @idSeat int;
	 select @idSeat = idSeat
	 from deleted ;

	 Update Seats set state=1 where id=@idSeat;
END
GO


------BỔ SUNG

---TÌM KIẾM NHÂN VIÊN
--theo giới 
go

CREATE or ALTER PROC pro_searchEmployee (@key nvarchar (50), @condition nvarchar(20))
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

GO
CREATE OR ALTER proc isExistUsername(@username varchar(15))
as 
BEGIN

	SELECT userName From Employees
	where userName= @username;
END
GO

