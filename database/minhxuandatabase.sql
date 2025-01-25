﻿Go
use master
-- Tạo cơ sở dữ liệu
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'MinhXuanDatabase')
BEGIN
    -- Nếu cơ sở dữ liệu tồn tại, xóa nó
    ALTER DATABASE MinhXuanDatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE MinhXuanDatabase;
END
GO
CREATE DATABASE MinhXuanDatabase;
GO
USE MinhXuanDatabase;
GO

-- Tạo bảng Customers
CREATE TABLE Customers (
    CustomerId int PRIMARY KEY IDENTITY(1,1),      -- Khoá chính cho khách hàng
    FullName nvarchar(100) NOT NULL,               -- Tên đầy đủ của khách hàng
    Email nvarchar(100) NOT NULL UNIQUE,           -- Email của khách hàng, duy nhất
    IsEmailVerified bit NOT NULL DEFAULT 0,        -- Trạng thái xác minh email (0: chưa xác minh, 1: đã xác minh)
    PasswordHash varchar(150) NULL,                -- Mật khẩu của khách hàng (đã mã hoá)
    PhoneNumber varchar(10) NOT NULL,              -- Số điện thoại của khách hàng
    Address nvarchar(255) NULL,                    -- Địa chỉ của khách hàng
    DateOfBirth date NULL,                         -- Ngày sinh của khách hàng
    Gender bit NULL,                               -- Giới tính của khách hàng (0: Nữ, 1: Nam)
    CreatedAt datetime NOT NULL DEFAULT GETDATE(), -- Thời gian tạo khách hàng
    ImageUrl nvarchar(250) NULL,                   -- URL của ảnh đại diện khách hàng
    UpdateAt datetime NULL,                        -- Thời gian cập nhật khách hàng
    CONSTRAINT CHK_Gender CHECK (Gender IN (0, 1)) -- Kiểm tra giới tính chỉ có giá trị 0 hoặc 1
);
GO

-- Tạo bảng Employees
CREATE TABLE Employees (
    EmployeeId int primary key identity(1,1),                  -- Khoá chính cho nhân viên
    FullName nvarchar(100) not null,                           -- Tên đầy đủ của nhân viên
    Email nvarchar(100) not null unique,                       -- Email của nhân viên, duy nhất
    PasswordHash varchar(150) null,                            -- Mật khẩu của nhân viên (đã mã hoá)
    PhoneNumber varchar(10) not null,                          -- Số điện thoại của nhân viên
    Address nvarchar(255) null,                                -- Địa chỉ của nhân viên
    DateOfBirth date null,                                     -- Ngày sinh của nhân viên
    Gender bit null,                                           -- Giới tính của nhân viên
    Role nvarchar(100) not null,                               -- Vai trò của nhân viên (Admin, Manager, etc.)
    CreateAt dateTime not null default getdate(),              -- Thời gian tạo nhân viên
    UpdateAt datetime null,                                    -- Thời gian cập nhật nhân viên
    Status nvarchar(100) not null default 'Active',            -- Trạng thái nhân viên (Active, Inactive)
    CONSTRAINT CHK_Status CHECK (Status IN ('Active', 'Inactive', 'Suspended')), -- Ràng buộc cho trạng thái
    CONSTRAINT CHK_Role Check (Role in ('Admin','Manager'))                      -- Ràng buộc cho vai trò
);
GO

-- Tạo bảng Category
CREATE TABLE Category (
    CategoryId int primary key identity(1,1),  -- Khoá chính cho danh mục sản phẩm
    CategoryName nvarchar(100) not null,       -- Tên danh mục
    Description nvarchar(500) not null         -- Mô tả danh mục
);
GO

