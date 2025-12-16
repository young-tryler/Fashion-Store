using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web;
using Fashion__Store.Models;

namespace Fashion__Store.Areas.Admin.Models
{
    public class ProductViewModel
    {
        public int ProductId { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập tên sản phẩm")]
        [Display(Name = "Tên sản phẩm")]
        public string ProductName { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mã SKU")]
        public string SKU { get; set; }

        [Display(Name = "Đường dẫn (Slug)")]
        public string Slug { get; set; }

        [Display(Name = "Mô tả")]
        public string Description { get; set; }

        [Required]
        [Display(Name = "Giá gốc")]
        public decimal BasePrice { get; set; }

        [Display(Name = "Trạng thái")]
        public bool IsActive { get; set; }

        // Dùng để hứng dữ liệu từ MultiSelect List (Danh mục)
        [Display(Name = "Danh mục")]
        public int[] SelectedCategoryIds { get; set; }

        // Dùng để upload ảnh đại diện (Tạm thời 1 ảnh chính)
        [Display(Name = "Ảnh đại diện")]
        public HttpPostedFileBase PrimaryImage { get; set; }
    }
}