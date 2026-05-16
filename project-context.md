# PROJECT CONTEXT – MobileStore

## 1. TỔNG QUAN DỰ ÁN

| Mục              | Nội dung                                              |
|------------------|-------------------------------------------------------|
| Tên dự án        | MobileStore                                           |
| Công nghệ chính  | Java Servlet, JSP, JDBC                               |
| Java version     | 21                                                    |
| Server           | Apache Tomcat 11.0.11 (embedded via Cargo Maven)      |
| Database         | MySQL 8.0                                             |
| Build tool       | Maven 3.x                                             |
| Mô tả ngắn      | Ứng dụng web quản lý cửa hàng điện thoại di động (Apple Store) với đầy đủ chức năng e-commerce: quản lý sản phẩm, giỏ hàng, thanh toán, đơn hàng, và trang quản trị admin |

**Luồng xử lý tổng quát (Request Flow):**

```
Request → CharacterEncodingFilter (UTF-8) → [AdminAuthFilter (nếu /admin/*)] 
→ Servlet (Controller) → Service Layer → DAO Layer → MySQL Database
→ Response (JSP View)
```

---

## 2. CẤU TRÚC THƯ MỤC

```
Web-Mobilestore_Java/
├── pom.xml                           # Maven configuration
├── src/
│   └── main/
│       ├── java/com/mobilestore/
│       │   ├── config/                # Configuration classes (VNPay, Constants)
│       │   ├── constant/              # Constants (AppConstants, RoleConstants, OrderStatus)
│       │   ├── controller/            # User-facing Servlets (19 files)
│       │   │   ├── CartServlet.java
│       │   │   ├── CartCountServlet.java
│       │   │   ├── CheckoutServlet.java
│       │   │   ├── ForgotPasswordServlet.java
│       │   │   ├── GHNAddressServlet.java
│       │   │   ├── HomeServlet.java
│       │   │   ├── ImageServlet.java
│       │   │   ├── LoginServlet.java
│       │   │   ├── LogoutServlet.java
│       │   │   ├── OrderConfirmationServlet.java
│       │   │   ├── OrderTrackingServlet.java
│       │   │   ├── ProductsServlet.java
│       │   │   ├── ProfileServlet.java
│       │   │   ├── RegisterServlet.java
│       │   │   ├── ResetPasswordServlet.java
│       │   │   ├── ReviewServlet.java
│       │   │   ├── ToggleLikeServlet.java
│       │   │   ├── UserOrderServlet.java
│       │   │   └── VNPayServlet.java
│       │   │   └── admin/             # Admin Servlets (6 files)
│       │   │       ├── AdminCategoryServlet.java
│       │   │       ├── AdminDashboardServlet.java
│       │   │       ├── AdminOrderServlet.java
│       │   │       ├── AdminProductServlet.java
│       │   │       ├── AdminReviewServlet.java
│       │   │       └── AdminSliderServlet.java
│       │   ├── dao/                   # Data Access Objects (11 files)
│       │   │   ├── AdminDashboardDAO.java
│       │   │   ├── CartDAO.java
│       │   │   ├── CategoryDAO.java
│       │   │   ├── OrderDAO.java
│       │   │   ├── PasswordResetTokenDAO.java
│       │   │   ├── ProductDAO.java
│       │   │   ├── ProductVariantDAO.java
│       │   │   ├── ReviewDAO.java
│       │   │   ├── SliderImageDAO.java
│       │   │   ├── UserDAO.java
│       │   │   └── UserLikeDAO.java
│       │   ├── dto/                   # Data Transfer Objects
│       │   │   ├── request/           # Request DTOs
│       │   │   └── response/          # Response DTOs (ApiResponse, ErrorResponse, PageResponse)
│       │   ├── entity/                # Entity/Model classes (12 files)
│       │   │   ├── Cart.java
│       │   │   ├── CartItem.java
│       │   │   ├── Category.java
│       │   │   ├── Order.java
│       │   │   ├── OrderDetail.java
│       │   │   ├── PasswordResetToken.java
│       │   │   ├── Product.java
│       │   │   ├── ProductVariant.java
│       │   │   ├── Review.java
│       │   │   ├── ShippingStep.java
│       │   │   ├── SliderImage.java
│       │   │   └── User.java
│       │   ├── exception/             # Exception handling
│       │   │   ├── BusinessException.java
│       │   │   ├── GlobalExceptionHandler.java
│       │   │   ├── ResourceNotFoundException.java
│       │   │   └── ValidationException.java
│       │   ├── filter/               # Filters (2 files)
│       │   │   ├── AdminAuthFilter.java
│       │   │   └── CharacterEncodingFilter.java
│       │   ├── service/              # Service layer
│       │   │   ├── impl/             # Service implementations
│       │   │   ├── AdminDashboardService.java (+ impl)
│       │   │   ├── AuthService.java
│       │   │   ├── CartService.java (+ impl)
│       │   │   ├── CategoryService.java (+ impl)
│       │   │   ├── EmailService.java
│       │   │   ├── GHNService.java (+ impl)
│       │   │   ├── GoogleOAuthService.java
│       │   │   ├── OrderService.java (+ impl)
│       │   │   ├── PasswordResetService.java
│       │   │   ├── ProductService.java (+ impl)
│       │   │   ├── ProductVariantService.java (+ impl)
│       │   │   ├── ReviewService.java (+ impl)
│       │   │   ├── ShippingService.java (+ impl)
│       │   │   ├── SliderImageService.java (+ impl)
│       │   │   └── UserService.java
│       │   └── util/                  # Utilities
│       │       ├── DatabaseConnection.java
│       │       ├── DateFormatUtil.java
│       │       └── PasswordUtil.java
│       ├── resources/
│       │   ├── db.properties          # Database configuration
│       │   ├── mail.properties       # Email configuration
│       │   └── db/mobilestore.sql    # Database schema + seed data
│       └── webapp/
│           ├── index.jsp              # Root redirect
│           ├── vnpay_return.jsp       # VNPay payment return
│           ├── WEB-INF/
│           │   ├── web.xml            # Web configuration
│           │   └── views/
│           │       └── error/        # Error pages
│           │           ├── 404.jsp
│           │           └── 500.jsp
│           └── views/
│               ├── admin/             # Admin views
│               │   ├── dashboard/dashboard.jsp
│               │   ├── orders/{order-list, order-detail}.jsp
│               │   ├── products/{product-list, product-form}.jsp
│               │   ├── reviews/review-list.jsp
│               │   ├── sliders/{slider-list, slider-form}.jsp
│               │   └── common/admin-header.jsp
│               ├── auth/              # Authentication views
│               │   ├── forgot-password.jsp
│               │   ├── login.jsp
│               │   ├── order-confirmation.jsp
│               │   ├── order-detail.jsp
│               │   ├── order-tracking.jsp
│               │   ├── profile.jsp
│               │   ├── register.jsp
│               │   └── reset-password.jsp
│               ├── common/            # Shared components
│               │   ├── header.jsp
│               │   └── home.jsp
│               └── products/         # Product views
│                   ├── cart.jsp
│                   ├── checkout.jsp
│                   ├── product-detail.jsp
│                   └── product-list.jsp
└── target/                           # Build output (generated)
```

