-- =====================================================
-- HỆ QUẢN TRỊ CƠ SỞ DỮ LIỆU
-- ĐỀ TÀI: WEBSITE BÁN PHỤ KIỆN THỜI TRANG
-- HOÀN CHỈNH: Bao gồm bảng Đánh Giá và đầy đủ tính năng
-- =====================================================

-- Tạo database
CREATE DATABASE PHUKIEN_THOITRANG;
GO

USE PHUKIEN_THOITRANG;
GO

-- =====================================================
-- PHẦN 1: TẠO CÁC BẢNG
-- =====================================================

-- Bảng NHA_CUNG_CAP
CREATE TABLE NHA_CUNG_CAP (
    MaNCC VARCHAR(10) PRIMARY KEY,
    TenNCC NVARCHAR(200) NOT NULL,
    DiaChi NVARCHAR(255),
    SDT VARCHAR(15),
    Email VARCHAR(100),
    NguoiLienHe NVARCHAR(100),
    GhiChu NVARCHAR(255),
    TrangThai BIT DEFAULT 1
);

-- Bảng LOAI_SAN_PHAM
CREATE TABLE LOAI_SAN_PHAM (
    MaLoai VARCHAR(10) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(255),
    TrangThai BIT DEFAULT 1
);

-- Bảng MAU_SAC
CREATE TABLE MAU_SAC (
    MaMau VARCHAR(10) PRIMARY KEY,
    TenMau NVARCHAR(50) NOT NULL,
    MaHex VARCHAR(7),
    TrangThai BIT DEFAULT 1
);

-- Bảng KICH_THUOC
CREATE TABLE KICH_THUOC (
    MaSize VARCHAR(10) PRIMARY KEY,
    TenSize VARCHAR(20) NOT NULL,
    MoTa NVARCHAR(100),
    TrangThai BIT DEFAULT 1
);

-- Bảng NHAN_VIEN
CREATE TABLE NHAN_VIEN (
    MaNV VARCHAR(10) PRIMARY KEY,
    TenNV NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SDT VARCHAR(15),
    Email VARCHAR(100),
    DiaChi NVARCHAR(255),
    ChucVu NVARCHAR(50),
    NgayVaoLam DATE,
    Luong DECIMAL(10,2),
    TrangThai BIT DEFAULT 1
);

-- Bảng KHACH_HANG
CREATE TABLE KHACH_HANG (
    MaKH VARCHAR(10) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15) NOT NULL,
    Email VARCHAR(100),
    DiaChi NVARCHAR(255),
    NgayDangKy DATE DEFAULT GETDATE(),
    DiemTichLuy INT DEFAULT 0,
    TrangThai BIT DEFAULT 1
);

-- Bảng SAN_PHAM (ĐÃ XÓA HinhAnh)
CREATE TABLE SAN_PHAM (
    MaSP VARCHAR(10) PRIMARY KEY,
    TenSP NVARCHAR(200) NOT NULL,
    MaLoai VARCHAR(10),
    MoTa NVARCHAR(500),
    GiaBan DECIMAL(10,2) NOT NULL CHECK (GiaBan > 0),
    TrangThai BIT DEFAULT 1,
    FOREIGN KEY (MaLoai) REFERENCES LOAI_SAN_PHAM(MaLoai)
);

-- Bảng CHI_TIET_SAN_PHAM
CREATE TABLE CHI_TIET_SAN_PHAM (
    MaCTSP VARCHAR(30) PRIMARY KEY,
    MaSP VARCHAR(10) NOT NULL,
    MaMau VARCHAR(10),
    MaSize VARCHAR(10),
    SoLuongTon INT DEFAULT 0 CHECK (SoLuongTon >= 0),
    GiaNhap DECIMAL(10,2),
    TrangThai BIT DEFAULT 1,
    FOREIGN KEY (MaSP) REFERENCES SAN_PHAM(MaSP),
    FOREIGN KEY (MaMau) REFERENCES MAU_SAC(MaMau),
    FOREIGN KEY (MaSize) REFERENCES KICH_THUOC(MaSize),
    UNIQUE(MaSP, MaMau, MaSize)
);

-- Bảng HINH_ANH_SAN_PHAM
CREATE TABLE HINH_ANH_SAN_PHAM (
    MaHinhAnh INT IDENTITY(1,1) PRIMARY KEY,
    MaSP VARCHAR(10) NOT NULL,               
    DuongDan VARCHAR(255) NOT NULL,          
    TenHinhAnh NVARCHAR(255),                                                                         
    TrangThai BIT DEFAULT 1,                 
    FOREIGN KEY (MaSP) REFERENCES SAN_PHAM(MaSP) ON DELETE CASCADE
);

-- Bảng PHIEU_NHAP_HANG
CREATE TABLE PHIEU_NHAP_HANG (
    MaPhieuNhap VARCHAR(15) PRIMARY KEY,
    MaNCC VARCHAR(10),
    MaNV VARCHAR(10),
    NgayNhap DATE NOT NULL DEFAULT GETDATE(),
    TongTien DECIMAL(12,2) DEFAULT 0,
    GhiChu NVARCHAR(255),
    TrangThai BIT DEFAULT 1,
    FOREIGN KEY (MaNCC) REFERENCES NHA_CUNG_CAP(MaNCC),
    FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN(MaNV)
);

-- Bảng CHI_TIET_PHIEU_NHAP
CREATE TABLE CHI_TIET_PHIEU_NHAP (
    MaPhieuNhap VARCHAR(15),
    MaCTSP VARCHAR(30),
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGiaNhap DECIMAL(10,2) NOT NULL CHECK (DonGiaNhap > 0),
    ThanhTien DECIMAL(12,2),
    PRIMARY KEY (MaPhieuNhap, MaCTSP),
    FOREIGN KEY (MaPhieuNhap) REFERENCES PHIEU_NHAP_HANG(MaPhieuNhap),
    FOREIGN KEY (MaCTSP) REFERENCES CHI_TIET_SAN_PHAM(MaCTSP)
);

-- Bảng PHIEU_BAN_HANG
CREATE TABLE PHIEU_BAN_HANG (
    MaPhieuBan VARCHAR(15) PRIMARY KEY,
    MaKH VARCHAR(10),
    MaNV VARCHAR(10),
    NgayBan DATE NOT NULL DEFAULT GETDATE(),
    TongTien DECIMAL(12,2) DEFAULT 0,
    GiamGia DECIMAL(10,2) DEFAULT 0,
    ThanhToan DECIMAL(12,2),
    PhuongThucTT NVARCHAR(50),
    TrangThai NVARCHAR(30) DEFAULT N'Chờ xử lý',
    GhiChu NVARCHAR(255),
    FOREIGN KEY (MaKH) REFERENCES KHACH_HANG(MaKH),
    FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN(MaNV)
);

