CREATE DATABASE ShopThoiTrang
GO
USE ShopThoiTrang
GO

CREATE TABLE Product (
    ProductId   INT IDENTITY PRIMARY KEY,      -- Khóa chính, định danh sản phẩm
    SKU         VARCHAR(40) NOT NULL UNIQUE,   -- Mã sản phẩm nội bộ
    ProductName NVARCHAR(180) NOT NULL,        -- Tên sản phẩm hiển thị
    Slug        VARCHAR(120) NOT NULL UNIQUE,  -- Chuỗi URL thân thiện (không dấu)
    Description NVARCHAR(MAX) NULL,             -- Mô tả chi tiết sản phẩm
    BasePrice   DECIMAL(12,0) NOT NULL,         -- Giá gốc của sản phẩm
    IsActive    BIT NOT NULL DEFAULT 1,         -- Trạng thái bán (1 = đang bán)
    CreatedAt   DATETIME2 DEFAULT SYSUTCDATETIME() -- Ngày tạo
);

CREATE TABLE Size (
    SizeId INT IDENTITY PRIMARY KEY,
    SizeCode VARCHAR(10) NOT NULL UNIQUE, -- S, M, L, XL, 2XL, 3XL
    SortOrder INT NOT NULL
);

INSERT Size(SizeCode, SortOrder) VALUES
('S',1),('M',2),('L',3),('XL',4),('2XL',5),('3XL',6);

CREATE TABLE dbo.Color (
    ColorId INT IDENTITY PRIMARY KEY,
    ColorHex VARCHAR(30) UNIQUE, -- black, white
    ColorName NVARCHAR(50)
);

INSERT dbo.Color (ColorHex, ColorName) VALUES
('#000000', N'Đen'),
('#FFFFFF', N'Trắng'),
('#FF0000', N'Đỏ'),
('#0000FF', N'Xanh dương'),
('#00FF00', N'Xanh lá'),
('#F5DEB3', N'Be');


CREATE TABLE ProductVariant (
    VariantId INT IDENTITY PRIMARY KEY,         -- Khóa chính biến thể
    ProductId INT NOT NULL,                     -- FK tới bảng Product
    SizeId    INT NOT NULL,                     -- FK tới bảng Size
    ColorId   INT NOT NULL,                     -- FK tới bảng Color
    Price     DECIMAL(12,0) NOT NULL,            -- Giá theo size + màu
    Stock     INT NOT NULL DEFAULT 0,            -- Tồn kho của biến thể
    SKU       VARCHAR(50) UNIQUE,                -- Mã riêng cho biến thể

    CONSTRAINT FK_Variant_Product FOREIGN KEY(ProductId)
        REFERENCES dbo.Product(ProductId),

    CONSTRAINT FK_Variant_Size FOREIGN KEY(SizeId)
        REFERENCES dbo.Size(SizeId),

    CONSTRAINT FK_Variant_Color FOREIGN KEY(ColorId)
        REFERENCES dbo.Color(ColorId),

    CONSTRAINT UQ_ProductVariant UNIQUE(ProductId, SizeId, ColorId)
        -- Đảm bảo không trùng size + màu cho cùng 1 sản phẩm
);

CREATE TABLE CategoryGroup (
    GroupId     INT IDENTITY PRIMARY KEY,  -- Khóa chính
    GroupCode   VARCHAR(40) UNIQUE,        -- Mã nhóm (type, gender, style)
    GroupName   NVARCHAR(120),             -- Tên hiển thị
    SortOrder   INT DEFAULT 0,              -- Thứ tự hiển thị
    IsActive    BIT DEFAULT 1               -- Trạng thái sử dụng
);

CREATE TABLE Category (
    CategoryId INT IDENTITY PRIMARY KEY,   -- Khóa chính
    GroupId    INT NOT NULL,                -- FK tới CategoryGroup
    CatSlug    VARCHAR(60) UNIQUE,          -- Slug dùng cho URL / filter
    CatName    NVARCHAR(120),               -- Tên danh mục
    SortOrder  INT DEFAULT 0,                -- Thứ tự hiển thị
    IsActive   BIT DEFAULT 1,                -- Còn sử dụng hay không

    CONSTRAINT FK_Category_Group FOREIGN KEY(GroupId)
        REFERENCES dbo.CategoryGroup(GroupId)
);

CREATE TABLE ProductCategory (
    ProductId  INT NOT NULL,   -- FK tới Product
    CategoryId INT NOT NULL,   -- FK tới Category

    PRIMARY KEY(ProductId, CategoryId), -- Khóa chính kết hợp

    FOREIGN KEY(ProductId) REFERENCES dbo.Product(ProductId),
    FOREIGN KEY(CategoryId) REFERENCES dbo.Category(CategoryId)
);