---

## 3. DANH SÁCH TÍNH NĂNG CHÍNH

### 👤 Khách hàng (Guest / User)

- [x] **Trang chủ** – Servlet: `HomeServlet.java` | JSP: `views/common/home.jsp`
- [x] **Xem danh sách sản phẩm** – Servlet: `ProductsServlet.java` | JSP: `views/products/product-list.jsp`
- [x] **Chi tiết sản phẩm** – Servlet: `ProductsServlet.java` | JSP: `views/products/product-detail.jsp`
- [x] **Giỏ hàng** – Servlet: `CartServlet.java` | JSP: `views/products/cart.jsp`
- [x] **Số lượng giỏ hàng (API)** – Servlet: `CartCountServlet.java`
- [x] **Thanh toán** – Servlet: `CheckoutServlet.java` | JSP: `views/products/checkout.jsp`
- [x] **Đăng nhập** – Servlet: `LoginServlet.java` | JSP: `views/auth/login.jsp`
- [x] **Đăng ký** – Servlet: `RegisterServlet.java` | JSP: `views/auth/register.jsp`
- [x] **Đăng xuất** – Servlet: `LogoutServlet.java`
- [x] **Quên mật khẩu** – Servlet: `ForgotPasswordServlet.java` | JSP: `views/auth/forgot-password.jsp`
- [x] **Đặt lại mật khẩu** – Servlet: `ResetPasswordServlet.java` | JSP: `views/auth/reset-password.jsp`
- [x] **Hồ sơ người dùng** – Servlet: `ProfileServlet.java` | JSP: `views/auth/profile.jsp`
- [x] **Xem đơn hàng** – Servlet: `UserOrderServlet.java` | JSP: `views/auth/order-detail.jsp`
- [x] **Theo dõi đơn hàng** – Servlet: `OrderTrackingServlet.java` | JSP: `views/auth/order-tracking.jsp`
- [x] **Xác nhận đơn hàng** – Servlet: `OrderConfirmationServlet.java` | JSP: `views/auth/order-confirmation.jsp`
- [x] **Đánh giá sản phẩm (API)** – Servlet: `ReviewServlet.java`
- [x] **Yêu thích sản phẩm (API)** – Servlet: `ToggleLikeServlet.java`
- [x] **Thanh toán VNPay** – Servlet: `VNPayServlet.java` | JSP: `vnpay_return.jsp`
- [x] **API GHN (Tỉnh/Quận/Phường)** – Servlet: `GHNAddressServlet.java`
- [x] **Hiển thị hình ảnh** – Servlet: `ImageServlet.java`

