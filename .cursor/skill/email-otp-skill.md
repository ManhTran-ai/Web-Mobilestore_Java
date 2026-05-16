# SKILL: Xác Thực Đăng Nhập Bằng OTP Qua Email
# Dành cho: Java Servlet + JSP (MobileStore Project)

---

## 1. TỔNG QUAN TÍNH NĂNG

**Mục tiêu:** Cho phép người dùng đăng nhập an toàn bằng cách nhập email,
hệ thống gửi mã OTP 6 chữ số, người dùng xác nhận mã để hoàn tất đăng nhập.

**Luồng xử lý (Happy Path):**
```
[Trang Login] 
  → User nhập Email 
  → POST /send-otp 
  → Validate email tồn tại trong DB
  → Generate OTP (6 digits, expire 5 phút)
  → Lưu OTP vào bảng `otp_tokens` (DB) 
  → Gửi email chứa OTP qua JavaMail (SMTP)
  → Redirect → [Trang nhập OTP]
  → User nhập OTP
  → POST /verify-otp 
  → Validate OTP (đúng + chưa hết hạn + chưa dùng)
  → Đánh dấu OTP đã dùng (used = true)
  → Tạo HttpSession → setAttribute("user", userObj)
  → Redirect → [Trang chủ / Dashboard]
```

**Luồng xử lý lỗi:**
```
Email không tồn tại → Hiển thị lỗi, KHÔNG tiết lộ email có tồn tại hay không
OTP sai            → Hiển thị lỗi, tăng attempt_count
OTP hết hạn        → Hiển thị lỗi + nút "Gửi lại OTP"
Quá 3 lần sai      → Khóa OTP, buộc gửi lại
```

---

## 2. DEPENDENCIES CẦN THÊM

### Maven (pom.xml)
```xml
<!-- JavaMail API -->
<dependency>
    <groupId>com.sun.mail</groupId>
    <artifactId>jakarta.mail</artifactId>
    <version>2.0.1</version>
</dependency>

<!-- Jakarta Servlet (nếu chưa có) -->
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>5.0.0</version>
    <scope>provided</scope>
</dependency>
```

### Gradle (build.gradle)
```groovy
implementation 'com.sun.mail:jakarta.mail:2.0.1'
compileOnly 'jakarta.servlet:jakarta.servlet-api:5.0.0'
```

---

## 3. CẤU TRÚC FILE CẦN TẠO

```
src/main/
├── java/
│   ├── model/
│   │   └── OtpToken.java              ← POJO mapping bảng otp_tokens
│   ├── dao/
│   │   └── OtpTokenDAO.java           ← CRUD cho otp_tokens
│   ├── service/
│   │   ├── EmailService.java          ← Gửi email qua JavaMail
│   │   └── OtpService.java            ← Generate, validate OTP
│   ├── controller/
│   │   ├── SendOtpServlet.java        ← POST /send-otp
│   │   └── VerifyOtpServlet.java      ← POST /verify-otp
│   └── utils/
│       └── EmailConfig.java           ← Load SMTP config từ properties
├── resources/
│   └── email.properties               ← SMTP credentials (KHÔNG commit git)
└── webapp/
    └── views/
        ├── login-email.jsp            ← Form nhập email
        ├── login-otp.jsp              ← Form nhập mã OTP
        └── login-otp-success.jsp      ← (Optional) Trang thông báo thành công
```

---

## 4. SCHEMA DATABASE

### Bảng `otp_tokens`
```sql
CREATE TABLE otp_tokens (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    email       VARCHAR(255)    NOT NULL,
    otp_code    VARCHAR(6)      NOT NULL,
    created_at  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expired_at  DATETIME        NOT NULL,
    is_used     TINYINT(1)      NOT NULL DEFAULT 0,
    attempt_count INT           NOT NULL DEFAULT 0,

    -- Index để query nhanh
    INDEX idx_email_otp (email, otp_code),
    INDEX idx_expired (expired_at)
);
```

> **Lý do lưu vào DB thay vì Session:**
> - Session bị mất nếu user refresh hoặc server restart
> - Có thể audit log, kiểm tra lịch sử OTP
> - Dễ kiểm soát attempt_count, rate limiting

---

## 5. IMPLEMENTATION CHI TIẾT