-- Tạo bảng Products
CREATE TABLE Products (
    ProductId int primary key identity(1,1),         -- Khoá chính cho sản phẩm
    ProductName nvarchar(250) not null,              -- Tên sản phẩm
	CategoryId int null,                             -- loại sản phẩm
    Description nvarchar(max) null,                  -- Mô tả sản phẩm
	Material nvarchar(250) NULL,                     -- Chất liệu, cho phép giá trị
    Origin nvarchar(250) NULL,                       -- Xuất xứ, cho phép giá trị
    Quantity int  null,                              -- Số lượng sản phẩm có sẵn
    Price decimal(18,2) not null,                    -- Giá sản phẩm
    Discount decimal(5,2) null default 0.00,         -- Giảm giá của sản phẩm
	AverageRating decimal(3,2) NULL,                 -- Trung bình Rating
    CreatedAt datetime not null default getdate(),   -- Thời gian tạo sản phẩm
    UpdatedAt datetime null,                         -- Thời gian cập nhật sản phẩm
    Status bit not null default 1,                   -- Trạng thái sản phẩm (1: Còn bán, 0: Ngừng bán)
    CONSTRAINT FK_Products_Category FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId) 
);
GO

-- Tạo bảng ProductReviews
CREATE TABLE ProductReviews (
    ReviewId int primary key identity(1,1),                  -- Khoá chính cho đánh giá sản phẩm
    ProductId int not null,                                  -- Mã sản phẩm
    CustomerId int not null,                                 -- Mã khách hàng
    Rating int not null check (Rating >= 1 and Rating <= 5), -- Điểm đánh giá từ 1 đến 5 sao
    Comment nvarchar(max) null,                              -- Bình luận về sản phẩm
    CreatedAt datetime not null default getdate(),           -- Thời gian tạo đánh giá
    UpdatedAt datetime null,                                 -- Thời gian cập nhật đánh giá
    CONSTRAINT FK_ProductReviews_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE,   -- Khoá ngoại tới bảng Products
    CONSTRAINT FK_ProductReviews_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId) ON DELETE CASCADE -- Khoá ngoại tới bảng Customers
);
GO

-- Tạo bảng ProductImage
CREATE TABLE ProductImage (
    ProductImageId int primary key identity(1,1),  -- Khoá chính cho hình ảnh sản phẩm
    ProductId int not null,                        -- Mã sản phẩm
    FileName nvarchar(250) not null unique,        -- Tên tệp hình ảnh
    ImageURL nvarchar(max) null,                   -- URL của hình ảnh sản phẩm
    Description nvarchar(250) null,                -- Mô tả về hình ảnh
    CreatedAt datetime not null default getdate(), -- Thời gian tạo hình ảnh
    UpdatedAt datetime null,                       -- Thời gian cập nhật hình ảnh
    IsPrimary bit not null default 0,              -- Ảnh chính của sản phẩm (0: không, 1: có)
    Status bit not null default 1,                 -- Trạng thái hình ảnh (1: hoạt động, 0: không hoạt động)
    CONSTRAINT FK_ProductImage_Product FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE,
	UNIQUE (ProductId, IsPrimary)
);
GO

-- Tạo bảng ProductVariants
CREATE TABLE ProductVariants (
    VariantId int PRIMARY KEY IDENTITY(1,1),              -- Khoá chính cho các biến thể của sản phẩm
    ProductId int NOT NULL,                               -- Mã sản phẩm
    Size nvarchar(50) NULL,                               -- Kích thước của sản phẩm (nếu có)
    Color nvarchar(50) NULL,                              -- Màu sắc của sản phẩm (nếu có)
    Quantity int NOT NULL,                                -- Số lượng của biến thể này
    Price decimal(18,2) NULL,                             -- Giá của biến thể sản phẩm này (có thể khác so với giá mặc định)
    Discount decimal(5,2) NULL DEFAULT 0.00,              -- Giảm giá của biến thể (nếu có)
    Status bit NOT NULL DEFAULT 1,                        -- Trạng thái biến thể (1: Còn bán, 0: Ngừng bán)
    CreatedAt datetime NOT NULL DEFAULT GETDATE(),        -- Thời gian tạo biến thể
    UpdatedAt datetime NULL,                              -- Thời gian cập nhật biến thể
    CONSTRAINT FK_ProductVariants_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE
);
GO