### 🔐 Người dùng đã đăng nhập (Authenticated User)

- [x] Tất cả tính năng khách hàng ở trên
- [x] Mua sản phẩm (yêu cầu đăng nhập)
- [x] Đặt hàng với thông tin lưu sẵn
- [x] Xem lịch sử đơn hàng
- [x] Đánh giá sản phẩm đã mua
- [x] Quản lý sản phẩm yêu thích
- [x] Cập nhật thông tin cá nhân

### 🛠️ Quản trị viên (Admin)

- [x] **Dashboard** – Servlet: `AdminDashboardServlet.java` | JSP: `views/admin/dashboard/dashboard.jsp`
- [x] **Quản lý sản phẩm (CRUD)** – Servlet: `AdminProductServlet.java` | JSP: `views/admin/products/`
- [x] **Quản lý danh mục (CRUD)** – Servlet: `AdminCategoryServlet.java`
- [x] **Quản lý đơn hàng** – Servlet: `AdminOrderServlet.java` | JSP: `views/admin/orders/`
- [x] **Quản lý đánh giá** – Servlet: `AdminReviewServlet.java` | JSP: `views/admin/reviews/`
- [x] **Quản lý Slider** – Servlet: `AdminSliderServlet.java` | JSP: `views/admin/sliders/`

---

## 4. CẤU TRÚC DATABASE (Tóm tắt)

> Đọc từ: `src/main/resources/db/mobilestore.sql`

### Danh sách bảng chính

| Tên bảng              | Mô tả ngắn                    | Các cột quan trọng                                      |
|-----------------------|-------------------------------|--------------------------------------------------------|
| `users`               | Thông tin người dùng          | `id`, `username`, `password`, `role_name`, `email`, `oauth_provider`, `oauth_id`, `shipping_address`, `customer_phone`, `district_id`, `ward_code` |
| `categories`         | Danh mục sản phẩm            | `category_id`, `category_name`                        |
| `products`            | Sản phẩm                     | `product_id`, `product_name`, `manufacturer`, `product_condition`, `product_info`, `category_id`, `discount` |
| `product_variants`    | Biến thể sản phẩm (màu/RAM)  | `variant_id`, `product_id`, `color`, `storage`, `price`, `quantity_in_stock`, `variant_image` |
| `orders`              | Đơn hàng                     | `order_id`, `user_id`, `order_status`, `order_date`, `total_amount`, `shipping_address`, `customer_phone`, `payment_method`, `payment_status`, `vnp_transaction_id`, `shipping_cost`, `district_id`, `ward_code`, `tracking_number` |
| `order_details`       | Chi tiết đơn hàng            | `id`, `order_id`, `variant_id`, `price`, `quantity`  |
| `cart`                | Giỏ hàng                    | `id`, `user_id`, `variant_id`, `quantity`            |
| `reviews`             | Đánh giá sản phẩm           | `id`, `user_id`, `product_id`, `rating`, `comment`, `admin_reply`, `admin_reply_at`, `created_at`, `is_approved` |
| `slider_images`       | Hình ảnh slider              | `id`, `image_url`, `is_active`                        |
| `user_likes`          | Sản phẩm yêu thích           | `id`, `customer_id`, `product_id`                     |
| `password_reset_tokens` | Token đặt lại mật khẩu    | `id`, `token`, `user_id`, `email`, `expires_at`, `used`, `created_at` |

### Quan hệ chính (ERD tóm tắt)

