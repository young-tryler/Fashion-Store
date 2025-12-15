using System.Collections.Generic;

public class ThongKeBLL
{
    private readonly ThongKeDAL _thongKeDAL;

    public ThongKeBLL()
    {
        _thongKeDAL = new ThongKeDAL();
    }

    public v_ThongKeNhanh GetThongKeNhanh()
    {
        return _thongKeDAL.GetThongKeNhanh();
    }

    public IEnumerable<SanPhamTonKhoThap> GetSanPhamTonKhoThap(int nguong = 10)
    {
        return _thongKeDAL.GetSanPhamTonKhoThap(nguong);
    }

    public decimal GetDoanhThuHomNay()
    {
        return _thongKeDAL.GetDoanhThuHomNay();
    }
    public IEnumerable<PhieuBanHangViewModel> GetRecentOrders(int count = 5)
    {
        return _thongKeDAL.GetRecentOrders(count);
    }
    public IEnumerable<TopSanPhamBanChay> GetTopSellingProducts(int soLuong = 4)
    {
        return _thongKeDAL.GetTopSellingProducts(soLuong);
    }
}