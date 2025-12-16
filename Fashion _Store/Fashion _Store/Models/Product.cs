using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Fashion__Store.Models
{
    [Table("Product")] // Ánh xạ tên Class Product tới bảng Product
    public class Product
    {
        [Key]
        public int ProductId { get; set; }

        [StringLength(40)]
        public string SKU { get; set; } // Mã sản phẩm nội bộ

        [Required]
        [StringLength(180)]
        public string ProductName { get; set; }

        [StringLength(120)]
        public string Slug { get; set; }

        public string Description { get; set; }

        public decimal BasePrice { get; set; }

        public bool IsActive { get; set; }

        public DateTime CreatedAt { get; set; }

        // Mối quan hệ: Một Product có nhiều Variants (Size, Color)
        public virtual ICollection<ProductVariant> ProductVariants { get; set; }

        // Mối quan hệ: Nhiều-Nhiều với Category (qua bảng ProductCategory)
        public virtual ICollection<Category> Categories { get; set; }

        // Mối quan hệ: Một Product có nhiều hình ảnh
        public virtual ICollection<ProductImage> ProductImages { get; set; }
    }
}