```
users (1) ──────< (N) orders
users (1) ──────< (N) cart
users (1) ──────< (N) user_likes
users (1) ──────< (N) reviews
users (1) ──────< (N) password_reset_tokens

categories (1) ──────< (N) products

products (1) ──────< (N) product_variants
products (1) ──────< (N) reviews
products (1) ──────< (N) user_likes

orders (1) ──────< (N) order_details
product_variants (1) ──────< (N) order_details
product_variants (1) ──────< (N) cart
```

---

## 5. LƯU Ý ĐẶC BIỆT & CODING CONVENTIONS

### 5.1 Các Lỗi Thường Gặp – PHẢI TRÁNH

| # | Lỗi                                      | Nguyên nhân                        | Cách tránh                              |
|---|------------------------------------------|------------------------------------|-----------------------------------------|
| 1 | `NullPointerException` khi lấy session   | Không kiểm tra session trước       | Luôn check `session != null` và attribute tồn tại trước khi cast |
| 2 | SQL Injection                            | Dùng `Statement` thay vì `PreparedStatement` | **BẮT BUỘC** dùng `PreparedStatement` cho mọi query có tham số |
| 3 | Connection leak                          | Không đóng Connection sau dùng     | Dùng `try-with-resources` hoặc đóng trong `finally` |
| 4 | Redirect sau POST bị thiếu              | Không áp dụng PRG pattern          | Sau xử lý POST thành công → `response.sendRedirect(...)` |
| 5 | Hard-code URL trong JSP                 | Dùng path tuyệt đối không linh hoạt| Dùng `${pageContext.request.contextPath}` |
| 6 | Xóa sản phẩm có đơn hàng liên quan     | Không kiểm tra ràng buộc           | Kiểm tra order_details trước khi xóa product |
| 7 | Race condition khi cập nhật tồn kho    | Đọc-sửa-ghi không an toàn          | Dùng SQL `UPDATE ... SET stock = stock - ?` thay vì read-modify-write |
| 8 | Hardcoded file paths                    | Dùng đường dẫn tuyệt đối           | Dùng `ServletContext.getRealPath()` hoặc config |

---

### 5.2 Cơ Chế Xử Lý Lỗi Chung (Error Handling Strategy)

**Quy tắc bắt buộc:**

1. **Tầng DAO:** Chỉ ném `SQLException` lên tầng trên, KHÔNG tự xử lý logic trong catch.

2. **Tầng Service:** Bắt exception từ DAO, log lại, ném `RuntimeException` hoặc custom exception lên Controller.

3. **Tầng Servlet/Controller:** Là nơi duy nhất quyết định hiển thị lỗi cho người dùng.

```java
// Pattern xử lý lỗi trong Servlet
try {
    // gọi service
} catch (BusinessException e) {
    request.setAttribute("errorMessage", e.getMessage());
    request.getRequestDispatcher("/views/error/500.jsp")
           .forward(request, response);
} catch (Exception e) {
    log.error("Unexpected error", e);
    request.setAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn");
    request.getRequestDispatcher("/views/error/500.jsp")
           .forward(request, response);
}
```

4. **Trang lỗi chung:** Mọi lỗi không handle được forward đến `/WEB-INF/views/error/500.jsp`.
   - Error code 404 → `/WEB-INF/views/error/404.jsp`
   - Error code 500 → `/WEB-INF/views/error/500.jsp`

5. **Không để stack trace lộ ra ngoài giao diện người dùng.**

---

### 5.3 Quy Tắc Truy Cập Database

> ⚠️ **BẮT BUỘC:** Mọi truy vấn SQL phải thông qua lớp `DatabaseConnection` để đảm bảo đóng/mở connection đúng cách.

```java
// ✅ ĐÚNG – Dùng DatabaseConnection + try-with-resources
public class ProductDAO {
    public List<Product> getAll() throws SQLException {
        String sql = "SELECT * FROM products WHERE active = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, 1);
            try (ResultSet rs = ps.executeQuery()) {
                // map results...
            }
        }
    }
}

// ❌ SAI – Tự tạo connection trực tiếp
Connection conn = DriverManager.getConnection(...); // KHÔNG làm thế này
```

**Các quy tắc DAO khác:**
- Mỗi bảng DB có đúng **1 file DAO** tương ứng
- Tên method theo chuẩn: `getById`, `getAll`, `findById`, `findAll`, `create`, `insert`, `update`, `delete`, `save`
- Không viết business logic trong DAO
- Nên dùng `mapResultSetToEntity()` helper method cho việc mapping