-- Bảng CHI_TIET_PHIEU_BAN
CREATE TABLE CHI_TIET_PHIEU_BAN (
    MaPhieuBan VARCHAR(15),
    MaCTSP VARCHAR(30),
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(10,2) NOT NULL CHECK (DonGia > 0),
    ThanhTien DECIMAL(12,2),
    PRIMARY KEY (MaPhieuBan, MaCTSP),
    FOREIGN KEY (MaPhieuBan) REFERENCES PHIEU_BAN_HANG(MaPhieuBan),
    FOREIGN KEY (MaCTSP) REFERENCES CHI_TIET_SAN_PHAM(MaCTSP)
);

-- Bảng DANH_GIA
CREATE TABLE DANH_GIA (
    MaDanhGia INT IDENTITY(1,1) PRIMARY KEY,
    MaSP VARCHAR(10) NOT NULL,
    MaKH VARCHAR(10) NOT NULL,
    DiemDanhGia INT CHECK (DiemDanhGia BETWEEN 1 AND 5),
    TieuDe NVARCHAR(200),
    NoiDung NVARCHAR(1000),
    NgayDanhGia DATETIME DEFAULT GETDATE(),
    TrangThai BIT DEFAULT 1,
    PhanHoiTuShop NVARCHAR(500),
    NgayPhanHoi DATETIME,
    DaMuaHang BIT DEFAULT 1,
    FOREIGN KEY (MaSP) REFERENCES SAN_PHAM(MaSP),
    FOREIGN KEY (MaKH) REFERENCES KHACH_HANG(MaKH)
);

-- Bổ sung bảng quản lý tài khoản đăng nhập liên kết với nhân viên
CREATE TABLE TAI_KHOAN (
    TenDangNhap VARCHAR(50) PRIMARY KEY,
    MatKhau VARCHAR(100) NOT NULL, -- Nên lưu mã hóa MD5/SHA
    MaNV VARCHAR(10) NOT NULL,
    QuyenHan NVARCHAR(20) DEFAULT N'NhanVien', -- Ví dụ: 'Admin', 'NhanVien'
    TrangThai BIT DEFAULT 1,
    FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN(MaNV)
);

-- =====================================================
-- PHẦN 2: TẠO TRIGGER
-- =====================================================

GO
-- Trigger 1: TỰ ĐỘNG TẠO MaCTSP
CREATE TRIGGER trg_taoma_chitietsanpham
ON CHI_TIET_SAN_PHAM
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        WHERE NOT EXISTS (SELECT 1 FROM SAN_PHAM WHERE MaSP = i.MaSP)
    )
    BEGIN
        RAISERROR(N'Mã sản phẩm không tồn tại!', 16, 1);
        RETURN;
    END
    
    INSERT INTO CHI_TIET_SAN_PHAM (MaCTSP, MaSP, MaMau, MaSize, SoLuongTon, GiaNhap, TrangThai)
    SELECT 
        i.MaSP + '-' + 
        ISNULL(i.MaMau, 'NULL') + '-' + 
        ISNULL(i.MaSize, 'NULL') AS MaCTSP,
        i.MaSP,
        i.MaMau,
        i.MaSize,
        ISNULL(i.SoLuongTon, 0),
        i.GiaNhap,
        ISNULL(i.TrangThai, 1)
    FROM inserted i;
END;
GO

-- Trigger 2: Kiểm tra tồn kho VÀ tính thành tiền khi bán hàng
CREATE TRIGGER trg_chi_tiet_phieu_ban_insert
ON CHI_TIET_PHIEU_BAN
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN CHI_TIET_SAN_PHAM ctsp ON i.MaCTSP = ctsp.MaCTSP
        WHERE ctsp.SoLuongTon < i.SoLuong
    )
    BEGIN
        RAISERROR(N'Không đủ hàng trong kho!', 16, 1);
        RETURN;
    END
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN CHI_TIET_SAN_PHAM ctsp ON i.MaCTSP = ctsp.MaCTSP
        INNER JOIN SAN_PHAM sp ON ctsp.MaSP = sp.MaSP
        WHERE sp.TrangThai = 0 OR ctsp.TrangThai = 0
    )
    BEGIN
        RAISERROR(N'Sản phẩm không còn bán hoặc đã bị ẩn!', 16, 1);
        RETURN;
    END
    
    INSERT INTO CHI_TIET_PHIEU_BAN (MaPhieuBan, MaCTSP, SoLuong, DonGia, ThanhTien)
    SELECT 
        MaPhieuBan, 
        MaCTSP, 
        SoLuong, 
        DonGia,
        SoLuong * DonGia AS ThanhTien
    FROM inserted;
END;
GO

-- Trigger 3: Giảm tồn kho khi bán hàng
CREATE TRIGGER trg_giam_ton_kho
ON CHI_TIET_PHIEU_BAN
AFTER INSERT
AS
BEGIN
    UPDATE ctsp
    SET ctsp.SoLuongTon = ctsp.SoLuongTon - i.SoLuong
    FROM CHI_TIET_SAN_PHAM ctsp
    INNER JOIN inserted i ON ctsp.MaCTSP = i.MaCTSP;
    
    UPDATE CHI_TIET_SAN_PHAM
    SET TrangThai = 0
    WHERE SoLuongTon = 0;
END;
GO

-- Trigger 4: Tính thành tiền khi nhập hàng
CREATE TRIGGER trg_tinh_thanhtien_nhap
ON CHI_TIET_PHIEU_NHAP
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO CHI_TIET_PHIEU_NHAP (MaPhieuNhap, MaCTSP, SoLuong, DonGiaNhap, ThanhTien)
    SELECT 
        MaPhieuNhap, 
        MaCTSP, 
        SoLuong, 
        DonGiaNhap,
        SoLuong * DonGiaNhap AS ThanhTien
    FROM inserted;
END;
GO

-- Trigger 5: Tăng tồn kho khi nhập hàng
CREATE TRIGGER trg_tang_ton_kho
ON CHI_TIET_PHIEU_NHAP
AFTER INSERT
AS
BEGIN
    UPDATE ctsp
    SET ctsp.SoLuongTon = ctsp.SoLuongTon + i.SoLuong,
        ctsp.TrangThai = 1
    FROM CHI_TIET_SAN_PHAM ctsp
    INNER JOIN inserted i ON ctsp.MaCTSP = i.MaCTSP;
END;
GO

-- Trigger 6: Cập nhật tổng tiền phiếu bán hàng
CREATE TRIGGER trg_capnhat_tongtien_ban
ON CHI_TIET_PHIEU_BAN
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE pbh
    SET TongTien = ISNULL((
        SELECT SUM(ThanhTien) 
        FROM CHI_TIET_PHIEU_BAN 
        WHERE MaPhieuBan = pbh.MaPhieuBan
    ), 0),
    ThanhToan = ISNULL((
        SELECT SUM(ThanhTien) 
        FROM CHI_TIET_PHIEU_BAN 
        WHERE MaPhieuBan = pbh.MaPhieuBan
    ), 0) - ISNULL(pbh.GiamGia, 0)
    FROM PHIEU_BAN_HANG pbh
    WHERE pbh.MaPhieuBan IN (
        SELECT MaPhieuBan FROM inserted
        UNION
        SELECT MaPhieuBan FROM deleted
    );
END;
GO

