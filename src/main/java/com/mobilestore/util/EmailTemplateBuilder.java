package com.mobilestore.util;

public class EmailTemplateBuilder {

    private static final String BRAND_COLOR = "#007bff";
    private static final String BRAND_NAME = "MobileStore";
    private static final String FOOTER_TEXT = "Nếu bạn không thực hiện hành động này, hãy bỏ qua email này.";

    public static String buildOtpEmail(String otpCode, String type) {
        String title;
        String description;
        if ("registration".equals(type)) {
            title = "Mã Xác Nhận Đăng Ký";
            description = "Cảm ơn bạn đã đăng ký tài khoản tại MobileStore. Mã xác nhận của bạn là:";
        } else {
            title = "Mã Xác Nhận Đăng Nhập";
            description = "Chúng tôi nhận được yêu cầu đăng nhập vào tài khoản MobileStore của bạn. Mã xác nhận của bạn là:";
        }

        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>\n");
        html.append("<html lang=\"vi\">\n");
        html.append("<head>\n");
        html.append("<meta charset=\"UTF-8\">\n");
        html.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
        html.append("</head>\n");
        html.append("<body style=\"margin:0;padding:0;background-color:#f4f4f4;font-family:Arial,sans-serif;\">\n");

        html.append("  <div style=\"max-width:520px;margin:30px auto;background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.1);\">\n");
        html.append("    <div style=\"background:#1a1a1a;padding:24px 32px;text-align:center;\">\n");
        html.append("      <h1 style=\"margin:0;color:#ffffff;font-size:22px;font-weight:600;\">").append(BRAND_NAME).append("</h1>\n");
        html.append("    </div>\n");
        html.append("    <div style=\"padding:32px;text-align:center;\">\n");
        html.append("      <h2 style=\"color:#1a1a1a;margin:0 0 8px 0;font-size:20px;\">").append(title).append("</h2>\n");
        html.append("      <p style=\"color:#666666;margin:0 0 24px 0;font-size:15px;line-height:1.6;\">").append(description).append("</p>\n");
        html.append("      <div style=\"background:#f8f8f8;border-radius:8px;padding:20px 32px;margin:0 0 24px 0;\">\n");
        html.append("        <span style=\"font-size:36px;font-weight:bold;letter-spacing:10px;color:").append(BRAND_COLOR).append(";\">").append(otpCode).append("</span>\n");
        html.append("      </div>\n");
        html.append("      <p style=\"color:#888888;font-size:13px;margin:0 0 8px 0;\"> Mã có hiệu lực trong <strong>5 phút</strong>.</p>\n");
        html.append("      <p style=\"color:#888888;font-size:13px;margin:0 0 24px 0;\"> Vui lòng không chia sẻ mã này với bất kỳ ai.</p>\n");
        html.append("      <hr style=\"border:none;border-top:1px solid #eeeeee;margin:24px 0;\">\n");
        html.append("      <p style=\"color:#aaaaaa;font-size:12px;margin:0;text-align:center;\"> Đây là email tự động từ ").append(BRAND_NAME).append(". Vui lòng không trả lời email này.</p>\n");
        html.append("    </div>\n");
        html.append("    <div style=\"background:#f4f4f4;padding:16px 32px;text-align:center;\">\n");
        html.append("      <p style=\"color:#aaaaaa;font-size:11px;margin:0;\">&#169; 2026 ").append(BRAND_NAME).append(". Mọi quyền được bảo lưu.</p>\n");
        html.append("    </div>\n");
        html.append("  </div>\n");

        html.append("</body>\n");
        html.append("</html>");
        return html.toString();
    }