-- Tạo bảng Orders
CREATE TABLE Orders (
    OrderId int primary key identity(1,1),          -- Khoá chính cho đơn hàng
    CustomerId int not null,                        -- Mã khách hàng
    TotalAmount decimal(18,2) not null,             -- Tổng giá trị đơn hàng
    Status varchar(50) not null default 'Pending',  -- Trạng thái đơn hàng (Pending, Completed, etc.)
    OrderDate datetime not null default getdate(),  -- Ngày tạo đơn hàng
    UpdatedAt datetime null,                        -- Thời gian cập nhật đơn hàng
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) REFERENCES Customers(CustomerId) ON DELETE CASCADE -- Khoá ngoại tới bảng Customers
);
GO

-- Tạo bảng OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailId int PRIMARY KEY IDENTITY(1,1),      -- Khoá chính cho chi tiết đơn hàng
    OrderId int NOT NULL,                             -- Mã đơn hàng
    ProductId int NOT NULL,                           -- Mã sản phẩm
    ProductVariantId int NULL,                    -- Mã biến thể sản phẩm (có thể là size hoặc màu sắc)
    ProductName nvarchar(250) NOT NULL,               -- Tên sản phẩm tại thời điểm mua
    ProductPrice decimal(18,2) NOT NULL,              -- Giá sản phẩm tại thời điểm mua
    ProductDiscount decimal(5,2) NULL DEFAULT 0.00,   -- Giảm giá sản phẩm tại thời điểm mua
    Quantity int NOT NULL,                            -- Số lượng sản phẩm trong đơn hàng
    TotalPrice decimal(18,2) NOT NULL,                -- Tổng giá trị của sản phẩm trong đơn hàng
    Size nvarchar(50) NULL,                           -- Kích thước của sản phẩm
    Color nvarchar(50) NULL,                          -- Màu sắc của sản phẩm
    CreatedAt datetime NOT NULL DEFAULT GETDATE(),    -- Thời gian tạo chi tiết đơn hàng
	UpdatedAt datetime NULL,                          -- Thời gian cập nhật chi tiết đơn hàng
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE,  -- Ràng buộc khoá ngoại tới bảng Orders
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductId) REFERENCES Products(ProductId) ON DELETE CASCADE, -- Ràng buộc khoá ngoại tới bảng Products
    CONSTRAINT FK_OrderDetails_ProductVariants FOREIGN KEY (ProductVariantId) REFERENCES ProductVariants(VariantId)  -- Khoá ngoại tới bảng ProductVariants
);
GO

-- Tạo bảng Receipts (Biên lai thanh toán qua API)
CREATE TABLE Invoices (
    ReceiptId int primary key identity(1,1),        -- Khoá chính cho biên lai
    OrderId int not null,                           -- Mã đơn hàng
    ReceiptNumber nvarchar(50) not null unique,     -- Số biên lai
    Amount decimal(18,2) not null,                  -- Số tiền thanh toán
    PaymentMethod nvarchar(50) not null,            -- Phương thức thanh toán (Cash, Card, VNPay, etc.)
    QRCodeData nvarchar(max) null,                  -- Dữ liệu mã QR (số tài khoản + giá tiền)
    PaymentStatus nvarchar(50) not null,            -- Trạng thái thanh toán (Pending, Completed, Failed)
    CreatedAt datetime not null default getdate(),  -- Thời gian tạo biên lai
    Status varchar(50) not null default 'Unpaid',     -- Trạng thái biên lai (Paid, Unpaid)
    CONSTRAINT FK_Receipts_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE -- Khoá ngoại tới bảng Orders
);
GO

-- Tạo bảng BlogPosts
CREATE TABLE BlogPosts (
    PostId int primary key identity(1,1),              -- Khoá chính cho bài viết
    Title nvarchar(255) not null,                      -- Tiêu đề bài viết
    Content nvarchar(max) not null,                    -- Nội dung bài viết
    CreatedAt datetime not null default getdate(),     -- Thời gian tạo bài viết
    UpdatedAt datetime null,                           -- Thời gian cập nhật bài viết
	FileName nvarchar(250) null,                       -- Tên file của ảnh
	ImageURL nvarchar(max) null,                       -- URL của hình ảnh bài viết
    Status varchar(50) not null default 'Draft'        -- Trạng thái bài viết (Draft, Published)
);
GO