-- Trigger 7: Cập nhật tổng tiền phiếu nhập hàng
CREATE TRIGGER trg_capnhat_tongtien_nhap
ON CHI_TIET_PHIEU_NHAP
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    UPDATE pnh
    SET TongTien = ISNULL((
        SELECT SUM(ThanhTien) 
        FROM CHI_TIET_PHIEU_NHAP 
        WHERE MaPhieuNhap = pnh.MaPhieuNhap
    ), 0)
    FROM PHIEU_NHAP_HANG pnh
    WHERE pnh.MaPhieuNhap IN (
        SELECT MaPhieuNhap FROM inserted
        UNION
        SELECT MaPhieuNhap FROM deleted
    );
END;
GO

-- Trigger 8: Tích điểm cho khách hàng khi hoàn thành đơn hàng
CREATE TRIGGER trg_tichdiem_khachhang
ON PHIEU_BAN_HANG
AFTER UPDATE
AS
BEGIN
    IF UPDATE(TrangThai)
    BEGIN
        UPDATE kh
        SET DiemTichLuy = kh.DiemTichLuy + FLOOR(i.ThanhToan / 100000)
        FROM KHACH_HANG kh
        INNER JOIN inserted i ON kh.MaKH = i.MaKH
        INNER JOIN deleted d ON i.MaPhieuBan = d.MaPhieuBan
        WHERE i.TrangThai = N'Hoàn thành' 
          AND d.TrangThai != N'Hoàn thành'
          AND i.ThanhToan IS NOT NULL
          AND kh.TrangThai = 1;
    END
END;
GO

-- Trigger 9: Cập nhật giá nhập cho sản phẩm khi nhập hàng
CREATE TRIGGER trg_capnhat_gianhap_sp
ON CHI_TIET_PHIEU_NHAP
AFTER INSERT
AS
BEGIN
    UPDATE ctsp
    SET ctsp.GiaNhap = i.DonGiaNhap
    FROM CHI_TIET_SAN_PHAM ctsp
    INNER JOIN inserted i ON ctsp.MaCTSP = i.MaCTSP;
END;
GO

-- Trigger 10: Ngăn chỉnh sửa phiếu bán đã hoàn thành
CREATE TRIGGER trg_khoa_phieu_hoanthanh
ON PHIEU_BAN_HANG
FOR UPDATE
AS
BEGIN
    IF UPDATE(TongTien) OR UPDATE(ThanhToan)
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM deleted d
            WHERE d.TrangThai = N'Hoàn thành'
        )
        BEGIN
            RAISERROR(N'Không thể chỉnh sửa phiếu đã hoàn thành!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END
END;
GO

-- Trigger 11: Kiểm tra giá bán ≥ giá nhập
CREATE TRIGGER trg_kiemtra_giaban_hople
ON SAN_PHAM
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE EXISTS (
            SELECT 1
            FROM CHI_TIET_SAN_PHAM ctsp
            WHERE ctsp.MaSP = i.MaSP 
            AND i.GiaBan < ctsp.GiaNhap
        )
    )
    BEGIN
        RAISERROR(N'Giá bán không được thấp hơn giá nhập!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Trigger 12: Kiểm tra nhà cung cấp còn hoạt động khi nhập hàng
CREATE TRIGGER trg_kiemtra_ncc_hoatdong
ON PHIEU_NHAP_HANG
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN NHA_CUNG_CAP ncc ON i.MaNCC = ncc.MaNCC
        WHERE ncc.TrangThai = 0
    )
    BEGIN
        RAISERROR(N'Nhà cung cấp đã ngừng hợp tác!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- Trigger 13: Tự động ẩn sản phẩm khi tất cả biến thể hết hàng
CREATE TRIGGER trg_an_sanpham_hethang
ON CHI_TIET_SAN_PHAM
AFTER UPDATE
AS
BEGIN
    UPDATE sp
    SET sp.TrangThai = 0
    FROM SAN_PHAM sp
    WHERE sp.MaSP IN (SELECT DISTINCT MaSP FROM inserted)
    AND NOT EXISTS (
        SELECT 1
        FROM CHI_TIET_SAN_PHAM ctsp
        WHERE ctsp.MaSP = sp.MaSP
        AND ctsp.SoLuongTon > 0
        AND ctsp.TrangThai = 1
    );
    
    UPDATE sp
    SET sp.TrangThai = 1
    FROM SAN_PHAM sp
    WHERE sp.MaSP IN (SELECT DISTINCT MaSP FROM inserted)
    AND EXISTS (
        SELECT 1
        FROM CHI_TIET_SAN_PHAM ctsp
        WHERE ctsp.MaSP = sp.MaSP
        AND ctsp.SoLuongTon > 0
        AND ctsp.TrangThai = 1
    );
END;
GO

-- Trigger 14: Kiểm tra khách hàng đã mua sản phẩm trước khi đánh giá
CREATE TRIGGER trg_kiemtra_danhgia
ON DANH_GIA
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.DaMuaHang = 1 
        AND NOT EXISTS (
            SELECT 1
            FROM PHIEU_BAN_HANG pbh
            INNER JOIN CHI_TIET_PHIEU_BAN ctpb ON pbh.MaPhieuBan = ctpb.MaPhieuBan
            INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpb.MaCTSP = ctsp.MaCTSP
            WHERE pbh.MaKH = i.MaKH
            AND ctsp.MaSP = i.MaSP
            AND pbh.TrangThai = N'Hoàn thành'
        )
    )
    BEGIN
        RAISERROR(N'Chỉ khách hàng đã mua sản phẩm mới được đánh giá!', 16, 1);
        RETURN;
    END
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN KHACH_HANG kh ON i.MaKH = kh.MaKH
        WHERE kh.TrangThai = 0
    )
    BEGIN
        RAISERROR(N'Tài khoản đã bị khóa, không thể đánh giá!', 16, 1);
        RETURN;
    END
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN SAN_PHAM sp ON i.MaSP = sp.MaSP
        WHERE sp.TrangThai = 0
    )
    BEGIN
        RAISERROR(N'Sản phẩm đã ngừng bán, không thể đánh giá!', 16, 1);
        RETURN;
    END
    
    INSERT INTO DANH_GIA (MaSP, MaKH, DiemDanhGia, TieuDe, NoiDung, NgayDanhGia, TrangThai, PhanHoiTuShop, NgayPhanHoi, DaMuaHang)
    SELECT 
        MaSP,
        MaKH,
        DiemDanhGia,
        TieuDe,
        NoiDung,
        GETDATE(),
        ISNULL(TrangThai, 1),
        PhanHoiTuShop,
        NgayPhanHoi,
        ISNULL(DaMuaHang, 1)
    FROM inserted;
END;
GO

-- =====================================================
-- PHẦN 3: TẠO STORED PROCEDURE
-- =====================================================

-- Procedure 1: Thống kê doanh thu theo tháng
CREATE PROCEDURE sp_DoanhThuTheoThang
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT 
        CAST(NgayBan AS DATE) AS Ngay,
        COUNT(MaPhieuBan) AS SoDonHang,
        SUM(ThanhToan) AS DoanhThu
    FROM PHIEU_BAN_HANG
    WHERE MONTH(NgayBan) = @Thang 
        AND YEAR(NgayBan) = @Nam
        AND TrangThai = N'Hoàn thành'
    GROUP BY CAST(NgayBan AS DATE)
    ORDER BY Ngay;