    public static String buildPasswordResetEmail(String username, String resetLink) {
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>\n");
        html.append("<html lang=\"vi\">\n");
        html.append("<head>\n");
        html.append("<meta charset=\"UTF-8\">\n");
        html.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
        html.append("</head>\n");
        html.append("<body style=\"margin:0;padding:0;background-color:#f4f4f4;font-family:Arial,sans-serif;\">\n");

        html.append("  <div style=\"max-width:520px;margin:30px auto;background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.1);\">\n");
        html.append("    <div style=\"background:#1a1a1a;padding:24px 32px;text-align:center;\">\n");
        html.append("      <h1 style=\"margin:0;color:#ffffff;font-size:22px;font-weight:600;\">").append(BRAND_NAME).append("</h1>\n");
        html.append("    </div>\n");
        html.append("    <div style=\"padding:32px;text-align:center;\">\n");
        html.append("      <h2 style=\"color:#1a1a1a;margin:0 0 8px 0;font-size:20px;\">Đặt Lại Mật Khẩu</h2>\n");
        html.append("      <p style=\"color:#666666;margin:0 0 24px 0;font-size:15px;line-height:1.6;\">\n");
        html.append("        Xin chào <strong>").append(escapeHtml(username)).append("</strong>,<br>\n");
        html.append("        Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.\n");
        html.append("      </p>\n");
        html.append("      <a href=\"").append(resetLink).append("\" style=\"display:inline-block;background:").append(BRAND_COLOR).append(";color:#ffffff;padding:14px 32px;border-radius:8px;text-decoration:none;font-weight:600;font-size:15px;\">\n");
        html.append("        Đặt Lại Mật Khẩu\n");
        html.append("      </a>\n");
        html.append("      <p style=\"color:#888888;font-size:13px;margin:24px 0 8px 0;\">Liên kết có hiệu lực trong <strong>30 phút</strong>.</p>\n");
        html.append("      <p style=\"color:#888888;font-size:12px;margin:0 0 24px 0;\">Nếu bạn không yêu cầu đặt lại mật khẩu, hãy bỏ qua email này.</p>\n");
        html.append("      <hr style=\"border:none;border-top:1px solid #eeeeee;margin:24px 0;\">\n");
        html.append("      <p style=\"color:#aaaaaa;font-size:12px;margin:0;text-align:center;\">📧 Đây là email tự động từ ").append(BRAND_NAME).append(". Vui lòng không trả lời email này.</p>\n");
        html.append("    </div>\n");
        html.append("    <div style=\"background:#f4f4f4;padding:16px 32px;text-align:center;\">\n");
        html.append("      <p style=\"color:#aaaaaa;font-size:11px;margin:0;\">&#169; 2026 ").append(BRAND_NAME).append(". Mọi quyền được bảo lưu.</p>\n");
        html.append("    </div>\n");
        html.append("  </div>\n");

        html.append("</body>\n");
        html.append("</html>");
        return html.toString();
    }

