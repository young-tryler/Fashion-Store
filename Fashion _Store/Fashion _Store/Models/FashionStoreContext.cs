using System.Data.Entity;

namespace Fashion__Store.Models
{
    public class FashionStoreContext : DbContext
    {
        public FashionStoreContext() : base("name=FashionStoreContext")
        {
            // Tắt Database Initializer vì bạn đã có Database sẵn
            Database.SetInitializer<FashionStoreContext>(null);
        }

        // --- Các DbSet đã tạo/cập nhật ---
        public DbSet<Product> Products { get; set; }
        public DbSet<ProductVariant> ProductVariants { get; set; }
        public DbSet<ProductImage> ProductImages { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<CategoryGroup> CategoryGroups { get; set; }
        public DbSet<Size> Sizes { get; set; }
        public DbSet<Color> Colors { get; set; }

        // --- Người dùng và Đơn hàng MỚI THÊM ---
        public DbSet<AppUser> AppUsers { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderItem> OrderItems { get; set; }         // Đã thêm
        public DbSet<CustomerAddress> CustomerAddresses { get; set; } // Đã thêm
        public DbSet<Role> Roles { get; set; }                   // Đã thêm

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // 1. Ánh xạ quan hệ Nhiều-Nhiều (Product <-> Category)
            modelBuilder.Entity<Product>()
                .HasMany(p => p.Categories)
                .WithMany(c => c.Products)
                .Map(mc =>
                {
                    mc.MapLeftKey("ProductId");
                    mc.MapRightKey("CategoryId");
                    mc.ToTable("ProductCategory");
                });

            // 2. Ánh xạ quan hệ Nhiều-Nhiều (AppUser <-> Role)
            modelBuilder.Entity<AppUser>()
                .HasMany(u => u.Roles)
                .WithMany(r => r.AppUsers)
                .Map(mc =>
                {
                    mc.MapLeftKey("UserId");     // Tên cột FK trong bảng trung gian UserRole
                    mc.MapRightKey("Rid");       // Tên cột FK trong bảng trung gian UserRole
                    mc.ToTable("UserRole");      // Tên bảng trung gian
                });

            // 3. Ánh xạ tên bảng Order (Vì là từ khóa SQL)
            modelBuilder.Entity<Order>().ToTable("Order");

            base.OnModelCreating(modelBuilder);
        }
    }
}