END;
GO

-- Procedure 2: Top sản phẩm bán chạy
CREATE PROCEDURE sp_TopSanPhamBanChay
    @SoLuong INT = 10
AS
BEGIN
    SELECT TOP (@SoLuong)
        sp.MaSP,
        sp.TenSP,
        lsp.TenLoai,
        SUM(ctpb.SoLuong) AS TongSoLuongBan,
        SUM(ctpb.ThanhTien) AS TongDoanhThu,
        sp.TrangThai AS DangBan
    FROM CHI_TIET_PHIEU_BAN ctpb
    INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpb.MaCTSP = ctsp.MaCTSP
    INNER JOIN SAN_PHAM sp ON ctsp.MaSP = sp.MaSP
    INNER JOIN LOAI_SAN_PHAM lsp ON sp.MaLoai = lsp.MaLoai
    INNER JOIN PHIEU_BAN_HANG pbh ON ctpb.MaPhieuBan = pbh.MaPhieuBan
    WHERE pbh.TrangThai = N'Hoàn thành'
        AND sp.TrangThai = 1
    GROUP BY sp.MaSP, sp.TenSP, lsp.TenLoai, sp.TrangThai
    ORDER BY TongSoLuongBan DESC;
END;
GO

-- Procedure 3: Kiểm tra tồn kho thấp
CREATE PROCEDURE sp_SanPhamTonKhoThap
    @Nguong INT = 10
AS
BEGIN
    SELECT 
        sp.MaSP,
        sp.TenSP,
        ms.TenMau,
        kt.TenSize,
        ctsp.SoLuongTon,
        ctsp.MaCTSP,
        CASE 
            WHEN ctsp.TrangThai = 1 THEN N'Hiển thị'
            ELSE N'Đã ẩn'
        END AS TrangThai
    FROM CHI_TIET_SAN_PHAM ctsp
    INNER JOIN SAN_PHAM sp ON ctsp.MaSP = sp.MaSP
    LEFT JOIN MAU_SAC ms ON ctsp.MaMau = ms.MaMau
    LEFT JOIN KICH_THUOC kt ON ctsp.MaSize = kt.MaSize
    WHERE ctsp.SoLuongTon <= @Nguong
        AND sp.TrangThai = 1
        AND ctsp.TrangThai = 1
    ORDER BY ctsp.SoLuongTon ASC;
END;
GO

-- Procedure 4: Xem danh sách nhà cung cấp
CREATE PROCEDURE sp_DanhSachNhaCungCap
    @ChiLayHoatDong BIT = 1
AS
BEGIN
    SELECT 
        ncc.MaNCC,
        ncc.TenNCC,
        ncc.DiaChi,
        ncc.SDT,
        ncc.Email,
        ncc.NguoiLienHe,
        COUNT(pnh.MaPhieuNhap) AS SoLanNhapHang,
        SUM(pnh.TongTien) AS TongGiaTriNhap,
        CASE 
            WHEN ncc.TrangThai = 1 THEN N'Đang hợp tác'
            ELSE N'Ngừng hợp tác'
        END AS TrangThai
    FROM NHA_CUNG_CAP ncc
    LEFT JOIN PHIEU_NHAP_HANG pnh ON ncc.MaNCC = pnh.MaNCC
    WHERE (@ChiLayHoatDong = 0) OR (ncc.TrangThai = @ChiLayHoatDong)
    GROUP BY ncc.MaNCC, ncc.TenNCC, ncc.DiaChi, ncc.SDT, ncc.Email, ncc.NguoiLienHe, ncc.TrangThai
    ORDER BY TongGiaTriNhap DESC;
END;
GO

-- Procedure 5: Báo cáo lợi nhuận sản phẩm
CREATE PROCEDURE sp_LoiNhuanSanPham
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SELECT 
        sp.MaSP,
        sp.TenSP,
        SUM(ctpb.SoLuong) AS SoLuongBan,
        SUM(ctpb.ThanhTien) AS DoanhThu,
        SUM(ctpb.SoLuong * ctsp.GiaNhap) AS GiaVon,
        SUM(ctpb.ThanhTien) - SUM(ctpb.SoLuong * ctsp.GiaNhap) AS LoiNhuan,
        CASE 
            WHEN sp.TrangThai = 1 THEN N'Đang bán'
            ELSE N'Ngừng bán'
        END AS TrangThai
    FROM CHI_TIET_PHIEU_BAN ctpb
    INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpb.MaCTSP = ctsp.MaCTSP
    INNER JOIN SAN_PHAM sp ON ctsp.MaSP = sp.MaSP
    INNER JOIN PHIEU_BAN_HANG pbh ON ctpb.MaPhieuBan = pbh.MaPhieuBan
    WHERE pbh.NgayBan BETWEEN @TuNgay AND @DenNgay
        AND pbh.TrangThai = N'Hoàn thành'
    GROUP BY sp.MaSP, sp.TenSP, sp.TrangThai
    ORDER BY LoiNhuan DESC;
END;
GO

-- Procedure 6: "Xóa mềm" sản phẩm
CREATE PROCEDURE sp_AnSanPham
    @MaSP VARCHAR(10)
AS
BEGIN
    UPDATE SAN_PHAM
    SET TrangThai = 0
    WHERE MaSP = @MaSP;
    
    UPDATE CHI_TIET_SAN_PHAM
    SET TrangThai = 0
    WHERE MaSP = @MaSP;
    
    SELECT N'Đã ẩn sản phẩm ' + @MaSP AS ThongBao;
END;
GO

-- Procedure 7: Khôi phục sản phẩm đã ẩn
CREATE PROCEDURE sp_KhoiPhucSanPham
    @MaSP VARCHAR(10)
AS
BEGIN
    UPDATE SAN_PHAM
    SET TrangThai = 1
    WHERE MaSP = @MaSP;
    
    UPDATE CHI_TIET_SAN_PHAM
    SET TrangThai = 1
    WHERE MaSP = @MaSP
    AND SoLuongTon > 0;
    
    SELECT N'Đã khôi phục sản phẩm ' + @MaSP AS ThongBao;
END;
GO

-- Procedure 8: Ngừng hợp tác với nhà cung cấp
CREATE PROCEDURE sp_NgungHopTacNCC
    @MaNCC VARCHAR(10),
    @LyDo NVARCHAR(255) = NULL
AS
BEGIN
    UPDATE NHA_CUNG_CAP
    SET TrangThai = 0,
        GhiChu = ISNULL(@LyDo, N'Ngừng hợp tác')
    WHERE MaNCC = @MaNCC;
    
    SELECT N'Đã ngừng hợp tác với NCC ' + @MaNCC AS ThongBao;
END;
GO