---

### 5.4 Quy Tắc Phân Quyền & Session

```java
// Mọi trang cần đăng nhập phải check ở đầu Servlet
HttpSession session = request.getSession(false);
if (session == null || session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return; // <-- QUAN TRỌNG: phải có return sau redirect
}
```

- `role_name = "ADMIN"` → Truy cập được trang quản trị `/admin/*`
- `role_name = "CUSTOMER"` → Chỉ truy cập trang khách hàng
- OAuth users có `oauth_provider` != null, không có password local
- Session timeout: **30 phút** (config trong `web.xml`)

**AdminAuthFilter** tự động kiểm tra quyền cho tất cả request `/admin/*`

---

### 5.5 Servlet Mapping & URL Convention

| URL Pattern              | Servlet Class              | Chức năng                      |
|-------------------------|----------------------------|--------------------------------|
| `/`, `/home`, `/index`  | `HomeServlet`              | Trang chủ                      |
| `/products`, `/products/*` | `ProductsServlet`       | Danh sách/chi tiết sản phẩm    |
| `/cart`                 | `CartServlet`              | Giỏ hàng                      |
| `/cart/count`           | `CartCountServlet`          | API số lượng giỏ hàng          |
| `/checkout`             | `CheckoutServlet`           | Thanh toán                     |
| `/login`                | `LoginServlet`              | Đăng nhập                     |
| `/register`             | `RegisterServlet`           | Đăng ký                       |
| `/logout`               | `LogoutServlet`             | Đăng xuất                     |
| `/profile`              | `ProfileServlet`           | Hồ sơ người dùng              |
| `/forgot-password`      | `ForgotPasswordServlet`     | Quên mật khẩu                 |
| `/reset-password`       | `ResetPasswordServlet`     | Đặt lại mật khẩu              |
| `/order-confirmation`   | `OrderConfirmationServlet` | Xác nhận đơn hàng             |
| `/my-orders`            | `UserOrderServlet`         | Danh sách đơn hàng            |
| `/order-tracking`       | `OrderTrackingServlet`     | Theo dõi đơn hàng              |
| `/api/reviews`          | `ReviewServlet`            | API đánh giá                   |
| `/api/toggle-like`      | `ToggleLikeServlet`        | API yêu thích                 |
| `/api/ghn/*`            | `GHNAddressServlet`        | API GHN shipping              |
| `/vnpay-payment`        | `VNPayServlet`             | Thanh toán VNPay              |
| `/images/*`             | `ImageServlet`             | Phục vụ hình ảnh              |
| `/admin/dashboard`      | `AdminDashboardServlet`    | Dashboard admin                |
| `/admin/products`       | `AdminProductServlet`       | Quản lý sản phẩm              |
| `/admin/categories`     | `AdminCategoryServlet`     | Quản lý danh mục              |
| `/admin/orders`         | `AdminOrderServlet`        | Quản lý đơn hàng              |
| `/admin/reviews`        | `AdminReviewServlet`       | Quản lý đánh giá              |
| `/admin/sliders`        | `AdminSliderServlet`       | Quản lý slider                |

---

### 5.6 Các Thư Viện / Dependencies Quan Trọng

| Thư viện                  | Version   | Mục đích sử dụng                    |
|---------------------------|-----------|-------------------------------------|
| Jakarta Servlet API       | 6.0.0     | Core Servlet/Filter API            |
| Jakarta JSP API           | 3.1.1     | JSP support                         |
| Jakarta JSTL              | 3.0.0     | Tag library trong JSP              |
| MySQL Connector/J         | 8.0.33    | Kết nối MySQL database             |
| Lombok                    | 1.18.36   | Auto-generate getters/setters      |
| BCrypt (jbcrypt)          | 0.4       | Hash password an toàn              |
| java-jwt                  | 4.4.0     | Parse Google OAuth ID Token        |
| Gson                      | 2.10.1    | JSON parsing/serialization        |
| Jakarta Mail              | 2.0.1     | Gửi email qua SMTP                |
| Jakarta Validation        | 3.0.2     | Bean validation                     |
| Hibernate Validator       | 8.0.1.Final | Validation implementation        |

---

### 5.7 Các Constants Quan Trọng

