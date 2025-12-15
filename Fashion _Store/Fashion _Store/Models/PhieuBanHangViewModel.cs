using System;
using System.ComponentModel.DataAnnotations;

public class PhieuBanHangViewModel
{
    [Display(Name = "Mã ĐH")]
    public string MaPhieuBan { get; set; }

    [Display(Name = "Khách Hàng")]
    public string TenKH { get; set; } // Tên khách hàng từ bảng KHACH_HANG

    [Display(Name = "Tổng Tiền")]
    public decimal TongTien { get; set; } // Tổng tiền trước giảm giá

    [Display(Name = "Trạng Thái")]
    public string TrangThai { get; set; } // Ví dụ: Chờ xử lý, Đang giao, Hoàn thành

    [Display(Name = "Thời Gian")]
    public DateTime NgayBan { get; set; } // Ngày/giờ bán
}