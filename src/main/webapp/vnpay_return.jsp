<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.mobilestore.config.VNPayConfig" %>
<%@ page import="com.mobilestore.dao.OrderDAO" %>
<%@ page import="com.mobilestore.dao.CartDAO" %>
<%@ page import="com.mobilestore.entity.*" %>
<%@ page import="java.util.*" %>
<%
    Map<String, String> params = new HashMap<>();
    Enumeration<String> paramNames = request.getParameterNames();
    while (paramNames.hasMoreElements()) {
        String paramName = paramNames.nextElement();
        params.put(paramName, request.getParameter(paramName));
    }

    boolean isValid = VNPayConfig.verifyReturnUrl(params);
    
    String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
    String vnp_TxnRef = request.getParameter("vnp_TxnRef");
    String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
    String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
    
    HttpSession sessionObj = request.getSession();
    String errorMessage = null;
    Integer orderId = null;
    
    if (isValid && "00".equals(vnp_ResponseCode)) {
        Double totalAmount = (Double) sessionObj.getAttribute("vnp_total_amount");
        List<CartItem> cart = (List<CartItem>) sessionObj.getAttribute("vnp_cart");
        Integer userId = (Integer) sessionObj.getAttribute("vnp_user_id");
        Double shippingFee = (Double) sessionObj.getAttribute("vnp_shipping_fee");
        String shippingAddress = (String) sessionObj.getAttribute("vnp_shipping_address");
        String customerPhone = (String) sessionObj.getAttribute("vnp_customer_phone");
        String note = (String) sessionObj.getAttribute("vnp_note");
        Integer districtId = (Integer) sessionObj.getAttribute("vnp_district_id");
        String wardCode = (String) sessionObj.getAttribute("vnp_ward_code");

        if (totalAmount != null && cart != null && userId != null) {
            OrderDAO orderDAO = new OrderDAO();
            orderId = orderDAO.createOrderWithPayment(
                userId,
                totalAmount,
                cart,
                shippingAddress != null ? shippingAddress : "",
                customerPhone != null ? customerPhone : "",
                note != null ? note : "",
                shippingFee != null ? shippingFee : 0.0,
                districtId,
                wardCode,
                vnp_TransactionNo,
                vnp_TxnRef
            );

            if (orderId != null) {
                System.out.println("[ORDER-SHIPPING-COST] OrderId=" + orderId
                        + " | UserId=" + userId
                        + " | DistrictId=" + districtId
                        + " | WardCode=" + wardCode
                        + " | PhiShipThucTe=" + (shippingFee != null ? (long) shippingFee : 0L) + " VND"
                        + " | PhiShipUserTra=0 VND (Freeship)"
                        + " | TongTruocShip=" + (long) totalAmount + " VND"
                        + " | TongSauShip=" + (long) (totalAmount + (shippingFee != null ? shippingFee : 0.0)) + " VND"
                        + " | PaymentMethod=VNPAY"
                        + " | VNPayTxnRef=" + vnp_TxnRef
                        + " | VNPayTransNo=" + vnp_TransactionNo);
                CartDAO cartDAO = new CartDAO();
                cartDAO.clearCartByUser(userId);
                sessionObj.removeAttribute("cart");
            }
        } else {
            errorMessage = "Phiên thanh toán đã hết hạn. Vui lòng thử lại.";
        }
    } else if (!isValid) {
        errorMessage = "Xác thực chữ ký thất bại!";
    } else {
        errorMessage = "Thanh toán thất bại. Mã lỗi: " + vnp_ResponseCode;
    }
    
    sessionObj.removeAttribute("vnp_order_id");
    sessionObj.removeAttribute("vnp_total_amount");
    sessionObj.removeAttribute("vnp_shipping_fee");
    sessionObj.removeAttribute("vnp_cart");
    sessionObj.removeAttribute("vnp_user_id");
    sessionObj.removeAttribute("vnp_shipping_address");
    sessionObj.removeAttribute("vnp_customer_phone");
    sessionObj.removeAttribute("vnp_note");
    sessionObj.removeAttribute("vnp_district_id");
    sessionObj.removeAttribute("vnp_ward_code");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán - Mobile Store</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f5f5; 
            min-height: 100vh; 
            display: flex; 
            align-items: center; 
            justify-content: center;
        }
        .container { 
            background: white; 
            padding: 2rem; 
            border-radius: 12px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 500px; 
            width: 90%;
            text-align: center;
        }
        .success { color: #28a745; font-size: 4rem; margin-bottom: 1rem; }
        .error { color: #dc3545; font-size: 4rem; margin-bottom: 1rem; }
        h1 { font-size: 1.5rem; margin-bottom: 1rem; color: #333; }
        .order-id { color: #666; margin-bottom: 1.5rem; }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: #111;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            margin-top: 1rem;
        }
        .btn:hover { background: #333; }
    </style>
</head>
<body>
    <div class="container">
        <% if (orderId != null) { %>
            <div class="success">&#10003;</div>
            <h1>Thanh toán thành công!</h1>
            <p class="order-id">Mã đơn hàng: #<%= orderId %></p>
            <p>Cảm ơn bạn đã mua sắm tại Mobile Store!</p>
            <a href="${pageContext.request.contextPath}/" class="btn" style="margin-top:0.75rem;">Quay trở lại trang chủ</a>
            <a href="${pageContext.request.contextPath}/order-confirmation?id=<%= orderId %>" class="btn" style="background:#28a745;margin-top:0.5rem;">Xem chi tiết đơn hàng</a>
        <% } else { %>
            <div class="error">✗</div>
            <h1>Thanh toán thất bại</h1>
            <p><%= errorMessage != null ? errorMessage : "Đã xảy ra lỗi. Vui lòng thử lại." %></p>
            <a href="${pageContext.request.contextPath}/checkout" class="btn">Thử lại</a>
        <% } %>
    </div>
</body>
</html>

