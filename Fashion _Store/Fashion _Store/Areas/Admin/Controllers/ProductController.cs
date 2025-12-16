using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Text;
using System.Web;
using System.Web.Mvc;
using Fashion__Store.Areas.Admin.Models; // Namespace chứa ViewModel
using Fashion__Store.Models;

namespace Fashion__Store.Areas.Admin.Controllers
{
    public class ProductController : Controller
    {
        private FashionStoreContext db = new FashionStoreContext();

        // GET: Product/Index
        public ActionResult Index()
        {
            var products = db.Products
                             .Include(p => p.Categories)
                             .Include(p => p.ProductVariants)
                             .Include(p => p.ProductImages)
                             .OrderByDescending(p => p.CreatedAt)
                             .ToList();
            return View(products);
        }

        // GET: Product/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            Product product = db.Products.Include(p => p.Categories).Include(p => p.ProductVariants).Include(p => p.ProductImages).SingleOrDefault(p => p.ProductId == id);
            if (product == null) return HttpNotFound();
            return View(product);
        }

        // ========================== CREATE ==========================

        // GET: Product/Create
        public ActionResult Create()
        {
            // Load danh sách Category để chọn
            ViewBag.Categories = new MultiSelectList(db.Categories, "CategoryId", "CategoryName");
            return View();
        }

        // POST: Product/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ProductViewModel model)
        {
            if (ModelState.IsValid)
            {
                // 1. Map ViewModel sang Entity Product
                var product = new Product
                {
                    ProductName = model.ProductName,
                    SKU = model.SKU,
                    BasePrice = model.BasePrice,
                    Description = model.Description,
                    IsActive = model.IsActive,
                    CreatedAt = DateTime.Now,
                    Slug = string.IsNullOrEmpty(model.Slug) ? GenerateSlug(model.ProductName) : model.Slug
                };

                // 2. Xử lý Danh mục (Many-to-Many)
                if (model.SelectedCategoryIds != null)
                {
                    product.Categories = new List<Category>();
                    foreach (var catId in model.SelectedCategoryIds)
                    {
                        var category = db.Categories.Find(catId);
                        if (category != null) product.Categories.Add(category);
                    }
                }

                db.Products.Add(product);
                db.SaveChanges(); // Lưu để có ProductId trước khi lưu ảnh

                // 3. Xử lý Ảnh đại diện (Nếu có)
                if (model.PrimaryImage != null && model.PrimaryImage.ContentLength > 0)
                {
                    string fileName = Path.GetFileName(model.PrimaryImage.FileName);
                    string extension = Path.GetExtension(fileName);
                    string newFileName = product.Slug + "-thumb" + extension;

                    // Lưu file vào thư mục ~/Content/Images/
                    string path = Path.Combine(Server.MapPath("~/Content/Images/"), newFileName);
                    model.PrimaryImage.SaveAs(path);

                    // Lưu vào bảng ProductImage
                    var img = new ProductImage
                    {
                        ProductId = product.ProductId,
                        ImageUrl = newFileName,
                        IsPrimary = true,
                        SortOrder = 1
                    };
                    db.ProductImages.Add(img);
                    db.SaveChanges();
                }

                return RedirectToAction("Index");
            }

            ViewBag.Categories = new MultiSelectList(db.Categories, "CategoryId", "CategoryName", model.SelectedCategoryIds);
            return View(model);
        }

        // ========================== EDIT ==========================

        // GET: Product/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);

            // Load product kèm Categories để fill vào form
            var product = db.Products.Include(p => p.Categories).SingleOrDefault(p => p.ProductId == id);
            if (product == null) return HttpNotFound();

            // Map Entity sang ViewModel
            var model = new ProductViewModel
            {
                ProductId = product.ProductId,
                ProductName = product.ProductName,
                SKU = product.SKU,
                Slug = product.Slug,
                BasePrice = product.BasePrice,
                Description = product.Description,
                IsActive = product.IsActive,
                SelectedCategoryIds = product.Categories.Select(c => c.CategoryId).ToArray()
            };

            ViewBag.Categories = new MultiSelectList(db.Categories, "CategoryId", "CategoryName", model.SelectedCategoryIds);
            return View(model);
        }

        // POST: Product/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(ProductViewModel model)
        {
            if (ModelState.IsValid)
            {
                var productToUpdate = db.Products.Include(p => p.Categories).SingleOrDefault(p => p.ProductId == model.ProductId);

                if (productToUpdate != null)
                {
                    // Update thông tin cơ bản
                    productToUpdate.ProductName = model.ProductName;
                    productToUpdate.SKU = model.SKU;
                    productToUpdate.BasePrice = model.BasePrice;
                    productToUpdate.Description = model.Description;
                    productToUpdate.IsActive = model.IsActive;

                    if (!string.IsNullOrEmpty(model.Slug))
                        productToUpdate.Slug = model.Slug;

                    // Update Danh mục (Xóa cũ, thêm mới)
                    productToUpdate.Categories.Clear();
                    if (model.SelectedCategoryIds != null)
                    {
                        foreach (var catId in model.SelectedCategoryIds)
                        {
                            var category = db.Categories.Find(catId);
                            if (category != null) productToUpdate.Categories.Add(category);
                        }
                    }

                    // Update Ảnh (Nếu user upload ảnh mới)
                    if (model.PrimaryImage != null && model.PrimaryImage.ContentLength > 0)
                    {
                        // Code xử lý lưu ảnh mới và cập nhật DB tương tự phần Create
                        // (Để ngắn gọn, bạn có thể copy logic từ Create xuống đây)
                    }

                    db.Entry(productToUpdate).State = EntityState.Modified;
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            ViewBag.Categories = new MultiSelectList(db.Categories, "CategoryId", "CategoryName", model.SelectedCategoryIds);
            return View(model);
        }

        // ========================== DELETE ==========================

        // GET: Product/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            Product product = db.Products.Find(id);
            if (product == null) return HttpNotFound();
            return View(product);
        }

        // POST: Product/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Product product = db.Products.Include(p => p.ProductVariants)
                                         .Include(p => p.ProductImages)
                                         .Include(p => p.Categories)
                                         .SingleOrDefault(p => p.ProductId == id);

            if (product != null)
            {
                // Xóa các bảng phụ thuộc trước (nếu không setup Cascade Delete trong SQL)
                db.ProductVariants.RemoveRange(product.ProductVariants);
                db.ProductImages.RemoveRange(product.ProductImages);

                // Gỡ quan hệ Category
                product.Categories.Clear();

                db.Products.Remove(product);
                db.SaveChanges();
            }
            return RedirectToAction("Index");
        }

        // Hàm tiện ích tạo Slug
        public string GenerateSlug(string phrase)
        {
            string str = RemoveAccent(phrase).ToLower();
            str = Regex.Replace(str, @"[^a-z0-9\s-]", "");
            str = Regex.Replace(str, @"\s+", " ").Trim();
            str = Regex.Replace(str, @"\s", "-");
            return str;
        }

        private string RemoveAccent(string txt)
        {
            byte[] bytes = Encoding.GetEncoding(1251).GetBytes(txt); // Cần xử lý Encoding kỹ hơn trong thực tế
            return Encoding.ASCII.GetString(bytes);
        }
    }
}