### 5.1 Model – `OtpToken.java`
```java
package model;

import java.time.LocalDateTime;

public class OtpToken {
    private int id;
    private String email;
    private String otpCode;
    private LocalDateTime createdAt;
    private LocalDateTime expiredAt;
    private boolean isUsed;
    private int attemptCount;

    // Constructors, Getters, Setters
    public OtpToken() {}

    public OtpToken(String email, String otpCode, LocalDateTime expiredAt) {
        this.email = email;
        this.otpCode = otpCode;
        this.expiredAt = expiredAt;
        this.isUsed = false;
        this.attemptCount = 0;
    }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expiredAt);
    }

    public boolean isMaxAttemptReached() {
        return this.attemptCount >= 3;
    }

    // --- Getters & Setters ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getExpiredAt() { return expiredAt; }
    public void setExpiredAt(LocalDateTime expiredAt) { this.expiredAt = expiredAt; }
    public boolean isUsed() { return isUsed; }
    public void setUsed(boolean used) { isUsed = used; }
    public int getAttemptCount() { return attemptCount; }
    public void setAttemptCount(int attemptCount) { this.attemptCount = attemptCount; }
}
```

---

### 5.2 DAO – `OtpTokenDAO.java`
```java
package dao;

import model.OtpToken;
import utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;

public class OtpTokenDAO extends DBContext {

    /**
     * Lưu OTP mới vào DB
     */
    public void insertOtp(OtpToken token) throws SQLException {
        String sql = "INSERT INTO otp_tokens (email, otp_code, expired_at) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token.getEmail());
            ps.setString(2, token.getOtpCode());
            ps.setTimestamp(3, Timestamp.valueOf(token.getExpiredAt()));
            ps.executeUpdate();
        }
    }

    /**
     * Lấy OTP mới nhất của email (chưa dùng, chưa hết hạn)
     */
    public OtpToken getLatestValidOtp(String email) throws SQLException {
        String sql = """
            SELECT * FROM otp_tokens
            WHERE email = ?
              AND is_used = 0
              AND expired_at > NOW()
              AND attempt_count < 3
            ORDER BY created_at DESC
            LIMIT 1
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    /**
     * Đánh dấu OTP đã được sử dụng
     */
    public void markAsUsed(int otpId) throws SQLException {
        String sql = "UPDATE otp_tokens SET is_used = 1 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        }
    }

    /**
     * Tăng số lần nhập sai
     */
    public void incrementAttempt(int otpId) throws SQLException {
        String sql = "UPDATE otp_tokens SET attempt_count = attempt_count + 1 WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        }
    }

    /**
     * Vô hiệu hóa tất cả OTP cũ của email (khi gửi lại OTP mới)
     */
    public void invalidateAllOtpByEmail(String email) throws SQLException {
        String sql = "UPDATE otp_tokens SET is_used = 1 WHERE email = ? AND is_used = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        }
    }

    private OtpToken mapRow(ResultSet rs) throws SQLException {
        OtpToken token = new OtpToken();
        token.setId(rs.getInt("id"));
        token.setEmail(rs.getString("email"));
        token.setOtpCode(rs.getString("otp_code"));
        token.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        token.setExpiredAt(rs.getTimestamp("expired_at").toLocalDateTime());
        token.setUsed(rs.getBoolean("is_used"));
        token.setAttemptCount(rs.getInt("attempt_count"));
        return token;
    }
}
```

---

### 5.3 Service – `OtpService.java`
```java
package service;

import dao.OtpTokenDAO;
import model.OtpToken;

import java.security.SecureRandom;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class OtpService {

    private static final int OTP_LENGTH = 6;
    private static final int OTP_EXPIRE_MINUTES = 5;
    // Dùng SecureRandom thay Random để bảo mật hơn
    private static final SecureRandom secureRandom = new SecureRandom();

    private final OtpTokenDAO otpTokenDAO;

    public OtpService() {
        this.otpTokenDAO = new OtpTokenDAO();
    }

    /**
     * Tạo OTP mới, lưu DB, trả về mã OTP
     */
    public String generateAndSaveOtp(String email) throws SQLException {
        // Vô hiệu hóa OTP cũ trước
        otpTokenDAO.invalidateAllOtpByEmail(email);

        // Generate OTP 6 chữ số
        String otpCode = generateOtpCode();

        // Tạo token với thời hạn 5 phút
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(OTP_EXPIRE_MINUTES);
        OtpToken token = new OtpToken(email, otpCode, expiredAt);

        otpTokenDAO.insertOtp(token);
        return otpCode;
    }

    /**
     * Xác thực OTP người dùng nhập
     * @return true nếu hợp lệ
     */
    public boolean validateOtp(String email, String inputOtp) throws SQLException {
        OtpToken token = otpTokenDAO.getLatestValidOtp(email);

        if (token == null) {
            // Không tìm thấy OTP hợp lệ (hết hạn, đã dùng, hoặc quá 3 lần sai)
            return false;
        }

        if (!token.getOtpCode().equals(inputOtp)) {
            // Sai OTP → tăng attempt
            otpTokenDAO.incrementAttempt(token.getId());
            return false;
        }

        // Đúng OTP → đánh dấu đã dùng
        otpTokenDAO.markAsUsed(token.getId());
        return true;
    }

    /**
     * Kiểm tra OTP còn hiệu lực không (để hiển thị đếm ngược)
     */
    public boolean isOtpStillValid(String email) throws SQLException {
        return otpTokenDAO.getLatestValidOtp(email) != null;
    }

    private String generateOtpCode() {
        int otpNumber = secureRandom.nextInt((int) Math.pow(10, OTP_LENGTH));
        return String.format("%0" + OTP_LENGTH + "d", otpNumber);
    }
}
```

