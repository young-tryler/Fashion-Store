using System.ComponentModel.DataAnnotations;

// Ánh xạ với kết quả trả về của SP 2: sp_TopSanPhamBanChay
public class TopSanPhamBanChay
{
    public string MaSP { get; set; }
    public string TenSP { get; set; }
    public string TenLoai { get; set; } // Tên loại sản phẩm
    public int TongSoLuongBan { get; set; } // SUM(ctpb.SoLuong)
    public decimal TongDoanhThu { get; set; } // SUM(ctpb.ThanhTien)
    public bool DangBan { get; set; } // TrangThai sản phẩm
}