-- Procedure 9: Thêm đánh giá mới
CREATE PROCEDURE sp_ThemDanhGia
    @MaSP VARCHAR(10),
    @MaKH VARCHAR(10),
    @DiemDanhGia INT,
    @TieuDe NVARCHAR(200) = NULL,
    @NoiDung NVARCHAR(1000) = NULL,
    @DaMuaHang BIT = 1
AS
BEGIN
    INSERT INTO DANH_GIA (MaSP, MaKH, DiemDanhGia, TieuDe, NoiDung, DaMuaHang)
    VALUES (@MaSP, @MaKH, @DiemDanhGia, @TieuDe, @NoiDung, @DaMuaHang);
    
    SELECT N'Đã thêm đánh giá thành công!' AS ThongBao;
END;
GO

-- Procedure 10: Quản lý đánh giá (hiển thị/ẩn)
CREATE PROCEDURE sp_QuanLyDanhGia
    @MaDanhGia INT,
    @TrangThai BIT,
    @PhanHoiTuShop NVARCHAR(500) = NULL
AS
BEGIN
    UPDATE DANH_GIA
    SET TrangThai = @TrangThai,
        PhanHoiTuShop = @PhanHoiTuShop,
        NgayPhanHoi = CASE WHEN @PhanHoiTuShop IS NOT NULL THEN GETDATE() ELSE NgayPhanHoi END
    WHERE MaDanhGia = @MaDanhGia;
    
    SELECT 
        CASE 
            WHEN @TrangThai = 1 THEN N'Đã hiển thị đánh giá'
            ELSE N'Đã ẩn đánh giá'
        END AS ThongBao;
END;
GO

-- Procedure 11: Thống kê đánh giá sản phẩm
CREATE PROCEDURE sp_ThongKeDanhGia
    @MaSP VARCHAR(10) = NULL
AS
BEGIN
    SELECT 
        ISNULL(@MaSP, 'TẤT CẢ') AS MaSP,
        COUNT(*) AS TongDanhGia,
        AVG(CAST(DiemDanhGia AS FLOAT)) AS DiemTrungBinh,
        COUNT(CASE WHEN DiemDanhGia = 5 THEN 1 END) AS Sao5,
        COUNT(CASE WHEN DiemDanhGia = 4 THEN 1 END) AS Sao4,
        COUNT(CASE WHEN DiemDanhGia = 3 THEN 1 END) AS Sao3,
        COUNT(CASE WHEN DiemDanhGia = 2 THEN 1 END) AS Sao2,
        COUNT(CASE WHEN DiemDanhGia = 1 THEN 1 END) AS Sao1,
        COUNT(CASE WHEN TrangThai = 1 THEN 1 END) AS HienThi,
        COUNT(CASE WHEN TrangThai = 0 THEN 1 END) AS DaAn
    FROM DANH_GIA
    WHERE (@MaSP IS NULL OR MaSP = @MaSP)
    AND DaMuaHang = 1;
END;
GO

-- =====================================================
-- PHẦN 4: TẠO INDEX
-- =====================================================

CREATE INDEX idx_sp_loai ON SAN_PHAM(MaLoai);
CREATE INDEX idx_sp_trangthai ON SAN_PHAM(TrangThai);
CREATE INDEX idx_ctsp_sp ON CHI_TIET_SAN_PHAM(MaSP);
CREATE INDEX idx_ctsp_mau ON CHI_TIET_SAN_PHAM(MaMau);
CREATE INDEX idx_ctsp_size ON CHI_TIET_SAN_PHAM(MaSize);
CREATE INDEX idx_ctsp_trangthai ON CHI_TIET_SAN_PHAM(TrangThai);
CREATE INDEX idx_pbh_khach ON PHIEU_BAN_HANG(MaKH);
CREATE INDEX idx_pbh_nhanvien ON PHIEU_BAN_HANG(MaNV);
CREATE INDEX idx_pbh_ngay ON PHIEU_BAN_HANG(NgayBan);
CREATE INDEX idx_pbh_trangthai ON PHIEU_BAN_HANG(TrangThai);
CREATE INDEX idx_pnh_ngay ON PHIEU_NHAP_HANG(NgayNhap);
CREATE INDEX idx_pnh_ncc ON PHIEU_NHAP_HANG(MaNCC);
CREATE INDEX idx_ctpb_phieu ON CHI_TIET_PHIEU_BAN(MaPhieuBan);
CREATE INDEX idx_ctpb_ctsp ON CHI_TIET_PHIEU_BAN(MaCTSP);
CREATE INDEX idx_ctpn_phieu ON CHI_TIET_PHIEU_NHAP(MaPhieuNhap);
CREATE INDEX idx_ctpn_ctsp ON CHI_TIET_PHIEU_NHAP(MaCTSP);
CREATE INDEX idx_ncc_trangthai ON NHA_CUNG_CAP(TrangThai);
CREATE INDEX idx_dg_sanpham ON DANH_GIA(MaSP);
CREATE INDEX idx_dg_khachhang ON DANH_GIA(MaKH);
CREATE INDEX idx_dg_ngay ON DANH_GIA(NgayDanhGia);
CREATE INDEX idx_dg_trangthai ON DANH_GIA(TrangThai);
CREATE INDEX idx_dg_diem ON DANH_GIA(DiemDanhGia);

-- =====================================================
-- PHẦN 5: TẠO VIEW (ĐÃ SỬA LỖI)
-- =====================================================

GO
-- View 1: Sản phẩm đang bán (ĐÃ SỬA)
CREATE VIEW v_SanPhamDangBan AS
SELECT 
    sp.MaSP,
    sp.TenSP,
    lsp.TenLoai,
    sp.GiaBan,
    SUM(ctsp.SoLuongTon) AS TongTonKho,
    COUNT(CASE WHEN ctsp.TrangThai = 1 THEN 1 END) AS SoBienTheConHang,
    (SELECT TOP 1 DuongDan FROM HINH_ANH_SAN_PHAM WHERE MaSP = sp.MaSP AND TrangThai = 1) AS HinhAnhChinh
FROM SAN_PHAM sp
INNER JOIN LOAI_SAN_PHAM lsp ON sp.MaLoai = lsp.MaLoai
LEFT JOIN CHI_TIET_SAN_PHAM ctsp ON sp.MaSP = ctsp.MaSP
WHERE sp.TrangThai = 1
    AND lsp.TrangThai = 1
GROUP BY sp.MaSP, sp.TenSP, lsp.TenLoai, sp.GiaBan;
GO

-- View 2: Chi tiết đơn hàng
CREATE VIEW v_DonHangChiTiet AS
SELECT 
    pbh.MaPhieuBan,
    pbh.NgayBan,
    kh.TenKH,
    kh.SDT AS SDT_KhachHang,
    nv.TenNV AS NhanVienBanHang,
    sp.TenSP,
    ms.TenMau,
    kt.TenSize,
    ctpb.SoLuong,
    ctpb.DonGia,
    ctpb.ThanhTien,
    pbh.TongTien,
    pbh.GiamGia,
    pbh.ThanhToan,
    pbh.PhuongThucTT,
    pbh.TrangThai