---

### 5.4 Config – `email.properties` (KHÔNG commit lên git)
```properties
# SMTP Configuration
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.smtp.auth=true
mail.smtp.starttls.enable=true

# Tài khoản gửi email
mail.sender.email=your-app@gmail.com
mail.sender.password=your-app-password-or-app-specific-password
mail.sender.name=MobileStore
```

> **⚠️ Với Gmail:** Phải dùng **App Password** (không phải mật khẩu thường).
> Vào Google Account → Security → 2-Step Verification → App passwords.

---

### 5.5 Utils – `EmailConfig.java`
```java
package utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class EmailConfig {

    private static final Properties props = new Properties();

    static {
        try (InputStream input = EmailConfig.class
                .getClassLoader()
                .getResourceAsStream("email.properties")) {
            if (input == null) {
                throw new RuntimeException(
                    "Không tìm thấy file email.properties trong classpath!"
                );
            }
            props.load(input);
        } catch (IOException e) {
            throw new RuntimeException("Lỗi khi load email.properties: " + e.getMessage(), e);
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}
```

---

### 5.6 Service – `EmailService.java`
```java
package service;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import utils.EmailConfig;

import java.util.Properties;

public class EmailService {

    /**
     * Gửi email chứa mã OTP
     * @param toEmail  Email người nhận
     * @param otpCode  Mã OTP 6 chữ số
     */
    public void sendOtpEmail(String toEmail, String otpCode) throws MessagingException {
        Properties smtpProps = buildSmtpProperties();
        Session session = createMailSession(smtpProps);
        Message message = buildOtpMessage(session, toEmail, otpCode);
        Transport.send(message);
    }

    private Properties buildSmtpProperties() {
        Properties props = new Properties();
        props.put("mail.smtp.host",            EmailConfig.get("mail.smtp.host"));
        props.put("mail.smtp.port",            EmailConfig.get("mail.smtp.port"));
        props.put("mail.smtp.auth",            EmailConfig.get("mail.smtp.auth"));
        props.put("mail.smtp.starttls.enable", EmailConfig.get("mail.smtp.starttls.enable"));
        return props;
    }

    private Session createMailSession(Properties props) {
        String username = EmailConfig.get("mail.sender.email");
        String password = EmailConfig.get("mail.sender.password");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });
    }

    private Message buildOtpMessage(Session session,
                                     String toEmail,
                                     String otpCode) throws MessagingException {
        String senderEmail = EmailConfig.get("mail.sender.email");
        String senderName  = EmailConfig.get("mail.sender.name");

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(senderEmail, senderName));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("[MobileStore] Mã xác nhận đăng nhập của bạn");
        message.setContent(buildHtmlBody(otpCode), "text/html; charset=UTF-8");
        return message;
    }

    private String buildHtmlBody(String otpCode) {
        return """
            <div style="font-family: Arial, sans-serif; max-width: 480px; margin: auto;
                        border: 1px solid #e0e0e0; border-radius: 8px; padding: 32px;">
                <h2 style="color: #1a1a2e;">🔐 Mã Xác Nhận Đăng Nhập</h2>
                <p>Xin chào,</p>
                <p>Mã OTP của bạn là:</p>
                <div style="text-align: center; margin: 24px 0;">
                    <span style="font-size: 36px; font-weight: bold; letter-spacing: 12px;
                                 color: #e94560; background: #f5f5f5;
                                 padding: 12px 24px; border-radius: 8px;">
                        %s
                    </span>
                </div>
                <p style="color: #888;">⏱ Mã có hiệu lực trong <strong>5 phút</strong>.</p>
                <p style="color: #888;">Nếu bạn không yêu cầu mã này, hãy bỏ qua email này.</p>
                <hr style="border: none; border-top: 1px solid #eee; margin: 24px 0;">
                <p style="color: #aaa; font-size: 12px;">
                    © MobileStore – Email tự động, vui lòng không trả lời.
                </p>
            </div>
            """.formatted(otpCode);
    }
}
```