-- Tạo bảng AccountVerifications
CREATE TABLE AccountVerifications (
    VerificationId int PRIMARY KEY IDENTITY(1,1),       -- Khoá chính cho xác minh
    AccountId int NOT NULL,                             -- Mã tài khoản (khách hàng hoặc nhân viên)
    AccountType nvarchar(50) NOT NULL CHECK (AccountType IN ('Customer', 'Employee')), -- Loại tài khoản (Customer hoặc Employee)
    VerificationCode nvarchar(100) NOT NULL,            -- Mã xác minh
    IsVerified bit NOT NULL DEFAULT 0,                  -- Trạng thái xác minh (0: chưa xác minh, 1: đã xác minh)
    VerificationDate datetime NULL,                     -- Thời gian xác minh
    CreatedAt datetime NOT NULL DEFAULT GETDATE(),      -- Thời gian tạo yêu cầu xác minh
    UpdatedAt datetime NULL,                            -- Thời gian cập nhật thông tin xác minh
    CONSTRAINT FK_AccountVerifications_Customers FOREIGN KEY (AccountId) REFERENCES Customers(CustomerId) ON DELETE CASCADE, -- Khoá ngoại tới bảng Customers
    CONSTRAINT FK_AccountVerifications_Employees FOREIGN KEY (AccountId) REFERENCES Employees(EmployeeId) ON DELETE CASCADE -- Khoá ngoại tới bảng Employees
);
GO

-- Tạo bảng Notifications
CREATE TABLE Notifications (
    NotificationId int PRIMARY KEY IDENTITY(1,1),    -- Khoá chính cho thông báo
    Title nvarchar(255) NOT NULL,                    -- Tiêu đề thông báo
    Message nvarchar(max) NOT NULL,                  -- Nội dung thông báo
    RecipientId int NOT NULL,                        -- Mã người nhận (khách hàng hoặc nhân viên)
    RecipientType nvarchar(50) NOT NULL CHECK (RecipientType IN ('Customer', 'Employee')),  -- Loại người nhận (Customer hoặc Employee)
    IsRead bit NOT NULL DEFAULT 0,                   -- Trạng thái đọc của thông báo (0: chưa đọc, 1: đã đọc)
    CreatedAt datetime NOT NULL DEFAULT GETDATE(),   -- Thời gian tạo thông báo
    UpdatedAt datetime NULL,                         -- Thời gian cập nhật thông báo
    Status varchar(50) NOT NULL DEFAULT 'Active',    -- Trạng thái thông báo (Active, Inactive)
    CONSTRAINT FK_Notifications_Customers FOREIGN KEY (RecipientId) REFERENCES Customers(CustomerId) ON DELETE CASCADE, -- Khoá ngoại tới bảng Customers
    CONSTRAINT FK_Notifications_Employees FOREIGN KEY (RecipientId) REFERENCES Employees(EmployeeId) ON DELETE CASCADE  -- Khoá ngoại tới bảng Employees
);
GO

-- Tự động update averageRating
CREATE TRIGGER UpdateAverageRatingProduct
ON ProductReviews
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Products
    SET AverageRating = (
        SELECT AVG(CAST(Rating AS decimal(3,2)))
        FROM ProductReviews
        WHERE ProductReviews.ProductId = Products.ProductId
    )
    WHERE Products.ProductId IN (SELECT ProductId FROM inserted UNION SELECT ProductId FROM deleted);
END;
GO
-- Tự động update Quanlity khi thêm mới ,cập nhật,xóa biến thể của product
CREATE TRIGGER UpdateQualityProduct
On ProductVariants
AFTER INSERT,UPDATE,DELETE
AS BEGIN 
       SET NOCOUNT ON;
	   UPDATE Products
	   SET Quantity = (
	       SELECT SUM(Quantity)
		   FROM ProductVariants
		   WHERE ProductVariants.ProductId = Products.ProductId
	   )
	   WHERE Products.ProductId IN(SELECT ProductId from inserted UNION SELECT ProductId from deleted);
END;
GO
