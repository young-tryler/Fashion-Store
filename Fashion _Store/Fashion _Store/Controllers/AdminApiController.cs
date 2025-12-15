using System.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

// Sử dụng namespace của các tầng BLL và Model
// using YourProjectName.BLL; 
// using YourProjectName.Models; 

public class AdminApiController : Controller
{
    private readonly ThongKeBLL _thongKeBLL;

    public AdminApiController()
    {
        _thongKeBLL = new ThongKeBLL();
    }

    // GET: /AdminApi/GetDashboardStats
    [HttpGet]
    public ActionResult GetDashboardStats()
    {
        try
        {
            var stats = _thongKeBLL.GetThongKeNhanh();
            var doanhThuHomNay = _thongKeBLL.GetDoanhThuHomNay();

            // Trả về JSON, sử dụng JsonRequestBehavior.AllowGet cho yêu cầu GET
            return Json(new
            {
                success = true,
                doanhThuHomNay = doanhThuHomNay, // Giá trị thực tế từ DAL
                donHangHoanThanh = stats.DonHangHoanThanh, // Có thể dùng cho thống kê
                sanPhamSapHet = stats.SanPhamSapHet,
                khachHangHoatDong = stats.KhachHangHoatDong // Có thể dùng cho thống kê
                // Bạn có thể thêm các tính toán % thay đổi nếu có dữ liệu hôm qua/tuần trước
            }, JsonRequestBehavior.AllowGet);
        }
        catch (Exception ex)
        {
            // Ghi log lỗi
            return Json(new { success = false, message = "Lỗi hệ thống: " + ex.Message }, JsonRequestBehavior.AllowGet);
        }
    }

    // GET: /AdminApi/GetLowStockAlerts
    [HttpGet]
    public ActionResult GetLowStockAlerts(int nguong = 10)
    {
        try
        {
            var lowStockList = _thongKeBLL.GetSanPhamTonKhoThap(nguong);

            return Json(new
            {
                success = true,
                data = lowStockList.ToList()
            }, JsonRequestBehavior.AllowGet);
        }
        catch (Exception ex)
        {
            // Ghi log lỗi
            return Json(new { success = false, message = "Lỗi hệ thống: " + ex.Message }, JsonRequestBehavior.AllowGet);
        }
    }
    // Trong AdminApiController.cs

    private readonly ThongKeBLL _donHangBLL = new ThongKeBLL(); // Giả định có BLL đơn hàng

    // GET: /AdminApi/GetRecentOrders
    [HttpGet]
    public ActionResult GetRecentOrders()
    {
        try
        {
            var recentOrders = _donHangBLL.GetRecentOrders(4); // Lấy 4 đơn hàng gần nhất

            return Json(new
            {
                success = true,
                data = recentOrders.ToList()
            }, JsonRequestBehavior.AllowGet);
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = "Lỗi khi tải đơn hàng: " + ex.Message }, JsonRequestBehavior.AllowGet);
        }
    }
    // GET: /AdminApi/GetTopSellingProducts
    [HttpGet]
    public ActionResult GetTopSellingProducts()
    {
        try
        {
            // Gọi BLL để lấy 4 sản phẩm bán chạy nhất
            var topProducts = _thongKeBLL.GetTopSellingProducts(4);

            return Json(new
            {
                success = true,
                data = topProducts.ToList()
            }, JsonRequestBehavior.AllowGet);
        }
        catch (Exception ex)
        {
            return Json(new { success = false, message = "Lỗi khi tải Sản phẩm bán chạy: " + ex.Message }, JsonRequestBehavior.AllowGet);
        }
    }
}