---

### 5.7 Servlet – `SendOtpServlet.java`
```java
package controller;

import dao.UserDAO;
import model.User;
import service.EmailService;
import service.OtpService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/send-otp")
public class SendOtpServlet extends HttpServlet {

    private OtpService otpService;
    private EmailService emailService;
    private UserDAO userDAO;

    @Override
    public void init() {
        this.otpService    = new OtpService();
        this.emailService  = new EmailService();
        this.userDAO       = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Hiển thị form nhập email
        req.getRequestDispatcher("/views/login-email.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        // --- Validate input ---
        if (email == null || email.trim().isEmpty() || !isValidEmail(email)) {
            req.setAttribute("errorMessage", "Email không hợp lệ.");
            req.getRequestDispatcher("/views/login-email.jsp").forward(req, resp);
            return;
        }

        email = email.trim().toLowerCase();

        try {
            // --- Kiểm tra email tồn tại trong DB ---
            // Lưu ý: KHÔNG tiết lộ email có tồn tại hay không (tránh email enumeration)
            User user = userDAO.findByEmail(email);

            if (user != null) {
                // Chỉ gửi OTP nếu email tồn tại (nhưng hiển thị cùng 1 thông báo)
                String otpCode = otpService.generateAndSaveOtp(email);
                emailService.sendOtpEmail(email, otpCode);
            }

            // Lưu email vào session để dùng ở bước verify
            HttpSession session = req.getSession();
            session.setAttribute("otpEmail", email);
            session.setMaxInactiveInterval(10 * 60); // 10 phút

            // Luôn redirect (không để biết email có tồn tại không)
            resp.sendRedirect(req.getContextPath() + "/verify-otp");

        } catch (Exception e) {
            // Log lỗi nội bộ, không lộ chi tiết ra ngoài
            getServletContext().log("Lỗi khi gửi OTP: " + e.getMessage(), e);
            req.setAttribute("errorMessage",
                "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/views/login-email.jsp").forward(req, resp);
        }
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }
}
```

---

### 5.8 Servlet – `VerifyOtpServlet.java`
```java
package controller;

import dao.UserDAO;
import model.User;
import service.OtpService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    private OtpService otpService;
    private UserDAO userDAO;

    @Override
    public void init() {
        this.otpService = new OtpService();
        this.userDAO    = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra session có email không
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("otpEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/send-otp");
            return;
        }

        req.getRequestDispatcher("/views/login-otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // --- Lấy session và kiểm tra ---
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("otpEmail") == null) {
            resp.sendRedirect(req.getContextPath() + "/send-otp");
            return;
        }

        String email   = (String) session.getAttribute("otpEmail");
        String otpCode = req.getParameter("otpCode");

        if (otpCode == null || otpCode.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Vui lòng nhập mã OTP.");
            req.getRequestDispatcher("/views/login-otp.jsp").forward(req, resp);
            return;
        }

        otpCode = otpCode.trim();

        try {
            boolean isValid = otpService.validateOtp(email, otpCode);

            if (!isValid) {
                req.setAttribute("errorMessage",
                    "Mã OTP không đúng, đã hết hạn, hoặc đã dùng. Vui lòng thử lại.");
                req.getRequestDispatcher("/views/login-otp.jsp").forward(req, resp);
                return;
            }

            // --- OTP hợp lệ → Tạo session đăng nhập ---
            User user = userDAO.findByEmail(email);
            if (user == null) {
                // Edge case: user bị xóa sau khi gửi OTP
                req.setAttribute("errorMessage", "Tài khoản không tồn tại.");
                req.getRequestDispatcher("/views/login-email.jsp").forward(req, resp);
                return;
            }

            // Làm mới session để tránh Session Fixation Attack
            session.invalidate();
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("user", user);
            newSession.setAttribute("userId", user.getId());
            newSession.setAttribute("userRole", user.getRole());
            newSession.setMaxInactiveInterval(30 * 60); // 30 phút

            // Xóa email OTP khỏi session
            // (không cần vì session mới rồi)

            // Redirect theo role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }

        } catch (Exception e) {
            getServletContext().log("Lỗi khi verify OTP: " + e.getMessage(), e);
            req.setAttribute("errorMessage",
                "Hệ thống đang gặp sự cố. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/views/login-otp.jsp").forward(req, resp);
        }
    }
}
```

---

