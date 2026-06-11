package com.mobilestore.controller;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import com.mobilestore.dao.OrderDAO;
import com.mobilestore.entity.Order;
import com.mobilestore.entity.OrderDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.awt.Color;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/order-print")
public class OrderPrintServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private static final Font TITLE_FONT = new Font(Font.HELVETICA, 18, Font.BOLD, new Color(26, 26, 26));
    private static final Font HEADER_FONT = new Font(Font.HELVETICA, 12, Font.BOLD, new Color(26, 26, 26));
    private static final Font NORMAL_FONT = new Font(Font.HELVETICA, 10, Font.NORMAL, new Color(51, 51, 51));
    private static final Font BOLD_FONT = new Font(Font.HELVETICA, 10, Font.BOLD, new Color(26, 26, 26));
    private static final Font SMALL_FONT = new Font(Font.HELVETICA, 9, Font.NORMAL, new Color(134, 134, 139));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?tab=orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Order order = orderDAO.findById(orderId);
        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng");
            return;
        }

        HttpSession session = request.getSession(false);
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null && order.getUser() != null 
                    && !userId.equals(order.getUser().getId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        

        try {
            generatePDF(order, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi khi tạo PDF", e);
        }
    }

    private void generatePDF(Order order, HttpServletResponse response) throws Exception {
        String fileName = "DonHang_" + order.getOrderId() + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        Document document = new Document(PageSize.A4, 40, 40, 50, 50);
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        Paragraph storeName = new Paragraph("MOBILE STORE", TITLE_FONT);
        storeName.setAlignment(Element.ALIGN_CENTER);
        document.add(storeName);

        Paragraph storeAddress = new Paragraph("123 Đường ABC, Quận 1, TP.HCM", SMALL_FONT);
        storeAddress.setAlignment(Element.ALIGN_CENTER);
        document.add(storeAddress);

        Paragraph storePhone = new Paragraph("Hotline: 1900 1234", SMALL_FONT);
        storePhone.setAlignment(Element.ALIGN_CENTER);
        storePhone.setSpacingAfter(20);
        document.add(storePhone);

        Paragraph title = new Paragraph("HÓA ĐƠN BÁN HÀNG", HEADER_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setWidths(new float[]{1, 1});
        infoTable.setSpacingAfter(20);

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        PdfPCell leftCell = new PdfPCell();
        leftCell.setBorder(Rectangle.NO_BORDER);
        leftCell.addElement(createLabelValue("Mã đơn hàng:", "#" + order.getOrderId()));
        leftCell.addElement(createLabelValue("Ngày đặt:", dateFormat.format(order.getOrderDate())));
        leftCell.addElement(createLabelValue("Trạng thái:", getStatusText(order.getOrderStatus())));
        leftCell.addElement(createLabelValue("Thanh toán:", getPaymentText(order.getPaymentMethod())));
        infoTable.addCell(leftCell);

        PdfPCell rightCell = new PdfPCell();
        rightCell.setBorder(Rectangle.NO_BORDER);
        if (order.getUser() != null) {
            rightCell.addElement(createLabelValue("Khách hàng:", 
                    order.getUser().getUsername() != null ? order.getUser().getUsername() : "Khách vãng lai"));
            if (order.getUser().getEmail() != null) {
                rightCell.addElement(createLabelValue("Email:", order.getUser().getEmail()));
            }
        } else {
            rightCell.addElement(createLabelValue("Khách hàng:", "Khách vãng lai"));
        }
        rightCell.addElement(createLabelValue("Điện thoại:", 
                order.getCustomerPhone() != null ? order.getCustomerPhone() : "-"));
        infoTable.addCell(rightCell);

        document.add(infoTable);

        if (order.getShippingAddress() != null && !order.getShippingAddress().isEmpty()) {
            Paragraph addrTitle = new Paragraph("ĐỊA CHỈ GIAO HÀNG", HEADER_FONT);
            addrTitle.setSpacingBefore(10);
            addrTitle.setSpacingAfter(8);
            document.add(addrTitle);

            Paragraph addrContent = new Paragraph(order.getShippingAddress(), NORMAL_FONT);
            addrContent.setSpacingAfter(20);
            document.add(addrContent);
        }

        Paragraph productTitle = new Paragraph("CHI TIẾT SẢN PHẨM", HEADER_FONT);
        productTitle.setSpacingBefore(10);
        productTitle.setSpacingAfter(8);
        document.add(productTitle);

        PdfPTable productTable = new PdfPTable(4);
        productTable.setWidthPercentage(100);
        productTable.setWidths(new float[]{3, 1, 1.5f, 2});
        productTable.setSpacingAfter(20);

        addTableHeader(productTable, new String[]{"Sản phẩm", "SL", "Đơn giá", "Thành tiền"});

        List<OrderDetail> details = order.getDetails();
        if (details != null && !details.isEmpty()) {
            for (OrderDetail item : details) {
                String productName = item.getProduct() != null ? item.getProduct().getProductName() : "Sản phẩm";
                String variant = "";
                if (item.getVariant() != null) {
                    variant = item.getVariant().getColor();
                    if (item.getVariant().getStorage() != null) {
                        variant += " / " + item.getVariant().getStorage();
                    }
                }

                Paragraph namePara = new Paragraph(productName, NORMAL_FONT);
                if (!variant.isEmpty()) {
                    namePara.add(new Chunk("\n" + variant, SMALL_FONT));
                }
                addTableCell(productTable, namePara);
                addTableCell(productTable, String.valueOf(item.getQuantity()), Element.ALIGN_CENTER);
                addTableCell(productTable, formatCurrency(item.getPrice()), Element.ALIGN_RIGHT);
                addTableCell(productTable, formatCurrency(item.getPrice() * item.getQuantity()), Element.ALIGN_RIGHT);
            }
        }

        document.add(productTable);

        PdfPTable summaryTable = new PdfPTable(2);
        summaryTable.setWidthPercentage(50);
        summaryTable.setHorizontalAlignment(Element.ALIGN_RIGHT);

        double subtotal = order.getTotalAmount();
        double shippingCost = order.getShippingCost() != null ? order.getShippingCost() : 0;

        addSummaryRow(summaryTable, "Tạm tính:", formatCurrency(subtotal));
        addSummaryRow(summaryTable, "Phí vận chuyển:", formatCurrency(shippingCost));

        if (order.getShippingDiscount() != null && order.getShippingDiscount() > 0) {
            addDiscountSummaryRow(summaryTable, "Ưu đãi phí vận chuyển:", formatCurrency(shippingCost));
        }

        PdfPCell labelCell = new PdfPCell(new Phrase("TỔNG CỘNG:", HEADER_FONT));
        labelCell.setBorder(Rectangle.TOP);
        labelCell.setBorderWidthTop(1);
        labelCell.setPaddingTop(8);
        labelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        labelCell.setBorderColor(new Color(229, 229, 229));

        PdfPCell valueCell = new PdfPCell(new Phrase(formatCurrency(order.getTotalAmount()), HEADER_FONT));
        valueCell.setBorder(Rectangle.TOP);
        valueCell.setBorderWidthTop(1);
        valueCell.setPaddingTop(8);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setBorderColor(new Color(229, 229, 229));

        summaryTable.addCell(labelCell);
        summaryTable.addCell(valueCell);
        document.add(summaryTable);

        Paragraph footer = new Paragraph("Cảm ơn quý khách đã mua sắm tại Mobile Store!", SMALL_FONT);
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(30);
        document.add(footer);

        document.close();
    }

    private Paragraph createLabelValue(String label, String value) {
        Paragraph p = new Paragraph();
        p.add(new Chunk(label + " ", SMALL_FONT));
        p.add(new Chunk(value, BOLD_FONT));
        p.setSpacingAfter(4);
        return p;
    }

    private void addTableHeader(PdfPTable table, String[] headers) {
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, HEADER_FONT));
            cell.setBackgroundColor(new Color(244, 245, 247));
            cell.setPadding(10);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }
    }

    private void addTableCell(PdfPTable table, String content, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(content, NORMAL_FONT));
        cell.setPadding(8);
        cell.setHorizontalAlignment(alignment);
        cell.setBorderColor(new Color(229, 229, 229));
        table.addCell(cell);
    }

    private void addTableCell(PdfPTable table, Paragraph content) {
        PdfPCell cell = new PdfPCell(content);
        cell.setPadding(8);
        cell.setBorderColor(new Color(229, 229, 229));
        table.addCell(cell);
    }

    private void addSummaryRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, NORMAL_FONT));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPadding(4);
        labelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, NORMAL_FONT));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPadding(4);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);

        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    private void addDiscountSummaryRow(PdfPTable table, String label, String value) {
        Font discountFont = new Font(Font.HELVETICA, 10, Font.NORMAL, new Color(46, 125, 50));

        PdfPCell labelCell = new PdfPCell(new Phrase(label, discountFont));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPadding(4);
        labelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);

        PdfPCell valueCell = new PdfPCell(new Phrase("-" + value, discountFont));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPadding(4);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);

        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    private String formatCurrency(Double amount) {
        if (amount == null) return "0 đ";
        return String.format("%,.0f đ", amount);
    }

    private String getStatusText(String status) {
        if (status == null) return "-";
        return switch (status) {
            case "PENDING" -> "Chờ xác nhận";
            case "PROCESSING" -> "Đang xử lý";
            case "SHIPPED" -> "Đang giao hàng";
            case "DELIVERED" -> "Đã giao hàng";
            case "CANCELLED" -> "Đã hủy";
            default -> status;
        };
    }

    private String getPaymentText(String method) {
        if (method == null) return "Tiền mặt";
        return switch (method) {
            case "VNPAY" -> "VNPay";
            case "OFFLINE" -> "Tại quầy";
            default -> "Tiền mặt (COD)";
        };
    }
}