FROM PHIEU_BAN_HANG pbh
INNER JOIN KHACH_HANG kh ON pbh.MaKH = kh.MaKH
INNER JOIN NHAN_VIEN nv ON pbh.MaNV = pbh.MaNV
INNER JOIN CHI_TIET_PHIEU_BAN ctpb ON pbh.MaPhieuBan = ctpb.MaPhieuBan
INNER JOIN CHI_TIET_SAN_PHAM ctsp ON ctpb.MaCTSP = ctsp.MaCTSP
INNER JOIN SAN_PHAM sp ON ctsp.MaSP = sp.MaSP
LEFT JOIN MAU_SAC ms ON ctsp.MaMau = ms.MaMau
LEFT JOIN KICH_THUOC kt ON ctsp.MaSize = kt.MaSize;
GO

-- View 3: Thống kê nhanh
CREATE VIEW v_ThongKeNhanh AS
SELECT 
    (SELECT COUNT(*) FROM SAN_PHAM WHERE TrangThai = 1) AS TongSanPhamDangBan,
    (SELECT COUNT(*) FROM KHACH_HANG WHERE TrangThai = 1) AS KhachHangHoatDong,
    (SELECT COUNT(*) FROM PHIEU_BAN_HANG WHERE TrangThai = N'Hoàn thành') AS DonHangHoanThanh,
    (SELECT SUM(ThanhToan) FROM PHIEU_BAN_HANG WHERE TrangThai = N'Hoàn thành') AS TongDoanhThu,
    (SELECT COUNT(*) FROM CHI_TIET_SAN_PHAM WHERE SoLuongTon <= 10 AND TrangThai = 1) AS SanPhamSapHet;
GO

-- View 4: Đánh giá sản phẩm chi tiết
CREATE VIEW v_DanhGiaChiTiet AS
SELECT 
    dg.MaDanhGia,
    sp.MaSP,
    sp.TenSP,
    kh.MaKH,
    kh.TenKH,
    dg.DiemDanhGia,
    dg.TieuDe,
    dg.NoiDung,
    dg.NgayDanhGia,
    dg.PhanHoiTuShop,
    dg.NgayPhanHoi,
    dg.DaMuaHang,
    CASE 
        WHEN dg.TrangThai = 1 THEN N'Hiển thị'
        ELSE N'Đã ẩn'
    END AS TrangThaiHienThi
FROM DANH_GIA dg
INNER JOIN SAN_PHAM sp ON dg.MaSP = sp.MaSP
INNER JOIN KHACH_HANG kh ON dg.MaKH = kh.MaKH
WHERE sp.TrangThai = 1
    AND kh.TrangThai = 1;
GO

-- View 5: Sản phẩm và điểm đánh giá trung bình (ĐÃ SỬA)
CREATE VIEW v_SanPhamVaDanhGia AS
SELECT 
    sp.MaSP,
    sp.TenSP,
    lsp.TenLoai,
    sp.GiaBan,
    (SELECT TOP 1 DuongDan FROM HINH_ANH_SAN_PHAM WHERE MaSP = sp.MaSP AND TrangThai = 1) AS HinhAnhChinh,
    ISNULL(AVG(CAST(dg.DiemDanhGia AS FLOAT)), 0) AS DiemTrungBinh,
    COUNT(dg.MaDanhGia) AS SoLuotDanhGia,
    SUM(ctsp.SoLuongTon) AS TongTonKho,
    CASE 
        WHEN sp.TrangThai = 1 THEN N'Đang bán'
        ELSE N'Ngừng bán'
    END AS TrangThai
FROM SAN_PHAM sp
INNER JOIN LOAI_SAN_PHAM lsp ON sp.MaLoai = lsp.MaLoai
LEFT JOIN DANH_GIA dg ON sp.MaSP = dg.MaSP AND dg.TrangThai = 1
LEFT JOIN CHI_TIET_SAN_PHAM ctsp ON sp.MaSP = ctsp.MaSP
GROUP BY sp.MaSP, sp.TenSP, lsp.TenLoai, sp.GiaBan, sp.TrangThai;
GO

-- =====================================================
-- PHẦN 6: DỮ LIỆU MẪU
-- =====================================================

-- Thêm Nhà cung cấp
INSERT INTO NHA_CUNG_CAP VALUES
('NCC001', N'Công ty TNHH Phụ kiện Á Châu', N'123 Lê Duẩn, Q.1, TP.HCM', '0281234567', 'achau@email.com', N'Nguyễn Văn A', N'NCC uy tín, giao hàng đúng hạn', 1),
('NCC002', N'Công ty CP Thời trang Việt', N'456 Nguyễn Huệ, Q.1, TP.HCM', '0287654321', 'thoitrangviet@email.com', N'Trần Thị B', N'Chuyên túi xách cao cấp', 1);

-- Thêm Loại sản phẩm
INSERT INTO LOAI_SAN_PHAM VALUES
('LSP001', N'Túi xách', N'Các loại túi xách thời trang', 1),
('LSP002', N'Ví', N'Ví da, ví cầm tay', 1),
('LSP003', N'Kính mát', N'Kính thời trang, kính chống nắng', 1);

-- Thêm Màu sắc
INSERT INTO MAU_SAC VALUES
('M001', N'Đen', '#000000', 1),
('M002', N'Trắng', '#FFFFFF', 1),
('M003', N'Đỏ', '#FF0000', 1);

-- Thêm Kích thước
INSERT INTO KICH_THUOC VALUES
('S001', 'Free Size', N'Không phân biệt size', 1),
('S002', 'S', N'Size nhỏ', 1);

-- Thêm Nhân viên
INSERT INTO NHAN_VIEN VALUES
('NV001', N'Nguyễn Văn An', '1990-05-15', N'Nam', '0901234567', 'annv@email.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', N'Quản lý', '2020-01-10', 15000000, 1),
('NV002', N'Trần Thị Bình', '1995-08-20', N'Nữ', '0912345678', 'binht@email.com', N'456 Lê Lợi, Q.1, TP.HCM', N'Nhân viên bán hàng', '2021-03-15', 8000000, 1);

-- Thêm Khách hàng
INSERT INTO KHACH_HANG VALUES
('KH001', N'Nguyễn Thị Hoa', '0987654321', 'hoant@gmail.com', N'12 Lý Thường Kiệt, Q.10, TP.HCM', '2023-01-15', 150, 1),
('KH002', N'Trần Văn Hùng', '0976543210', 'hungtv@gmail.com', N'34 Cách Mạng Tháng 8, Q.3, TP.HCM', '2023-02-20', 80, 1);

-- Thêm Sản phẩm (ĐÃ XÓA HinhAnh)
INSERT INTO SAN_PHAM VALUES
('SP001', N'Túi xách nữ da cao cấp', 'LSP001', N'Túi xách da bò thật, thiết kế sang trọng', 1500000, 1),
('SP002', N'Ví cầm tay nam da thật', 'LSP002', N'Ví da bò, nhiều ngăn tiện dụng', 450000, 1);

-- Thêm Hình ảnh sản phẩm
INSERT INTO HINH_ANH_SAN_PHAM (MaSP, DuongDan, TenHinhAnh) VALUES
('SP001', '/images/tui-xach-den-01.jpg', N'Túi xách đen góc chính'),
('SP001', '/images/tui-xach-den-02.jpg', N'Túi xách đen góc nghiêng'),
('SP002', '/images/vi-nam-den-01.jpg', N'Ví nam da đen');