    public static String buildOrderStatusEmail(String orderId, String status, String statusLabel,
                                               String customerName, String totalAmount,
                                               String shippingAddress, String paymentMethod,
                                               String cancelReason, String trackingNumber) {
        StringBuilder html = new StringBuilder();
        String statusColor;
        switch (status) {
            case "CONFIRMED":
                statusColor = "#16a34a";
                break;
            case "PAID":
                statusColor = "#16a34a";
                break;
            case "SHIPPING":
                statusColor = "#d97706";
                break;
            case "DELIVERED":
                statusColor = "#16a34a";
                break;
            case "CANCELLED":
                statusColor = "#dc2626";
                break;
            default:
                statusColor = "#007bff";
        }

        html.append("<!DOCTYPE html>\n");
        html.append("<html lang=\"vi\">\n");
        html.append("<head>\n");
        html.append("<meta charset=\"UTF-8\">\n");
        html.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
        html.append("</head>\n");
        html.append("<body style=\"margin:0;padding:0;background-color:#f4f4f4;font-family:Arial,sans-serif;\">\n");

        html.append("  <div style=\"max-width:600px;margin:30px auto;background:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.1);\">\n");
        html.append("    <div style=\"background:#1a1a1a;padding:24px 32px;text-align:center;\">\n");
        html.append("      <h1 style=\"margin:0;color:#ffffff;font-size:22px;font-weight:600;\">").append(BRAND_NAME).append("</h1>\n");
        html.append("    </div>\n");

        html.append("    <div style=\"padding:32px;\">\n");
        html.append("      <h2 style=\"color:#1a1a1a;margin:0 0 16px 0;font-size:20px;\">Cập Nhật Trạng Thái Đơn Hàng #").append(orderId).append("</h2>\n");

        if ("CANCELLED".equals(status) && cancelReason != null && !cancelReason.isBlank()) {
            html.append("      <div style=\"background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:16px;margin-bottom:24px;\">\n");
            html.append("        <p style=\"margin:0;color:#dc2626;font-size:14px;\"><strong>Lý do hủy:</strong> ").append(escapeHtml(cancelReason)).append("</p>\n");
            html.append("      </div>\n");
        }

        html.append("      <table style=\"width:100%;border-collapse:collapse;margin-bottom:24px;\">\n");
        html.append("        <tr>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;color:#888;font-size:14px;\">Trạng thái</td>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;text-align:right;\">\n");
        html.append("            <span style=\"display:inline-block;background:").append(statusColor).append(";color:#ffffff;padding:4px 12px;border-radius:4px;font-size:13px;font-weight:600;\">").append(statusLabel).append("</span>\n");
        html.append("          </td>\n");
        html.append("        </tr>\n");
        html.append("        <tr>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;color:#888;font-size:14px;\">Người nhận</td>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;text-align:right;color:#1a1a1a;font-size:14px;font-weight:500;\">").append(escapeHtml(customerName)).append("</td>\n");
        html.append("        </tr>\n");
        html.append("        <tr>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;color:#888;font-size:14px;\">Địa chỉ giao hàng</td>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;text-align:right;color:#1a1a1a;font-size:14px;\">").append(escapeHtml(shippingAddress != null ? shippingAddress : "—")).append("</td>\n");
        html.append("        </tr>\n");
        html.append("        <tr>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;color:#888;font-size:14px;\">Thanh toán</td>\n");
        html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;text-align:right;color:#1a1a1a;font-size:14px;\">").append(paymentMethod != null ? escapeHtml(paymentMethod) : "—").append("</td>\n");
        html.append("        </tr>\n");
        if (trackingNumber != null && !trackingNumber.isBlank()) {
            html.append("        <tr>\n");
            html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;color:#888;font-size:14px;\">Mã vận đơn</td>\n");
            html.append("          <td style=\"padding:10px 0;border-bottom:1px solid #eeeeee;text-align:right;color:").append(BRAND_COLOR).append(";font-size:14px;font-weight:600;\">").append(trackingNumber).append("</td>\n");
            html.append("        </tr>\n");
        }
        html.append("        <tr>\n");
        html.append("          <td style=\"padding:10px 0;color:#1a1a1a;font-size:15px;font-weight:600;\">Tổng cộng</td>\n");
        html.append("          <td style=\"padding:10px 0;text-align:right;color:#1a1a1a;font-size:16px;font-weight:700;\">").append(totalAmount).append("</td>\n");
        html.append("        </tr>\n");
        html.append("      </table>\n");

        if ("SHIPPING".equals(status)) {
            html.append("      <p style=\"color:#666666;font-size:14px;line-height:1.6;margin:0 0 16px 0;\">\n");
            html.append("        Đơn hàng của bạn đã được bàn giao cho đơn vị vận chuyển. Bạn có thể theo dõi trạng thái giao hàng qua mã vận đơn.\n");
            html.append("      </p>\n");
        } else if ("PROCESSING".equals(status)) {
            html.append("      <p style=\"color:#666666;font-size:14px;line-height:1.6;margin:0 0 16px 0;\">\n");
            html.append("        Đơn hàng của bạn đã được xác nhận và đang được chuẩn bị. Chúng tôi sẽ thông báo khi đơn hàng được giao cho đơn vị vận chuyển. \n");
            html.append("      </p>\n");
        } else if ("CANCELLED".equals(status)) {
            html.append("      <p style=\"color:#666666;font-size:14px;line-height:1.6;margin:0 0 16px 0;\">\n");
            html.append("        Đơn hàng của bạn đã bị hủy. Nếu bạn đã thanh toán, vui lòng liên hệ bộ phận hỗ trợ để được hoàn tiền.\n");
            html.append("      </p>\n");
        } else if ("DELIVERED".equals(status)) {
            html.append("      <p style=\"color:#666666;font-size:14px;line-height:1.6;margin:0 0 16px 0;\">\n");
            html.append("        Đơn hàng đã được giao thành công. Cảm ơn bạn đã mua sắm tại MobileStore!\n");
            html.append("      </p>\n");
        }

        html.append("      <a href=\"http://localhost:8080/mobilestore/profile\" style=\"display:inline-block;background:").append(BRAND_COLOR).append(";color:#ffffff;padding:12px 28px;border-radius:8px;text-decoration:none;font-weight:600;font-size:14px;\">\n");
        html.append("        Xem Chi Tiết Đơn Hàng\n");
        html.append("      </a>\n");

        html.append("      <hr style=\"border:none;border-top:1px solid #eeeeee;margin:24px 0;\">\n");
        html.append("      <p style=\"color:#aaaaaa;font-size:12px;margin:0;text-align:center;\"> Đây là email tự động từ ").append(BRAND_NAME).append(". ").append(FOOTER_TEXT).append("</p>\n");
        html.append("    </div>\n");

        html.append("    <div style=\"background:#f4f4f4;padding:16px 32px;text-align:center;\">\n");
        html.append("      <p style=\"color:#aaaaaa;font-size:11px;margin:0;\">&#169; 2026 ").append(BRAND_NAME).append(". Mọi quyền được bảo lưu.</p>\n");
        html.append("    </div>\n");
        html.append("  </div>\n");

        html.append("</body>\n");
        html.append("</html>");
        return html.toString();
    }

    private static String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;");
    }
}
