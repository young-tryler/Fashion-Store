using System;
using System.ComponentModel.DataAnnotations;

// Ánh xạ với View 3: v_ThongKeNhanh
public class v_ThongKeNhanh
{
    // Cần phải có thuộc tính tương ứng với tên cột trong View SQL
    // TongSanPhamDangBan (int)
    public int TongSanPhamDangBan { get; set; }

    // KhachHangHoatDong (int)
    public int KhachHangHoatDong { get; set; }

    // DonHangHoanThanh (int)
    public int DonHangHoanThanh { get; set; }

    // TongDoanhThu (decimal)
    public decimal TongDoanhThu { get; set; }

    // SanPhamSapHet (int)
    public int SanPhamSapHet { get; set; }
}