-- Thêm Chi tiết sản phẩm (MaCTSP tự động tạo)
INSERT INTO CHI_TIET_SAN_PHAM (MaSP, MaMau, MaSize, SoLuongTon, GiaNhap, TrangThai) VALUES
('SP001', 'M001', 'S001', 25, 900000, 1),
('SP001', 'M002', 'S001', 20, 900000, 1),
('SP002', 'M001', 'S001', 30, 270000, 1);

-- Thêm Phiếu nhập hàng
INSERT INTO PHIEU_NHAP_HANG VALUES
('PN001', 'NCC001', 'NV001', '2024-10-01', 0, N'Nhập hàng tháng 10', 1);

-- Thêm Chi tiết phiếu nhập
INSERT INTO CHI_TIET_PHIEU_NHAP VALUES
('PN001', 'SP001-M001-S001', 30, 900000, NULL),
('PN001', 'SP001-M002-S001', 25, 900000, NULL);

-- Thêm Phiếu bán hàng
INSERT INTO PHIEU_BAN_HANG VALUES
('PB001', 'KH001', 'NV002', '2024-10-20', 0, 0, NULL, N'Tiền mặt', N'Hoàn thành', NULL),
('PB002', 'KH002', 'NV002', '2024-10-21', 0, 50000, NULL, N'Chuyển khoản', N'Hoàn thành', NULL);

-- Thêm Chi tiết phiếu bán
INSERT INTO CHI_TIET_PHIEU_BAN VALUES
('PB001', 'SP001-M001-S001', 2, 1500000, NULL),
('PB001', 'SP002-M001-S001', 1, 450000, NULL),
('PB002', 'SP001-M002-S001', 1, 1500000, NULL);

-- Thêm Đánh giá mẫu
INSERT INTO DANH_GIA (MaSP, MaKH, DiemDanhGia, TieuDe, NoiDung, DaMuaHang) VALUES
('SP001', 'KH001', 5, N'Sản phẩm tuyệt vời!', N'Túi xách đẹp, chất lượng tốt, giao hàng nhanh. Rất hài lòng!', 1),
('SP001', 'KH002', 4, N'Khá ổn', N'Chất lượng tốt nhưng giá hơi cao. Nhân viên tư vấn nhiệt tình.', 1),
('SP002', 'KH001', 3, N'Tạm được', N'Ví đẹp nhưng hơi nhỏ so với nhu cầu. Chất lượng da ổn.', 1);


-- Thêm dữ liệu mẫu
INSERT INTO TAI_KHOAN VALUES ('admin', '123456', 'NV001', 'Admin', 1);
INSERT INTO TAI_KHOAN VALUES ('staff', '123456', 'NV002', 'NhanVien', 1);

-- =====================================================
-- PHẦN 7: TEST HỆ THỐNG
-- =====================================================

-- Test 1: Xem sản phẩm đang bán
SELECT * FROM v_SanPhamDangBan;

-- Test 2: Xem đánh giá chi tiết
SELECT * FROM v_DanhGiaChiTiet;

-- Test 3: Xem sản phẩm và điểm đánh giá
SELECT * FROM v_SanPhamVaDanhGia;

-- Test 4: Thống kê đánh giá
EXEC sp_ThongKeDanhGia @MaSP = 'SP001';

-- Test 5: Thêm đánh giá mới
EXEC sp_ThemDanhGia 
    @MaSP = 'SP002',
    @MaKH = 'KH002',
    @DiemDanhGia = 5,
    @TieuDe = N'Rất hài lòng',
    @NoiDung = N'Sản phẩm chất lượng, sẽ ủng hộ lần sau';

-- Test 6: Quản lý đánh giá
EXEC sp_QuanLyDanhGia 
    @MaDanhGia = 1,
    @TrangThai = 1,
    @PhanHoiTuShop = N'Cảm ơn bạn đã đánh giá! Chúc bạn sử dụng sản phẩm vui vẻ.';

-- Test 7: Thống kê nhanh
SELECT * FROM v_ThongKeNhanh;

PRINT N'✅ CƠ SỞ DỮ LIỆU ĐÃ ĐƯỢC TẠO THÀNH CÔNG!';
PRINT N'📊 TỔNG KẾT:';
PRINT N'   - 12 BẢNG';
PRINT N'   - 14 TRIGGER';
PRINT N'   - 11 STORED PROCEDURE';
PRINT N'   - 5 VIEW';
PRINT N'   - 25 INDEX';
PRINT N'   - DỮ LIỆU MẪU ĐẦY ĐỦ';