| Class                    | Các giá trị                                  |
|--------------------------|----------------------------------------------|
| `RoleConstants`          | `ADMIN = "ADMIN"`, `CUSTOMER = "CUSTOMER"`   |
| `OrderStatus`            | `PENDING`, `PROCESSING`, `SHIPPED`, `DELIVERED`, `CANCELLED` |
| `PaymentMethod`          | `CASH`, `VNPAY`                              |
| `PaymentStatus`          | `PENDING`, `PAID`, `FAILED`                 |
| `AppConstants`           | Context path, upload config, etc.            |

---

## 6. HƯỚNG DẪN SETUP & CHẠY PROJECT

### Yêu cầu hệ thống

- Java 21+
- Maven 3.6+
- MySQL 8.0+
- (Tùy chọn) Tomcat 11.x

### Các bước setup

```bash
# 1. Clone project và di chuyển vào thư mục
cd Web-Mobilestore_Java

# 2. Tạo database MySQL
mysql -u root -p
CREATE DATABASE mobilestore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;

# 3. Import database schema + seed data
mysql -u root -p mobilestore < src/main/resources/db/mobilestore.sql

# 4. Cấu hình database connection
# Sửa file: src/main/resources/db.properties
# Thay đổi các giá trị:
#   db.url=jdbc:mysql://localhost:3306/mobilestore
#   db.username=root
#   db.password=YOUR_PASSWORD

# 5. (Tùy chọn) Cấu hình email
# Sửa file: src/main/resources/mail.properties

# 6. Build project
mvn clean package

# 7. Chạy ứng dụng
mvn cargo:run

# Hoặc deploy file WAR vào Tomcat
# cp target/mobile-store.war $TOMCAT_HOME/webapps/
```

### Truy cập ứng dụng

- **Website:** http://localhost:8080/mobilestore
- **Admin Panel:** http://localhost:8080/mobilestore/admin/dashboard
  - Username: `levantai`
  - Password: `1317192005` (hoặc xem trong db.properties)

---

## 7. CÁC TÍNH NĂNG TÍCH HỢP BÊN THỨ BA

| Service        | Mục đích                                      | API Key/Config                  |
|----------------|-----------------------------------------------|---------------------------------|
| **VNPay**      | Thanh toán trực tuyến qua ATM/Visa           | Cấu hình trong `VNPayConfig`   |
| **GHN**        | Giao hàng nhanh - lấy địa chỉ, tính phí ship | API GHN Integration             |
| **Google OAuth** | Đăng nhập bằng tài khoản Google             | Google Cloud Console           |
| **Email SMTP** | Gửi email (đặt lại mật khẩu)                | Cấu hình trong `mail.properties` |

---

## 8. CHECKLIST TRƯỚC KHI COMMIT CODE

- [ ] Không để lộ thông tin nhạy cảm (password, API key) trong code
- [ ] Mọi input từ user đều được validate phía server
- [ ] Dùng `PreparedStatement` cho tất cả SQL query
- [ ] Đã test các case: thành công, thất bại, dữ liệu rỗng
- [ ] Không có `System.out.println` debug còn sót lại
- [ ] Tất cả connection/resource được đóng đúng cách (try-with-resources)
- [ ] JSP không chứa business logic (chỉ hiển thị)
- [ ] Áp dụng PRG pattern sau khi xử lý POST thành công
- [ ] Dùng `${pageContext.request.contextPath}` cho mọi URL trong JSP
- [ ] Kiểm tra quyền truy cập trước khi xử lý request

---

## 9. GHI CHÚ BỔ SUNG

### Database Schema có 2 phiên bản (legacy + current)

Project hiện tại có 2 nhóm bảng:
- **Legacy tables** (không sử dụng): `category`, `product`, `product_variant`, `order`, `order_detail`, `cart_item`, `review`, `shipping_step`, `slider_image`, `password_reset_token`
- **Current tables** (đang sử dụng): `categories`, `products`, `product_variants`, `orders`, `order_details`, `cart`, `reviews`, `slider_images`, `user_likes`, `password_reset_tokens`

> ⚠️ Cần xóa legacy tables và code liên quan để tránh confuse.

### Image Upload

- Upload qua `AdminProductServlet` và `AdminSliderServlet`
- Lưu trong thư mục: `src/main/webapp/uploads/` hoặc `src/main/webapp/images/`
- Max upload size: 5MB (config trong `web.xml`)

### VNPay Return URL

- URL thành công: `/mobilestore/vnpay_return.jsp`
- Xử lý kết quả thanh toán và hiển thị cho user

---

*Document generated: 2026-05-15*
*Last updated by: AI Assistant*
