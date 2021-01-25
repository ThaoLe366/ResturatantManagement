----7:48 3-12-2020 chỉnh sửa bởi Hoàng

CREATE DATABASE ManagementRestaurant
GO

USE ManagementRestaurant
GO

CREATE TABLE Events
(
	id INT identity(1,1) PRIMARY KEY,
	name NVARCHAR(100) NOT NULL,
	startDate DATE NOT NULL,
	endDate DATE NOT NULL,
	discount DECIMAL(5,2) NOT NULL
)
CREATE TABLE Customers
(
	id INT identity(1,1) PRIMARY KEY,
	phone VARCHAR(12),
	name nvarchar(30) NOT NULL,
	point INT NOT NULL DEFAULT 0
)
CREATE TABLE Employees
(
	id INT identity(1,1) PRIMARY KEY,
	idMan INT,
	userName VARCHAR(15) NOT NULL,
	passWord VARCHAR(15) NOT NULL,
	name nvarchar(30) NOT NULL,
	sex char(1) NOT NULL,
	phone VARCHAR(12) NOT NULL,
	address NVARCHAR(100) NOT NULL,
	salary INT,
	level bit DEFAULT 0,--1 là nhân viên, 0 là chủ
	state bit DEFAULT 0,--1Là còn làm việc,0 là đã thôi việc,
	CONSTRAINT fk_Emp_id_Emp FOREIGN KEY(id) REFERENCES dbo.Employees(id)
)
CREATE TABLE TypeFoods
(
	id INT identity(1,1) PRIMARY KEY,
	name NVARCHAR(30) NOT NULL,
	state bit
)
CREATE TABLE Dishes
(
	id INT identity(1,1) PRIMARY KEY,
	name NVARCHAR(30) NOT NULL,
	price INT NOT NULL,
	idType INT not null,
	state NVARCHAR(15) NOT NULL,
	image NVARCHAR(100) DEFAULT 'dish.png',
	--CONSTRAINT fk_Dis_Type FOREIGN KEY(id) REFERENCES dbo.TypeFoods(id)
)

CREATE TABLE Area
(
	id INT primary key,
	name NVARCHAR(50),
	quantily NVARCHAR(50),
)


CREATE TABLE Seats
(
	id INT identity(1,1) PRIMARY KEY,
	state int default 1 not null,
	idArea INT not null,
	bookingTime datetime
	CONSTRAINT fk_idArea FOREIGN KEY(idArea) REFERENCES dbo.Area(id)
)
CREATE TABLE Orders
(
	id INT identity(1,1) PRIMARY KEY,
	idSeat INT,
	idEmp INT,
	idCus INT,
	timeOrder DATETIME NOT NULL,
	CONSTRAINT fk_Ord_Seat FOREIGN KEY(idSeat) REFERENCES dbo.Seats(id),
	CONSTRAINT fk_Ord_Emp FOREIGN KEY(idEmp) REFERENCES dbo.Employees(id),
	CONSTRAINT fk_Ord_Cus FOREIGN KEY(idCus) REFERENCES dbo.Customers(id)
)

CREATE TABLE Bill
(
	id INT identity(1,1) PRIMARY KEY,
	timeCheckOut DATETIME,--là thời gian thanh toán đối với hóa đơn thanh toán hoặc thời gian hủy đối với order bị hủy
	deal INT,--với hóa đơn bị hủy thì cột này null
	totalCost INT,
	idEmp INT,
	idCus INT,
	state BIT,--có 2 trạng thái là đã thanh toán hoặc bị hủy
	loyalFriend INT NOT NULL DEFAULT 0,
	---Mới  thêm bởi Hoàng
	--CONSTRAINT fk_OrderDetail_idBill FOREIGN KEY(id) REFERENCES dbo.OrderDetail(idBill),
	CONSTRAINT fk_Bill_Even FOREIGN KEY(deal) REFERENCES dbo.Events(id),
	CONSTRAINT fk_Can_Emp FOREIGN KEY(idEmp) REFERENCES dbo.Employees(id),
	CONSTRAINT fk_Can_Cus FOREIGN KEY(idCus) REFERENCES dbo.Customers(id)
	--phần dưới đây là cho order bị hủy
)

CREATE TABLE OrderDetail
(
	id INT identity(1,1) PRIMARY KEY,
	idOrder int,--Hoang them
	idBill int ,
	idDish INT,
	quantity INT NOT NULL DEFAULT 1,
	price INT NOT NULL DEFAULT 0,
	CONSTRAINT fk_OrderDetail_idOrder FOREIGN KEY(idOrder) REFERENCES dbo.Orders(id) ON DELETE SET NULL, --Hoang them
	CONSTRAINT fk_OrderDetail_idBill FOREIGN KEY(idBill) REFERENCES dbo.Bill(id), 
	CONSTRAINT fk_OrdDetail_Dis FOREIGN KEY(idDish) REFERENCES dbo.Dishes(id)
)



Create Table Revenue
(
	id INT identity,
	statisticDate Date Not Null Default Cast(getDate() as Date),
	sumRevenue INT NOT nULL DEFAULT 0,
	numCancel int NOT nULL DEFAULT 0,
	numBill int NOT nULL DEFAULT 0,
	numBooking int NOT nULL DEFAULT 0,
    PRIMARY KEY(id)
)