IF OBJECT_ID('trg_khoa_phieu_hoanthanh', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER trg_khoa_phieu_hoanthanh;
    PRINT N'✅ Đã xóa Trigger trg_khoa_phieu_hoanthanh thành công.';
END
ELSE
BEGIN
    PRINT N'⚠️ Trigger trg_khoa_phieu_hoanthanh không tồn tại.';
END



-- =====================================================
-- PHẦN 6: DỮ LIỆU MẪU (ĐÃ SỬA CHO ÁO QUẦN)
-- =====================================================

-- Xóa dữ liệu cũ để tránh lỗi PRIMARY KEY/FOREIGN KEY khi chạy lại file
-- Xóa các bảng chứa dữ liệu phụ thuộc (nếu chưa xóa)
DELETE FROM CHI_TIET_PHIEU_BAN;
DELETE FROM CHI_TIET_PHIEU_NHAP;
DELETE FROM DANH_GIA;
DELETE FROM PHIEU_BAN_HANG;
DELETE FROM PHIEU_NHAP_HANG;
DELETE FROM HINH_ANH_SAN_PHAM;
DELETE FROM CHI_TIET_SAN_PHAM;
DELETE FROM SAN_PHAM;
DELETE FROM LOAI_SAN_PHAM;
DELETE FROM KICH_THUOC;
DELETE FROM MAU_SAC;
DELETE FROM NHA_CUNG_CAP;
DELETE FROM NHAN_VIEN;
DELETE FROM KHACH_HANG;
DELETE FROM TAI_KHOAN;

-- Reset IDENTITY cho bảng tự tăng (Nếu cần, ví dụ HINH_ANH_SAN_PHAM, DANH_GIA)
DBCC CHECKIDENT (HINH_ANH_SAN_PHAM, RESEED, 0);
DBCC CHECKIDENT (DANH_GIA, RESEED, 0);


-- Thêm Nhà cung cấp
INSERT INTO NHA_CUNG_CAP VALUES
('NCC001', N'Công ty TNHH Vải sợi Á Châu', N'123 Lê Duẩn, Q.1, TP.HCM', '0281234567', 'achau@email.com', N'Nguyễn Văn A', N'NCC uy tín, giao hàng đúng hạn', 1),
('NCC002', N'Công ty CP Thời trang May Mặc', N'456 Nguyễn Huệ, Q.1, TP.HCM', '0287654321', 'maymacviet@email.com', N'Trần Thị B', N'Chuyên sản xuất quần jeans', 1);

-- Thêm Loại sản phẩm (QUẦN ÁO)
INSERT INTO LOAI_SAN_PHAM VALUES
('LSP001', N'Áo Thun', N'Các loại áo thun cotton và poly', 1),
('LSP002', N'Quần Jeans', N'Quần jeans nam và nữ các kiểu', 1),
('LSP003', N'Áo Sơ Mi', N'Các loại áo sơ mi công sở và thường ngày', 1),
('LSP004', N'Váy/Đầm', N'Váy đầm thời trang nữ', 1);


-- Thêm Màu sắc
INSERT INTO MAU_SAC VALUES
('M001', N'Đen', '#000000', 1),
('M002', N'Trắng', '#FFFFFF', 1),
('M003', N'Đỏ', '#FF0000', 1),
('M004', N'Xanh Navy', '#000080', 1);

-- Thêm Kích thước (QUẦN ÁO)
INSERT INTO KICH_THUOC VALUES
('S001', 'S', N'Size nhỏ (Small)', 1),
('S002', 'M', N'Size trung bình (Medium)', 1),
('S003', 'L', N'Size lớn (Large)', 1),
('S004', 'XL', N'Size rất lớn (Extra Large)', 1),
('S005', 'Free Size', N'Không phân biệt size', 1);

-- Thêm Nhân viên (Giữ nguyên)
INSERT INTO NHAN_VIEN VALUES
('NV001', N'Nguyễn Văn An', '1990-05-15', N'Nam', '0901234567', 'annv@email.com', N'123 Nguyễn Huệ, Q.1, TP.HCM', N'Quản lý', '2020-01-10', 15000000, 1),
('NV002', N'Trần Thị Bình', '1995-08-20', N'Nữ', '0912345678', 'binht@email.com', N'456 Lê Lợi, Q.1, TP.HCM', N'Nhân viên bán hàng', '2021-03-15', 8000000, 1);

-- Thêm Khách hàng (Thêm KH000)
INSERT INTO KHACH_HANG VALUES
('KH000', N'Khách lẻ vãng lai', '0000000000', NULL, NULL, GETDATE(), 0, 1), -- KH Mặc định
('KH001', N'Nguyễn Thị Hoa', '0987654321', 'hoant@gmail.com', N'12 Lý Thường Kiệt, Q.10, TP.HCM', '2023-01-15', 150, 1),
('KH002', N'Trần Văn Hùng', '0976543210', 'hungtv@gmail.com', N'34 Cách Mạng Tháng 8, Q.3, TP.HCM', '2023-02-20', 80, 1);

-- Thêm Sản phẩm (ÁO QUẦN)
INSERT INTO SAN_PHAM VALUES
('QA001', N'Áo Thun Cotton Basic', 'LSP001', N'Áo thun 100% cotton, nhiều màu sắc cơ bản', 199000, 1),
('QA002', N'Quần Jeans Nam Slimfit', 'LSP002', N'Quần jeans co giãn 4 chiều, ôm vừa phải', 499000, 1),
('QA003', N'Áo Sơ Mi Công Sở Nữ', 'LSP003', N'Sơ mi cổ điển, chất liệu mềm mại', 280000, 1),
('QA004', N'Đầm Maxi Dạo Phố', 'LSP004', N'Đầm voan hoa, thích hợp đi chơi', 550000, 1),
('QA005', N'Áo Thun Polo Cao Cấp', 'LSP001', N'Áo polo có cổ, vải cá sấu dày dặn', 350000, 1);

-- Thêm Hình ảnh sản phẩm
INSERT INTO HINH_ANH_SAN_PHAM (MaSP, DuongDan, TenHinhAnh) VALUES
('QA001', '/images/aothun-den.jpg', N'Áo thun đen chính diện'),
('QA002', '/images/jeans-nam-01.jpg', N'Quần jeans nam góc nghiêng');

-- Thêm Chi tiết sản phẩm (Biến thể và Tồn kho)
INSERT INTO CHI_TIET_SAN_PHAM (MaSP, MaMau, MaSize, SoLuongTon, GiaNhap, TrangThai) VALUES
-- QA001: Áo Thun Basic
('QA001', 'M001', 'S002', 40, 90000, 1),  -- Đen - M
('QA001', 'M002', 'S002', 35, 90000, 1),  -- Trắng - M
('QA001', 'M001', 'S003', 30, 90000, 1),  -- Đen - L
-- QA002: Quần Jeans
('QA002', 'M004', 'S003', 25, 300000, 1), -- Xanh Navy - L
('QA002', 'M004', 'S004', 20, 300000, 1), -- Xanh Navy - XL
-- QA003: Sơ Mi
('QA003', 'M002', 'S001', 50, 150000, 1), -- Trắng - S
-- QA004: Đầm Maxi
('QA004', 'M003', 'S005', 18, 350000, 1); -- Đỏ - Free Size

-- Thêm Phiếu nhập hàng
INSERT INTO PHIEU_NHAP_HANG VALUES
('PN001', 'NCC001', 'NV001', '2024-11-10', 0, N'Nhập lô hàng áo thun', 1);

-- Thêm Chi tiết phiếu nhập
INSERT INTO CHI_TIET_PHIEU_NHAP VALUES
('PN001', 'QA001-M001-S002', 40, 90000, NULL),
('PN001', 'QA001-M002-S002', 35, 90000, NULL);

-- Thêm Phiếu bán hàng
INSERT INTO PHIEU_BAN_HANG VALUES
('PB001', 'KH001', 'NV002', '2024-11-20', 0, 0, NULL, N'Tiền mặt', N'Hoàn thành', NULL),
('PB002', 'KH002', 'NV002', '2024-11-21', 0, 50000, NULL, N'Chuyển khoản', N'Hoàn thành', NULL);

-- Thêm Chi tiết phiếu bán
INSERT INTO CHI_TIET_PHIEU_BAN VALUES
('PB001', 'QA001-M001-S002', 2, 199000, NULL),
('PB002', 'QA002-M004-S003', 1, 499000, NULL);

-- Thêm Đánh giá mẫu
INSERT INTO DANH_GIA (MaSP, MaKH, DiemDanhGia, TieuDe, NoiDung, DaMuaHang) VALUES
('QA001', 'KH001', 5, N'Áo thun mặc rất mát!', N'Chất liệu cotton tốt, giao hàng nhanh. Rất hài lòng!', 1),
('QA002', 'KH002', 4, N'Quần jeans vừa vặn', N'Quần hơi bó một chút nhưng co giãn ổn.', 1);

-- Thêm dữ liệu tài khoản (Giữ nguyên)
INSERT INTO TAI_KHOAN VALUES ('admin', '123456', 'NV001', 'Admin', 1);
INSERT INTO TAI_KHOAN VALUES ('staff', '123456', 'NV002', 'NhanVien', 1);


PRINT N'✅ DỮ LIỆU MẪU ĐÃ ĐƯỢC CHUYỂN SANG ÁO QUẦN THỜI TRANG THÀNH CÔNG!';
GO
