package com.mobilestore.controller.admin;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.mobilestore.dto.AdminDashboardData;
import com.mobilestore.service.AdminDashboardService;
import com.mobilestore.service.impl.AdminDashboardServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.awt.Color;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "DashboardPdfServlet", urlPatterns = {"/admin/dashboard-pdf"})
public class DashboardPdfServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AdminDashboardService dashboardService = new AdminDashboardServiceImpl();

    private static final Font TITLE_FONT = new Font(Font.HELVETICA, 18, Font.BOLD, new Color(26, 26, 26));
    private static final Font HEADER_FONT = new Font(Font.HELVETICA, 12, Font.BOLD, new Color(26, 26, 26));
    private static final Font NORMAL_FONT = new Font(Font.HELVETICA, 10, Font.NORMAL, new Color(51, 51, 51));
    private static final Font BOLD_FONT = new Font(Font.HELVETICA, 10, Font.BOLD, new Color(26, 26, 26));
    private static final Font SMALL_FONT = new Font(Font.HELVETICA, 9, Font.NORMAL, new Color(134, 134, 139));
    private static final Font SECTION_FONT = new Font(Font.HELVETICA, 11, Font.BOLD, new Color(26, 26, 26));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            generatePDF(request, response);
        } catch (Exception e) {
            throw new ServletException("Lỗi khi tạo PDF", e);
        }
    }

    private void generatePDF(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String fileName = "Dashboard_Report_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        AdminDashboardData data = dashboardService.getDashboardData();

        Document document = new Document(PageSize.A4, 40, 40, 50, 50);
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        Paragraph title = new Paragraph("BÁO CÁO DASHBOARD", TITLE_FONT);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        Paragraph dateInfo = new Paragraph("Ngày xuất: " + new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()), SMALL_FONT);
        dateInfo.setAlignment(Element.ALIGN_CENTER);
        dateInfo.setSpacingAfter(20);
        document.add(dateInfo);

        addQuickMetricsSection(document, data);

        addRevenueSection(document, data);

        addOrderStatusSection(document, data);

        addTopSellingSection(document, data);

        addLowStockSection(document, data);

        document.close();
    }

    private void addQuickMetricsSection(Document document, AdminDashboardData data) throws Exception {
        Paragraph sectionTitle = new Paragraph("TỔNG QUAN", SECTION_FONT);
        sectionTitle.setSpacingBefore(15);
        sectionTitle.setSpacingAfter(10);
        document.add(sectionTitle);

        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1, 1, 1});
        table.setSpacingAfter(15);

        PdfPCell cell1 = createMetricCell("Người dùng mới (tháng)", String.valueOf(data.getNewUsers()));
        PdfPCell cell2 = createMetricCell("Đơn hàng mới (hôm nay)", String.valueOf(data.getNewOrdersToday()));
        PdfPCell cell3 = createMetricCell("Tổng đơn hàng", String.valueOf(data.getTotalOrders()));

        table.addCell(cell1);
        table.addCell(cell2);
        table.addCell(cell3);

        document.add(table);
    }

    private PdfPCell createMetricCell(String label, String value) {
        PdfPCell cell = new PdfPCell();
        cell.setBorderColor(new Color(229, 229, 229));
        cell.setPadding(12);
        cell.setBackgroundColor(new Color(247, 247, 250));

        Paragraph labelPara = new Paragraph(label, SMALL_FONT);
        labelPara.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(labelPara);

        Paragraph valuePara = new Paragraph(value, BOLD_FONT);
        valuePara.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(valuePara);

        return cell;
    }

    private void addRevenueSection(Document document, AdminDashboardData data) throws Exception {
        Paragraph sectionTitle = new Paragraph("DOANH THU THEO THỜI GIAN", SECTION_FONT);
        sectionTitle.setSpacingBefore(10);
        sectionTitle.setSpacingAfter(10);
        document.add(sectionTitle);

        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{1, 1, 1, 1, 1});
        table.setSpacingAfter(15);

        addRevenueCell(table, "Ngày", data.getRevenueToday());
        addRevenueCell(table, "Tuần", data.getRevenueWeek());
        addRevenueCell(table, "Tháng", data.getRevenueMonth());
        addRevenueCell(table, "Quý", data.getRevenueQuarter());
        addRevenueCell(table, "Năm", data.getRevenueYear());

        document.add(table);
    }

    private void addRevenueCell(PdfPTable table, String period, Double amount) {
        PdfPCell cell = new PdfPCell();
        cell.setBorderColor(new Color(229, 229, 229));
        cell.setPadding(10);
        cell.setBackgroundColor(new Color(247, 247, 250));

        Paragraph periodPara = new Paragraph(period, SMALL_FONT);
        periodPara.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(periodPara);

        Paragraph amountPara = new Paragraph(formatCurrency(amount), BOLD_FONT);
        amountPara.setAlignment(Element.ALIGN_CENTER);
        cell.addElement(amountPara);

        table.addCell(cell);
    }

    private void addOrderStatusSection(Document document, AdminDashboardData data) throws Exception {
        Paragraph sectionTitle = new Paragraph("TÌNH TRẠNG ĐƠN HÀNG", SECTION_FONT);
        sectionTitle.setSpacingBefore(10);
        sectionTitle.setSpacingAfter(10);
        document.add(sectionTitle);

        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(60);
        table.setWidths(new float[]{2, 1});
        table.setSpacingAfter(15);

        PdfPCell header1 = new PdfPCell(new Phrase("Trạng thái", HEADER_FONT));
        header1.setBackgroundColor(new Color(244, 245, 247));
        header1.setPadding(8);
        table.addCell(header1);

        PdfPCell header2 = new PdfPCell(new Phrase("Số lượng", HEADER_FONT));
        header2.setBackgroundColor(new Color(244, 245, 247));
        header2.setPadding(8);
        header2.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(header2);

        addStatusRow(table, "PENDING (Chờ xác nhận)", data.getPendingCount());
        addStatusRow(table, "PROCESSING (Đang xử lý)", data.getProcessingCount());
        addStatusRow(table, "SHIPPED (Đang giao)", data.getShippedCount());
        addStatusRow(table, "DELIVERED (Đã giao)", data.getCompletedCount());
        addStatusRow(table, "CANCELLED (Đã hủy)", data.getCancelledCount());

        document.add(table);
    }

    private void addStatusRow(PdfPTable table, String status, int count) {
        PdfPCell statusCell = new PdfPCell(new Phrase(status, NORMAL_FONT));
        statusCell.setPadding(8);
        statusCell.setBorderColor(new Color(229, 229, 229));
        table.addCell(statusCell);

        PdfPCell countCell = new PdfPCell(new Phrase(String.valueOf(count), BOLD_FONT));
        countCell.setPadding(8);
        countCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        countCell.setBorderColor(new Color(229, 229, 229));
        table.addCell(countCell);
    }

    private void addTopSellingSection(Document document, AdminDashboardData data) throws Exception {
        Paragraph sectionTitle = new Paragraph("TOP SẢN PHẨM BÁN CHẠY", SECTION_FONT);
        sectionTitle.setSpacingBefore(10);
        sectionTitle.setSpacingAfter(10);
        document.add(sectionTitle);

        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{0.5f, 1, 2.5f, 1.5f, 1});
        table.setSpacingAfter(15);

        PdfPCell header1 = new PdfPCell(new Phrase("#", HEADER_FONT));
        PdfPCell header2 = new PdfPCell(new Phrase("Mã SP", HEADER_FONT));
        PdfPCell header3 = new PdfPCell(new Phrase("Tên sản phẩm", HEADER_FONT));
        PdfPCell header4 = new PdfPCell(new Phrase("Hãng", HEADER_FONT));
        PdfPCell header5 = new PdfPCell(new Phrase("Đã bán", HEADER_FONT));

        for (PdfPCell header : new PdfPCell[]{header1, header2, header3, header4, header5}) {
            header.setBackgroundColor(new Color(244, 245, 247));
            header.setPadding(8);
            header.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(header);
        }

        var products = data.getTopSellingProducts();
        if (products != null && !products.isEmpty()) {
            int rank = 1;
            for (AdminDashboardData.TopSellingProduct product : products) {
                addTableCell(table, String.valueOf(rank), Element.ALIGN_CENTER);
                addTableCell(table, "#" + product.getProductId(), Element.ALIGN_CENTER);
                addTableCell(table, product.getProductName(), Element.ALIGN_LEFT);
                addTableCell(table, product.getManufacturer(), Element.ALIGN_CENTER);
                addTableCell(table, String.valueOf(product.getTotalSold()), Element.ALIGN_CENTER);
                rank++;
            }
        } else {
            PdfPCell emptyCell = new PdfPCell(new Phrase("Chưa có dữ liệu bán hàng", NORMAL_FONT));
            emptyCell.setColspan(5);
            emptyCell.setPadding(10);
            emptyCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            emptyCell.setBorderColor(new Color(229, 229, 229));
            table.addCell(emptyCell);
        }

        document.add(table);
    }

    private void addLowStockSection(Document document, AdminDashboardData data) throws Exception {
        Paragraph sectionTitle = new Paragraph("SẢN PHẨM TỒN KHO THẤP (DƯỚI 5)", SECTION_FONT);
        sectionTitle.setSpacingBefore(10);
        sectionTitle.setSpacingAfter(10);
        document.add(sectionTitle);

        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{0.5f, 1, 2f, 1.5f, 1});
        table.setSpacingAfter(15);

        PdfPCell header1 = new PdfPCell(new Phrase("#", HEADER_FONT));
        PdfPCell header2 = new PdfPCell(new Phrase("Mã biến thể", HEADER_FONT));
        PdfPCell header3 = new PdfPCell(new Phrase("Sản phẩm", HEADER_FONT));
        PdfPCell header4 = new PdfPCell(new Phrase("Phiên bản", HEADER_FONT));
        PdfPCell header5 = new PdfPCell(new Phrase("Tồn kho", HEADER_FONT));

        for (PdfPCell header : new PdfPCell[]{header1, header2, header3, header4, header5}) {
            header.setBackgroundColor(new Color(244, 245, 247));
            header.setPadding(8);
            header.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(header);
        }

        var variants = data.getLowStockVariants();
        if (variants != null && !variants.isEmpty()) {
            int rank = 1;
            for (AdminDashboardData.LowStockVariant variant : variants) {
                addTableCell(table, String.valueOf(rank), Element.ALIGN_CENTER);
                addTableCell(table, "#" + variant.getVariantId(), Element.ALIGN_CENTER);
                addTableCell(table, variant.getProductName(), Element.ALIGN_LEFT);
                String version = variant.getColor() + " / " + variant.getStorage();
                addTableCell(table, version, Element.ALIGN_CENTER);
                addTableCell(table, String.valueOf(variant.getQuantityInStock()), Element.ALIGN_CENTER);
                rank++;
            }
        } else {
            PdfPCell emptyCell = new PdfPCell(new Phrase("Không có sản phẩm tồn kho dưới 5", NORMAL_FONT));
            emptyCell.setColspan(5);
            emptyCell.setPadding(10);
            emptyCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            emptyCell.setBorderColor(new Color(229, 229, 229));
            table.addCell(emptyCell);
        }

        document.add(table);
    }

    private void addTableCell(PdfPTable table, String content, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(content, NORMAL_FONT));
        cell.setPadding(8);
        cell.setHorizontalAlignment(alignment);
        cell.setBorderColor(new Color(229, 229, 229));
        table.addCell(cell);
    }

    private String formatCurrency(Double amount) {
        if (amount == null) return "0 đ";
        return String.format("%,.0f đ", amount);
    }
}
