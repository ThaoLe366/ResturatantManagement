USE [ManagementRestaurant1]
GO
SET IDENTITY_INSERT [dbo].[Events] ON 

INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (1, N'', CAST(N'2020-12-17' AS Date), CAST(N'2020-12-17' AS Date), CAST(3.30 AS Decimal(5, 2)))
INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (2, N'', CAST(N'2020-12-17' AS Date), CAST(N'2020-12-17' AS Date), CAST(3.30 AS Decimal(5, 2)))
INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (3, N'black friday', CAST(N'2020-12-11' AS Date), CAST(N'2020-12-24' AS Date), CAST(67.00 AS Decimal(5, 2)))
INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (4, N'black friday', CAST(N'2020-12-11' AS Date), CAST(N'2020-12-24' AS Date), CAST(67.00 AS Decimal(5, 2)))
INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (5, N'black friday', CAST(N'2020-12-11' AS Date), CAST(N'2020-12-24' AS Date), CAST(67.00 AS Decimal(5, 2)))
INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (7, N'black fridayaa', CAST(N'2020-12-11' AS Date), CAST(N'2020-12-24' AS Date), CAST(67.00 AS Decimal(5, 2)))
INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (8, N'black fridayaa', CAST(N'2020-12-11' AS Date), CAST(N'2020-12-24' AS Date), CAST(67.00 AS Decimal(5, 2)))
INSERT [dbo].[Events] ([id], [name], [startDate], [endDate], [discount]) VALUES (9, N'black fridayaa', CAST(N'2020-12-11' AS Date), CAST(N'2020-12-24' AS Date), CAST(67.00 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[Events] OFF
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([id], [phone], [name], [point]) VALUES (1, N'036675757', N'Le Van A', 300)
INSERT [dbo].[Customers] ([id], [phone], [name], [point]) VALUES (2, N'0898787', N'Le Van B', 45)
INSERT [dbo].[Customers] ([id], [phone], [name], [point]) VALUES (3, N'0898787', N'Le Van B', 45)
INSERT [dbo].[Customers] ([id], [phone], [name], [point]) VALUES (4, N'0898787', N'Le Van B', 45)
INSERT [dbo].[Customers] ([id], [phone], [name], [point]) VALUES (5, N'0898787', N'Le Van A', 45)
INSERT [dbo].[Customers] ([id], [phone], [name], [point]) VALUES (6, N'23', N'Le Van A', 45)
INSERT [dbo].[Customers] ([id], [phone], [name], [point]) VALUES (7, N'2321323', N'Le Van A', 45)
SET IDENTITY_INSERT [dbo].[Customers] OFF
SET IDENTITY_INSERT [dbo].[Dishes] ON 

INSERT [dbo].[Dishes] ([id], [name], [price], [idType], [state], [image]) VALUES (1, N'Gà xối mỡ', 30000, 1, N'1', N'dish.png')
INSERT [dbo].[Dishes] ([id], [name], [price], [idType], [state], [image]) VALUES (2, N'Bún bò', 25000, 2, N'1', N'dish.png')
INSERT [dbo].[Dishes] ([id], [name], [price], [idType], [state], [image]) VALUES (9, N'as', 33330, 2, N'1', N'')
INSERT [dbo].[Dishes] ([id], [name], [price], [idType], [state], [image]) VALUES (10, N'Gà xối mỡ', 30000, 1, N'1', N'')
INSERT [dbo].[Dishes] ([id], [name], [price], [idType], [state], [image]) VALUES (11, N'Cơm cá chiên', 30000, 5, N'1', N'')
INSERT [dbo].[Dishes] ([id], [name], [price], [idType], [state], [image]) VALUES (12, N'Cơm cá chiên', 30000, 5, N'False', N'')
SET IDENTITY_INSERT [dbo].[Dishes] OFF
SET IDENTITY_INSERT [dbo].[TypeFoods] ON 

INSERT [dbo].[TypeFoods] ([id], [name]) VALUES (1, N'Cơm')
INSERT [dbo].[TypeFoods] ([id], [name]) VALUES (2, N'Bún')
INSERT [dbo].[TypeFoods] ([id], [name]) VALUES (3, N'Phở')
INSERT [dbo].[TypeFoods] ([id], [name]) VALUES (4, N'Che')
INSERT [dbo].[TypeFoods] ([id], [name]) VALUES (5, N'Nuoc')
SET IDENTITY_INSERT [dbo].[TypeFoods] OFF
