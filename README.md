# MobileStore - Ứng Dụng Thương Mại Điện Tử

> Nền tảng thương mại điện tử dành cho các sản phẩm Apple: điện thoại, máy tính bảng, laptop và phụ kiện.

![Java](https://img.shields.io/badge/Java-21-blue.svg)
![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-6.0-green.svg)
![MySQL](https://img.shields.io/badge/MySQL-8.x-orange.svg)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-11.x-red.svg)

---

## Mục Lục

- [Tính Năng](#tính-năng)
- [Tech Stack](#tech-stack)
- [Cấu Trúc Project](#cấu-trúc-project)
- [Khởi Động Nhanh](#khởi-động-nhanh)
  - [Yêu Cầu](#yêu-cầu)
  - [Thiết Lập Database](#thiết-lập-database)
  - [Cấu Hình](#cấu-hình)
  - [Chạy Ứng Dụng](#chạy-ứng-dụng)
- [Ảnh Chụp Màn Hình](#ảnh-chụp-màn-hình)
- [API Endpoints](#api-endpoints)
- [Tích Hợp Bên Ngoài](#tích-hợp-bên-ngoài)
- [Tài Liệu Project](#tài-liệu-project)
- [Đóng Góp](#đóng-góp)

---

## Tính Năng

### Dành Cho Khách Hàng
- **Danh Mục Sản Phẩm** — Duyệt iPhone, iPad, MacBook theo danh mục, tìm kiếm, lọc theo giá
- **Chi Tiết Sản Phẩm** — Biến thể màu sắc/dung lượng, thông số kỹ thuật, hình ảnh, đánh giá
- **Giỏ Hàng** — Thêm, cập nhật, xóa sản phẩm (lưu trong session + database)
- **Thanh Toán** — Chọn địa chỉ giao hàng qua GHN API, tính phí vận chuyển
- **Thanh Toán Trực Tuyến** — Tích hợp VNPay (sandbox)
- **Theo Dõi Đơn Hàng** — Lịch sử đơn hàng, trạng thái, lịch sử vận chuyển GHN
- **Tài Khoản Người Dùng** — Đăng ký với xác minh OTP qua email, đăng nhập Google OAuth, đặt lại mật khẩu, quản lý hồ sơ
- **Yêu Thích** — Lưu sản phẩm yêu thích
- **Đánh Giá** — Đánh sao và bình luận sản phẩm đã mua

### Dành Cho Quản Trị
- **Dashboard** — Doanh thu theo ngày/tuần/tháng/quý/năm, thống kê đơn hàng, sản phẩm bán chạy, cảnh báo tồn kho thấp, xuất PDF
- **Quản Lý Sản Phẩm** — CRUD sản phẩm kèm biến thể, hình ảnh
- **Quản Lý Danh Mục** — CRUD danh mục với hình ảnh
- **Quản Lý Đơn Hàng** — Cập nhật trạng thái, nhập mã vận đơn, hủy đơn
- **Quản Lý Tồn Kho** — Số lượng tồn kho theo biến thể sản phẩm
- **Quản Lý Người Dùng** — CRUD người dùng, gán vai trò, xóa mềm
- **Duyệt Đánh Giá** — Phê duyệt/từ chối đánh giá, trả lời với tư cách admin
- **Quản Lý Sliders** — Banner khuyến mãi trên trang chủ

---

## Tech Stack

| Lớp | Công nghệ |
|-----|-----------|
| Frontend | JSP, JSTL, Bootstrap 5, jQuery |
| Backend | Java 21, Jakarta EE Servlet 6.0 |
| Database | MySQL 8.x |
| ORM | JDBC (thủ công) |
| Build | Maven 3.11 |
| Server | Apache Tomcat 11.x (embedded qua Cargo) |
| PDF | OpenPDF 1.3.30 |
| JSON | Gson 2.10.1 |
| HTTP | Apache HttpClient 5, java.net.http |
| Password | jBCrypt 0.4 |
| Validation | Hibernate Validator 8.0.1.Final |
| Logging | SLF4J 2.0.9 |

---

## Cấu Trúc Project

```
MobileStore/
├── pom.xml
├── src/main/
│   ├── java/com/mobilestore/
│   │   ├── config/          # EnvConfig, VNPayConfig
│   │   ├── constant/        # Enums & hằng số
│   │   ├── controller/      # Customer servlets
│   │   │   └── admin/      # Admin servlets
│   │   ├── dao/             # Data Access Objects
│   │   ├── dto/            # Data Transfer Objects
│   │   │   └── response/   # API response wrappers
│   │   ├── entity/         # Domain models (Lombok)
│   │   ├── exception/      # Custom exceptions + global handler
│   │   ├── filter/         # AdminAuthFilter, CharacterEncodingFilter
│   │   ├── service/        # Business logic interfaces
│   │   │   └── impl/       # Service implementations
│   │   └── util/           # DatabaseConnection, EmailConfig, etc.
│   ├── resources/
│   │   ├── db.properties
│   │   ├── mail.properties
│   │   └── db/mobilestore.sql
│   └── webapp/
│       ├── WEB-INF/web.xml
│       ├── views/           # JSP views (admin, auth, common, products)
│       ├── assets/          # CSS, JS, images
│       └── vnpay_return.jsp
├── README.md
├── INSTALL.md
└── project_context.md
```

---

## Khởi Động Nhanh

### Yêu Cầu

- **JDK 21** — [Adoptium](https://adoptium.net/) hoặc [Oracle](https://www.oracle.com/java/technologies/downloads/)
- **Maven 3.8+** — [Maven Download](https://maven.apache.org/download.cgi)
- **MySQL 8.x** — [MySQL Download](https://dev.mysql.com/downloads/mysql/)
- **Git** — để clone project

Kiểm tra cài đặt:

```bash
java -version    # phải hiển thị 21.x
mvn -version     # phải hiển thị 3.8+
mysql --version  # phải hiển thị 8.x
```

### Thiết Lập Database

1. Tạo MySQL database:

```sql
CREATE DATABASE mobilestore
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_vietnamese_ci;
```

2. Import schema và dữ liệu mẫu:

```bash
mysql -u root -p mobilestore < src/main/resources/db/mobilestore.sql
```

> File SQL nằm tại `src/main/resources/db/mobilestore.sql`, bao gồm toàn bộ bảng, indexes, foreign keys và dữ liệu mẫu (sản phẩm, người dùng, đơn hàng, ...).

### Cấu Hình

1. **Database credentials** — sửa `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/mobilestore?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh
db.username=root
db.password=your_password_here
```

2. **Email (SMTP)** — sửa `src/main/resources/mail.properties`:

```properties
smtp.host=smtp.gmail.com
smtp.port=587
smtp.username=your_email@gmail.com
smtp.password=your_app_password
smtp.from=your_email@gmail.com
smtp.auth=true
smtp.starttls.enable=true
```

> Để sử dụng Gmail SMTP, bật **2-Factor Authentication** và tạo **App Password** tại [Google Account → Security → App passwords](https://myaccount.google.com/apppasswords).

3. **External APIs** — sửa các file cấu hình tương ứng:

| Dịch vụ | File | Giá trị cần thay |
|---------|------|------------------|
| VNPay | `src/main/java/.../config/VNPayConfig.java` | `vnp_TmnCode`, `vnp_HashSecret`, `vnp_Url` |
| GHN | `src/main/java/.../service/impl/ShippingServiceImpl.java` | `GHN_TOKEN`, `GHN_SHOP_ID` |
| GHN Tracking | `src/main/java/.../service/impl/GHNServiceImpl.java` | `GHN_TOKEN`, `GHN_SHOP_ID` |
| Google OAuth | `src/main/java/.../service/GoogleOAuthService.java` | `CLIENT_ID` |

### Chạy Ứng Dụng

#### Cách 1: Maven Cargo (Khuyến nghị)

```bash
mvn clean compile
mvn cargo:run
```

Ứng dụng khởi động tại: **http://localhost:8080/mobilestore**

#### Cách 2: Deploy WAR lên Tomcat

```bash
mvn clean package
```

Copy `target/mobile-store.war` vào thư mục `webapps/` của Tomcat.



<!--
| Dashboard | Danh Sách Sản Phẩm | Thanh Toán |
|-----------|-------------------|------------|
| ![Dashboard](docs/screenshots/dashboard.png) | ![Products](docs/screenshots/products.png) | ![Checkout](docs/screenshots/checkout.png) |
-->

---

## API Endpoints

### Khách Hàng

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| GET | `/` | Trang chủ |
| GET | `/products` | Danh sách sản phẩm (lọc: danh mục, giá, tìm kiếm, sắp xếp, trang) |
| GET | `/product/{id}` | Chi tiết sản phẩm |
| GET | `/cart` | Xem giỏ hàng |
| POST | `/cart?action=add` | Thêm vào giỏ hàng |
| POST | `/cart?action=remove` | Xóa khỏi giỏ hàng |
| GET | `/checkout` | Trang thanh toán |
| POST | `/checkout` | Đặt hàng |
| GET | `/orders` | Lịch sử đơn hàng |
| GET | `/order-tracking` | Theo dõi đơn hàng |
| POST | `/order/cancel` | Hủy đơn hàng |
| GET | `/order-print?id={id}` | Tải hóa đơn PDF |
| GET | `/login` | Trang đăng nhập |
| POST | `/login` | Đăng nhập (email + password) |
| GET | `/register` | Trang đăng ký |
| POST | `/register` | Đăng ký tài khoản |
| POST | `/register/send-otp` | Gửi OTP qua email |
| POST | `/register/verify-otp` | Xác minh OTP |
| GET | `/forgot-password` | Trang quên mật khẩu |
| POST | `/forgot-password` | Yêu cầu đặt lại mật khẩu |
| GET | `/reset-password?token=...` | Trang đặt lại mật khẩu |
| GET | `/profile` | Hồ sơ người dùng |
| POST | `/review/add` | Gửi đánh giá sản phẩm |
| POST | `/like/*` | Thêm/bỏ yêu thích |

### Quản Trị

| Method | Endpoint | Mô tả |
|--------|----------|-------|
| GET | `/admin` | Dashboard |
| GET | `/admin/dashboard-pdf` | Xuất dashboard PDF |
| GET | `/admin/products` | Danh sách sản phẩm |
| POST | `/admin/products/create` | Tạo sản phẩm |
| POST | `/admin/products/edit` | Sửa sản phẩm |
| GET | `/admin/categories` | Danh sách danh mục |
| POST | `/admin/categories/create` | Tạo danh mục |
| GET | `/admin/orders` | Danh sách đơn hàng |
| POST | `/admin/orders/update` | Cập nhật trạng thái/mã vận đơn |
| GET | `/admin/users` | Danh sách người dùng |
| GET | `/admin/inventory` | Quản lý tồn kho |
| GET | `/admin/reviews` | Duyệt đánh giá |
| POST | `/admin/reviews/reply` | Trả lời đánh giá |
| GET | `/admin/sliders` | Quản lý slider |

---

## Tích Hợp Bên Ngoài

### VNPay (Cổng Thanh Toán)

Môi trường sandbox để testing. Cấu hình trong `VNPayConfig.java`:

- **Sandbox URL**: `https://sandbox.vnpayment.vn/paymentv2/vpcpay.html`
- **Return URL**: `http://localhost:8080/mobilestore/vnpay_return.jsp`
- Hỗ trợ: tạo thanh toán, xử lý return URL, refund API

### GHN (Giao Hàng Nhanh)

Sử dụng cho:
1. **Tra cứu địa chỉ** — tỉnh/thành/phường/xã qua GHN API
2. **Tính phí vận chuyển** — theo quận/huyện và phường/xã đích
3. **Theo dõi vận chuyển** — lịch sử tracking đơn hàng qua mã vận đơn

### Google OAuth

Cho phép đăng nhập bằng tài khoản Google. Cấu hình `CLIENT_ID` trong `GoogleOAuthService.java`.

### SMTP (Email)

Gmail SMTP để gửi OTP xác minh email khi đăng ký. Cấu hình trong `mail.properties`.

---





### Tiêu Chuẩn Code

- Tất cả câu SQL sử dụng `PreparedStatement` với placeholder `?` — **không bao giờ** nối chuỗi
- Sử dụng Lombok annotations (`@Getter`, `@Setter`, ...) cho các entity classes
- Sử dụng JSTL `<c:out>` cho toàn bộ output để tránh XSS
- Tuân thủ MVC pattern: Servlets → Services → DAOs
- Giữ business logic ở Service layer
---

