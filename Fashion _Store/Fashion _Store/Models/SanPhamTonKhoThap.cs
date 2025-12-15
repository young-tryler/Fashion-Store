using System;
using System.ComponentModel.DataAnnotations;

// Ánh xạ với kết quả trả về của SP 3: sp_SanPhamTonKhoThap
public class SanPhamTonKhoThap
{
    public string MaSP { get; set; }
    public string TenSP { get; set; }
    public string TenMau { get; set; }
    public string TenSize { get; set; }
    public int SoLuongTon { get; set; }
    public string MaCTSP { get; set; }
    public string TrangThai { get; set; } // Hiển thị / Đã ẩn
}