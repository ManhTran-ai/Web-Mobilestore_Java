# Hướng Dẫn Cài Đặt Tính Năng OTP Qua Email

## 1. Tạo bảng `otp_tokens` trong Database

Chạy câu lệnh SQL sau trong MySQL (qua MySQL Workbench, DBeaver, hoặc command line):

```bash
mysql -u root -p mobilestore < src/main/resources/db/mobilestore.sql
```

Hoặc copy nội dung từ file `src/main/resources/db/mobilestore.sql` và chạy trực tiếp trong MySQL client.

**Lưu ý:** Bảng `otp_tokens` sẽ lưu trữ:
- Mã OTP 6 chữ số
- Thời gian tạo và thời gian hết hạn (mặc định 5 phút)
- Số lần nhập sai (giới hạn 3 lần)
- Trạng thái đã sử dụng hay chưa

---

## 2. Cấu Hình Gmail App Password

### Bước 1: Bật xác minh 2 bước (2-Step Verification)
1. Vào [myaccount.google.com](https://myaccount.google.com)
2. Chọn **Security** bên thanh trái
3. Trong mục **How you sign in to Google**, chọn **2-Step Verification** → Bật lên

### Bước 2: Tạo App Password
1. Sau khi bật 2-Step Verification, quay lại trang **Security**
2. Trong mục **How you sign in to Google**, chọn **App passwords**
3. Chọn app: **Mail**
4. Chọn device: **Other (Custom name)** → Nhập `MobileStore`
5. Nhấn **Generate**
6. Copy App Password (16 ký tự, VD: `abcd efgh ijkl mnop` — bỏ khoảng trắng)

### Bước 3: Cập nhật `mail.properties`
Mở file `src/main/resources/mail.properties`:

```properties
smtp.enabled=true
smtp.host=smtp.gmail.com
smtp.port=587
smtp.username=your-email@gmail.com
smtp.password=YOUR_APP_PASSWORD_16_CHARS
smtp.from=your-email@gmail.com
smtp.auth=true
smtp.starttls.enable=true
smtp.ssl.trust=smtp.gmail.com

# OTP Configuration
otp.expiry.minutes=5
otp.max.attempts=3
otp.email.subject=[MobileStore] Mã xác nhận đăng nhập của bạn
```

Thay `your-email@gmail.com` và `YOUR_APP_PASSWORD_16_CHARS` bằng giá trị thực của bạn.

---

## 3. Danh Sách File Đã Tạo

### File mới tạo:
| File | Mô tả |
|------|--------|
| `src/main/resources/db/mobilestore.sql` | Schema bảng OTP (đã tích hợp) |
| `src/main/java/com/mobilestore/entity/OtpToken.java` | Model OTP |
| `src/main/java/com/mobilestore/dao/OtpTokenDAO.java` | DAO OTP |
| `src/main/java/com/mobilestore/util/EmailConfig.java` | Config email |
| `src/main/java/com/mobilestore/service/OtpService.java` | Service OTP |
| `src/main/java/com/mobilestore/controller/SendOtpServlet.java` | Servlet gửi OTP |
| `src/main/java/com/mobilestore/controller/VerifyOtpServlet.java` | Servlet xác thực OTP |
| `src/main/webapp/views/login-email.jsp` | Form nhập email |
| `src/main/webapp/views/login-otp.jsp` | Form nhập OTP |
| `OTP_SETUP_GUIDE.md` | Hướng dẫn setup |

### File đã sửa:
| File | Thay đổi |
|------|----------|
| `.gitignore` | Thêm `mail.properties` và `email.properties` |

---

## 4. Cách Test Tính Năng

### Bước 1: Chạy SQL
Chạy file `mobilestore.sql` để tạo bảng trong database.

### Bước 2: Build & Run
```bash
mvn clean package
mvn cargo:run
```

### Bước 3: Test
1. Mở trình duyệt: `http://localhost:8080/mobilestore`
2. Vào trang **Đăng Nhập**
3. Chọn **"Đăng nhập bằng Email"** hoặc truy cập trực tiếp: `/mobilestore/send-otp`
4. Nhập email của tài khoản đã đăng ký (VD: `levantai`)
5. Kiểm tra hộp thư email — sẽ nhận được mã OTP 6 chữ số
6. Nhập mã OTP → Đăng nhập thành công

### Các trường hợp cần test:
- [ ] Gửi OTP thành công đến email
- [ ] Nhập mã OTP đúng → Đăng nhập thành công, chuyển hướng đúng
- [ ] Nhập mã OTP sai → Hiện lỗi, tăng số lần sai
- [ ] Nhập sai 3 lần → OTP bị khóa, phải gửi lại
- [ ] OTP hết hạn (đợi 5 phút) → Không còn sử dụng được
- [ ] Quy trình 60s gửi lại → Cho phép gửi lại sau 60s
- [ ] Đăng nhập ADMIN → Chuyển hướng về `/admin/dashboard`
- [ ] Đăng nhập CUSTOMER → Chuyển hướng về `/home`

---

## 5. Lịch Sử Mã OTP

Bạn có thể xem các mã OTP đã gửi bằng câu lệnh:

```sql
SELECT id, email, otp_code, created_at, expired_at, is_used, attempt_count
FROM otp_tokens
ORDER BY created_at DESC
LIMIT 20;
```

Xóa các OTP cũ (optional):

```sql
DELETE FROM otp_tokens WHERE expired_at < NOW() - INTERVAL 1 DAY;
```

---

## 6. Lưu Ý Quan Trọng

> **Về `mail.properties`:** File này chứa thông tin SMTP nhạy cảm, đã được thêm vào `.gitignore`. Tuyệt đối không commit nó lên git.

> **Về timezone:** Đảm bảo MySQL server cùng múi giờ GMT+7 với server Java để tránh tình trạng mã OTP tự động hết hạn sớm hoặc trễ.

> **Về bảo mật:** Hệ thống đã triển khai:
> - Giới hạn 3 lần nhập sai
> - OTP hết hạn sau 5 phút
> - Session Fixation Protection (invalidate session cũ trước khi tạo session mới)
> - Không tiết lộ email có tồn tại hay không (vẫn hiện thông báo thành công như nhau)