CREATE TABLE AppUser (
    UserId          INT IDENTITY(1,1) PRIMARY KEY,
    Email           VARCHAR(120) NOT NULL UNIQUE,
    PasswordHash    VARCHAR(256) NOT NULL,
    FullName        NVARCHAR(120) NULL,
    Phone           VARCHAR(20) NULL,
    IsActive        BIT NOT NULL DEFAULT(1),
    CreatedAt       DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE dbo.Cart(
    CartId      INT IDENTITY(1,1) PRIMARY KEY,
    CartToken   VARCHAR(64) NOT NULL UNIQUE,   -- lưu ở cookie/Session cho khách chưa đăng nhập
    UserId      INT NULL,                      -- null nếu chưa đăng nhập
    CreatedAt   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Cart_User FOREIGN KEY(UserId) REFERENCES dbo.AppUser(UserId)
);
GO

CREATE TABLE CartItem (
    CartItemId INT IDENTITY PRIMARY KEY, -- Khóa chính
    CartId     INT NOT NULL,              -- FK tới Cart
    VariantId  INT NOT NULL,              -- Biến thể sản phẩm
    Quantity   INT CHECK (Quantity > 0),  -- Số lượng mua
    UnitPrice  DECIMAL(12,0) NOT NULL,    -- Giá tại thời điểm thêm vào giỏ

    FOREIGN KEY(CartId) REFERENCES dbo.Cart(CartId),
    FOREIGN KEY(VariantId) REFERENCES dbo.ProductVariant(VariantId)
);

CREATE TABLE CustomerAddress(
    AddressId   INT IDENTITY(1,1) PRIMARY KEY,
    UserId      INT NOT NULL,
    Line1       NVARCHAR(200) NOT NULL,
    Ward        NVARCHAR(100) NULL,
    District    NVARCHAR(100) NULL,
    Province    NVARCHAR(100) NULL,
    Note        NVARCHAR(200) NULL,
    CreatedAt   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_CustomerAddress_User FOREIGN KEY(UserId) REFERENCES AppUser(UserId)
);

CREATE TABLE [Order](
    OrderId         INT IDENTITY(1,1) PRIMARY KEY,
    OrderCode       VARCHAR(30) NOT NULL UNIQUE,
    UserId          INT NULL,                          -- có thể checkout guest
    CustomerName    NVARCHAR(120) NOT NULL,
    Phone           VARCHAR(20) NOT NULL,
    AddressLine     NVARCHAR(220) NULL,
    MessageCard     NVARCHAR(240) NULL,
    Status          VARCHAR(20) NOT NULL DEFAULT('PENDING'), -- PENDING/PAID/CANCELLED
    TotalAmount     DECIMAL(12,0) NOT NULL DEFAULT(0),
    CreatedAt       DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Order_User FOREIGN KEY(UserId) REFERENCES AppUser(UserId)
);

CREATE TABLE OrderItem (
    OrderItemId INT IDENTITY PRIMARY KEY,
    OrderId     INT NOT NULL,
    VariantId   INT NOT NULL,
    ProductName NVARCHAR(180),
    SizeName    NVARCHAR(50),
    ColorName   NVARCHAR(50),
    Quantity    INT,
    UnitPrice   DECIMAL(12,0),
    FOREIGN KEY(OrderId) REFERENCES [Order](OrderId)
);

CREATE TABLE [Role](
	Rid INT IDENTITY PRIMARY KEY,
	RName NVARCHAR(20)
);

CREATE TABLE UserRole (
    Rid INT,
    UserId INT,
    PRIMARY KEY (Rid, UserId),
    FOREIGN KEY (Rid) REFERENCES [Role](Rid),
    FOREIGN KEY (UserId) REFERENCES AppUser(UserId)
);


CREATE TABLE ProductImage(
    ImageId     INT IDENTITY(1,1) PRIMARY KEY,
    ProductId   INT NOT NULL,
    ImageUrl    NVARCHAR(260) NOT NULL,                
    IsPrimary   BIT NOT NULL DEFAULT(0),
    SortOrder   INT NOT NULL DEFAULT(0),
    CONSTRAINT FK_ProductImage_Product FOREIGN KEY(ProductId) REFERENCES dbo.Product(ProductId)
);

select * from CategoryGroup
insert into CategoryGroup values
('ao', N'Áo', 0, 1),
('quan', N'Quần', 1, 1),
('phu-kien', N'Phụ Kiện', 2, 1)

select * from Category
insert into Category values
(1,'ao-thun', N'Áo Thun',0, 1),
(1,'ao-so-mi', N'Áo Sơ Mi',1, 1),
(1,'ao-khoac', N'Áo Khoác',2, 1)

insert into Category values
(3,'non', N'Nón',0, 1),
(3,'vo', N'Vớ',1, 1)

insert into Category values
(2,'quan-short', N'Quần Short',0, 1),
(2,'quan-dai', N'Quần Dài',1, 1)

select * from Product
-- INSERT Product
delete Product
DBCC CHECKIDENT ('Product', RESEED, 0);
GO

INSERT Product VALUES
-- Áo thun
('P-001', N'Áo Thun Waffle', N'ao-thun-waffle-den', N'Thoáng Mát', 120650, 1, GETDATE()),
('P-002', N'Áo Thun Pique Seventy Seven 013 Đen',  N'ao-thun-Pique', N'Thoáng Mát',149150, 1, GETDATE()),
('P-003', N'Áo Thun Thể Thao Ultra Thin The Beginner 001 Đỏ Đậm', N'ao-thun-the-thao', N'Đẹp vãi ò',149150,  1, GETDATE()),
-- Áo sơ mi
('P-004', N'Áo Sơ Mi Trắng Tay Dài', 'ao-so-mi-trang', N'Sơ mi công sở', 299000, 1, GETDATE()),
('P-005', N'Áo Sơ Mi Xanh Nhạt', 'ao-so-mi-xanh', N'Sơ mi trẻ trung', 299000, 1, GETDATE()),
('P-006', N'Áo Sơ Mi Caro', 'ao-so-mi-caro', N'Sơ mi casual', 319000, 1, GETDATE()),
-- Áo khoác
('P-007', N'Áo Khoác Kaki', 'ao-khoac-kaki', N'Áo khoác nam', 499000, 1, GETDATE()),
('P-008', N'Áo Khoác Jean', 'ao-khoac-jean', N'Áo khoác jean', 549000, 1, GETDATE()),
('P-009', N'Áo Khoác Dù', 'ao-khoac-du', N'Áo khoác chống gió', 459000, 1, GETDATE()),
-- Nón
('P-010', N'Nón Lưỡi Trai Đen', 'non-luoi-trai-den', N'Nón thời trang', 159000, 1, GETDATE()),
('P-011', N'Nón Lưỡi Trai Trắng', 'non-luoi-trai-trang', N'Nón basic', 159000, 1, GETDATE()),
('P-012', N'Nón Bucket', 'non-bucket', N'Nón bucket thời trang', 179000, 1, GETDATE()),
-- Vớ
('P-013', N'Vớ Cổ Thấp', 'vo-co-thap', N'Vớ cotton', 49000, 1, GETDATE()),
('P-014', N'Vớ Cổ Cao', 'vo-co-cao', N'Vớ thể thao', 59000, 1, GETDATE()),
('P-015', N'Vớ Trơn Basic', 'vo-tron-basic', N'Vớ mặc hằng ngày', 45000, 1, GETDATE()),
-- Quần short
('P-016', N'Quần Short Kaki', 'quan-short-kaki', N'Quần short nam', 259000, 1, GETDATE()),
('P-017', N'Quần Short Jean', 'quan-short-jean', N'Quần short jean', 279000, 1, GETDATE()),
('P-018', N'Quần Short Thể Thao', 'quan-short-the-thao', N'Quần short vận động', 229000, 1, GETDATE()),
-- Quần dài
('P-019', N'Quần Jean Slimfit', 'quan-dai-jean', N'Quần jean nam', 399000, 1, GETDATE()),
('P-020', N'Quần Tây Công Sở', 'quan-dai-tay', N'Quần tây', 429000, 1, GETDATE()),
('P-021', N'Quần Jogger', 'quan-dai-jogger', N'Quần jogger nam', 349000, 1, GETDATE());
GO

-- INSERT ProductImage
delete ProductImage
DBCC CHECKIDENT ('ProductImage', RESEED, 0);
GO

INSERT INTO ProductImage (ProductId, ImageUrl, IsPrimary, SortOrder)
VALUES
--Thun
(1, 'ao-thun1.webp', 1, 0),
(2, 'ao-thun2.webp', 1, 0),
(3, 'ao-thun3.webp', 1, 0),
--Sơ mi
(4, 'so-mi1.webp', 1, 0),
(5, 'so-mi2.webp', 1, 0),
(6, 'so-mi3.webp', 1, 0),
-- Áo khoác
(7, 'khoac1.webp', 1, 1),
(8, 'khoac2.webp', 1, 1),
(9, 'khoac3.webp', 1, 1),
-- Nón
(10, 'non1.webp', 1, 1),
(11, 'non2.webp', 1, 1),
(12, 'non3.webp', 1, 1),
-- Vớ
(13, 'vo1.webp', 1, 1),
(14, 'vo2.webp', 1, 1),
(15, 'vo3.webp', 1, 1),
-- Quần short
(16, 'quan-short1.webp', 1, 1),
(17, 'quan-short2.jpg', 1, 1),
(18, 'quan-short3.webp', 1, 1),
-- Quần dài
(19, 'quan-dai1.webp', 1, 1),
(20, 'quan-dai2.webp', 1, 1),
(21, 'quan-dai3.webp', 1, 1);
GO

-- INSERT ProductVariant
delete ProductVariant
DBCC CHECKIDENT ('ProductVariant', RESEED, 0);
GO

-- ProductId 1–3: Áo Thun
INSERT INTO ProductVariant (ProductId, SizeId, ColorId, Price, Stock, SKU)
VALUES
(1, 1, 1, 120650, 50, 'P001-S-BLK'),
(1, 2, 1, 120650, 30, 'P001-M-BLK'),
(2, 1, 1, 149150, 40, 'P002-S-BLK'),
(2, 2, 1, 149150, 20, 'P002-M-BLK'),
(3, 1, 3, 149150, 50, 'P003-S-RED');

-- ProductId 4–6: Áo Sơ Mi
INSERT INTO ProductVariant (ProductId, SizeId, ColorId, Price, Stock, SKU)
VALUES
(4, 1, 2, 299000, 40, 'P004-S-WHT'),
(4, 2, 2, 299000, 30, 'P004-M-WHT'),
(5, 1, 5, 299000, 35, 'P005-S-GRN'),
(6, 2, 1, 319000, 20, 'P006-M-BLK');

-- ProductId 7–9: Áo Khoác
INSERT INTO ProductVariant (ProductId, SizeId, ColorId, Price, Stock, SKU)
VALUES
(7, 2, 1, 499000, 25, 'P007-M-BLK'),
(8, 2, 4, 549000, 20, 'P008-M-BLU'),
(9, 3, 6, 459000, 15, 'P009-L-BE');

-- ProductId 10–12: Nón
INSERT INTO ProductVariant (ProductId, SizeId, ColorId, Price, Stock, SKU)
VALUES
(10, 1, 1, 159000, 100, 'P010-ONE-BLK'),
(11, 1, 2, 159000, 80, 'P011-ONE-WHT'),
(12, 1, 6, 179000, 60, 'P012-ONE-BE');

-- ProductId 13–15: Vớ
INSERT INTO ProductVariant (ProductId, SizeId, ColorId, Price, Stock, SKU)
VALUES
(13, 1, 1, 49000, 200, 'P013-ONE-BLK'),
(14, 1, 4, 59000, 150, 'P014-ONE-BLU'),
(15, 1, 2, 45000, 180, 'P015-ONE-WHT');

-- ProductId 16–18: Quần Short
INSERT INTO ProductVariant (ProductId, SizeId, ColorId, Price, Stock, SKU)
VALUES
(16, 2, 1, 259000, 50, 'P016-M-BLK'),
(16, 3, 1, 259000, 30, 'P016-L-BLK'),
(17, 2, 1, 279000, 40, 'P017-M-BLK'),
(17, 3, 1, 279000, 20, 'P017-L-BLK'),
(18, 1, 1, 229000, 50, 'P018-S-BLK');

-- ProductId 19–21: Quần Dài
INSERT INTO ProductVariant (ProductId, SizeId, ColorId, Price, Stock, SKU)
VALUES
(19, 2, 1, 399000, 30, 'P019-M-BLK'),
(19, 3, 1, 399000, 20, 'P019-L-BLK'),
(20, 2, 1, 429000, 25, 'P020-M-BLK'),
(21, 3, 1, 349000, 15, 'P021-L-BLK');
GO


DELETE FROM ProductCategory;
GO

-- Áo Thun (CategoryId = 1)
INSERT INTO ProductCategory (ProductId, CategoryId) VALUES
(1, 1), (2, 1), (3, 1);

-- Áo Sơ Mi (CategoryId = 2)
INSERT INTO ProductCategory (ProductId, CategoryId) VALUES
(4, 2), (5, 2), (6, 2);

-- Áo Khoác (CategoryId = 3)
INSERT INTO ProductCategory (ProductId, CategoryId) VALUES
(7, 3), (8, 3), (9, 3);

-- Nón (CategoryId = 4)
INSERT INTO ProductCategory (ProductId, CategoryId) VALUES
(10, 4), (11, 4), (12, 4);

-- Vớ (CategoryId = 5)
INSERT INTO ProductCategory (ProductId, CategoryId) VALUES
(13, 5), (14, 5), (15, 5);

-- Quần Short (CategoryId = 6)
INSERT INTO ProductCategory (ProductId, CategoryId) VALUES
(16, 6), (17, 6), (18, 6);

-- Quần Dài (CategoryId = 7)
INSERT INTO ProductCategory (ProductId, CategoryId) VALUES
(19, 7), (20, 7), (21, 7);
GO