### 5.9 JSP – `login-email.jsp`
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập – MobileStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
<div class="auth-container">
    <h2>Đăng nhập</h2>
    <p class="subtitle">Nhập email để nhận mã xác nhận</p>

    <%-- Hiển thị lỗi nếu có --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/send-otp" method="post">
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   placeholder="example@email.com"
                   required autocomplete="email">
        </div>
        <button type="submit" class="btn-primary">Gửi mã xác nhận</button>
    </form>
</div>
</body>
</html>
```

---

### 5.10 JSP – `login-otp.jsp`
```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Nhập mã OTP – MobileStore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
<div class="auth-container">
    <h2>Nhập mã xác nhận</h2>
    <p class="subtitle">
        Mã OTP đã được gửi đến <strong>${sessionScope.otpEmail}</strong>.
        Mã có hiệu lực trong 5 phút.
    </p>

    <%-- Hiển thị lỗi nếu có --%>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">${errorMessage}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/verify-otp" method="post">
        <div class="form-group">
            <label for="otpCode">Mã OTP (6 chữ số)</label>
            <input type="text" id="otpCode" name="otpCode"
                   maxlength="6" placeholder="______"
                   pattern="[0-9]{6}" required
                   autocomplete="one-time-code"
                   style="letter-spacing: 8px; font-size: 24px; text-align: center;">
        </div>

        <%-- Đếm ngược thời gian --%>
        <p id="countdown" class="timer-text">Mã hết hạn sau: <span id="timer">05:00</span></p>

        <button type="submit" class="btn-primary">Xác nhận</button>
    </form>

    <div class="resend-section">
        <p>Không nhận được mã?
            <a href="${pageContext.request.contextPath}/send-otp">Gửi lại OTP</a>
        </p>
    </div>
</div>

<script>
    // Đếm ngược 5 phút
    let timeLeft = 5 * 60;
    const timerEl = document.getElementById('timer');
    const countdown = setInterval(() => {
        const minutes = String(Math.floor(timeLeft / 60)).padStart(2, '0');
        const seconds = String(timeLeft % 60).padStart(2, '0');
        timerEl.textContent = `${minutes}:${seconds}`;
        if (--timeLeft < 0) {
            clearInterval(countdown);
            timerEl.textContent = '00:00';
            document.querySelector('.btn-primary').disabled = true;
            document.getElementById('countdown').innerHTML =
                '⚠️ Mã đã hết hạn. <a href="${pageContext.request.contextPath}/send-otp">Gửi lại OTP</a>';
        }
    }, 1000);
</script>
</body>
</html>
```

---

## 6. LỖI THƯỜNG GẶP VÀ CÁCH TRÁNH

| # | Lỗi | Nguyên nhân | Cách tránh |
|---|-----|-------------|------------|
| 1 | **Email Enumeration** | Thông báo khác nhau cho email tồn tại/không tồn tại | Luôn hiển thị cùng 1 thông báo thành công dù email có tồn tại hay không |
| 2 | **Session Fixation** | Dùng lại session cũ sau khi đăng nhập thành công | `session.invalidate()` rồi `req.getSession(true)` trước khi set user vào session |
| 3 | **OTP Brute Force** | Không giới hạn số lần nhập sai | Giới hạn 3 lần sai → vô hiệu OTP, buộc gửi lại |
| 4 | **OTP Reuse** | OTP đã dùng vẫn hợp lệ | Đánh dấu `is_used = 1` ngay khi verify thành công |
| 5 | **Connection leak trong DAO** | Không đóng PreparedStatement trong finally | Dùng `try-with-resources` cho mọi Statement |
| 6 | **Credentials lộ trong code** | Hard-code SMTP password trong .java | Luôn đọc từ `email.properties` và thêm file này vào `.gitignore` |
| 7 | **Thiếu return sau redirect** | Tiếp tục chạy code sau `sendRedirect()` | Luôn thêm `return;` ngay sau mọi lời gọi `sendRedirect()` |
| 8 | **OTP không clear khi gửi lại** | Nhiều OTP hợp lệ cùng tồn tại | Gọi `invalidateAllOtpByEmail()` trước khi tạo OTP mới |

---

## 7. CHECKLIST KIỂM TRA TRƯỚC KHI DEMO

- [ ] File `email.properties` đã được thêm vào `.gitignore`
- [ ] Gửi OTP thành công đến Gmail thật
- [ ] OTP hết hạn sau đúng 5 phút
- [ ] Nhập sai 3 lần → OTP bị khóa
- [ ] OTP đã dùng → không dùng lại được
- [ ] Session mới được tạo sau đăng nhập thành công
- [ ] Redirect đúng theo role (admin/user)
- [ ] Truy cập `/verify-otp` không qua `/send-otp` → redirect về `/send-otp`
- [ ] Không có stack trace lộ ra ngoài giao diện
