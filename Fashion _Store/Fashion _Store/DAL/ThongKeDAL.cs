// Cần cài đặt Dapper và System.Data.SqlClient (hoặc Microsoft.Data.SqlClient)
using Dapper;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient; // hoặc System.Data.SqlClient

public class ThongKeDAL
{
    private readonly string connectionString;

    public ThongKeDAL()
    {
        // Lấy chuỗi kết nối từ Web.config
        connectionString = ConfigurationManager.ConnectionStrings["PHUKIEN_THOITRANG_DB"].ConnectionString;
    }

    // Lấy dữ liệu từ v_ThongKeNhanh
    public v_ThongKeNhanh GetThongKeNhanh()
    {
        using (IDbConnection db = new SqlConnection(connectionString))
        {
            // QueryFirstOrDefault phù hợp với View này vì nó chỉ trả về 1 hàng
            return db.QueryFirstOrDefault<v_ThongKeNhanh>("SELECT * FROM v_ThongKeNhanh");
        }
    }

    // Thực thi SP sp_SanPhamTonKhoThap
    public IEnumerable<SanPhamTonKhoThap> GetSanPhamTonKhoThap(int nguong = 10)
    {
        using (IDbConnection db = new SqlConnection(connectionString))
        {
            var parameters = new { Nguong = nguong };
            // Thực thi Stored Procedure
            return db.Query<SanPhamTonKhoThap>("sp_SanPhamTonKhoThap", parameters, commandType: CommandType.StoredProcedure);
        }
    }

    // Thêm hàm lấy doanh thu hôm nay
    public decimal GetDoanhThuHomNay()
    {
        using (IDbConnection db = new SqlConnection(connectionString))
        {
            // Giả định bạn đã tạo một SP mới hoặc sử dụng truy vấn trực tiếp
            // để lấy doanh thu của ngày hiện tại (TrangThai = N'Hoàn thành')
            string sql = "SELECT ISNULL(SUM(ThanhToan), 0) FROM PHIEU_BAN_HANG WHERE CAST(NgayBan AS DATE) = CAST(GETDATE() AS DATE) AND TrangThai = N'Hoàn thành'";
            return db.ExecuteScalar<decimal>(sql);
        }
    }

    public IEnumerable<PhieuBanHangViewModel> GetRecentOrders(int count = 5)
    {
        using (IDbConnection db = new SqlConnection(connectionString))
        {
            // Truy vấn để lấy N đơn hàng gần nhất, JOIN với KH để lấy tên
            string sql = @"
            SELECT TOP (@Count)
                PBH.MaPhieuBan, 
                KH.TenKH, 
                PBH.TongTien, 
                PBH.TrangThai, 
                PBH.NgayBan 
            FROM PHIEU_BAN_HANG PBH
            INNER JOIN KHACH_HANG KH ON PBH.MaKH = KH.MaKH
            ORDER BY PBH.NgayBan DESC";

            return db.Query<PhieuBanHangViewModel>(sql, new { Count = count });
        }
    }
    public IEnumerable<TopSanPhamBanChay> GetTopSellingProducts(int soLuong = 4)
    {
        using (IDbConnection db = new SqlConnection(connectionString))
        {
            // SP sp_TopSanPhamBanChay nhận tham số @SoLuong
            var parameters = new { SoLuong = soLuong };

            return db.Query<TopSanPhamBanChay>("sp_TopSanPhamBanChay", parameters, commandType: CommandType.StoredProcedure);
        }
    }
}