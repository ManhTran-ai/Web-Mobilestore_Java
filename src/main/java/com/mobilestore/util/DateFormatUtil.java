package com.mobilestore.util;

import com.mobilestore.entity.Order;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormatUtil {

    private static final SimpleDateFormat DATE_TIME_FORMAT =
            new SimpleDateFormat("dd/MM/yyyy 'lúc' HH:mm", java.util.Locale.forLanguageTag("vi-VN"));

    public static String formatDateTime(Object orderObj) {
        if (orderObj == null) {
            return "—";
        }
        try {
            Date date = null;
            if (orderObj instanceof Order order) {
                date = order.getOrderDate();
            } else if (orderObj instanceof Date) {
                date = (Date) orderObj;
            }
            if (date == null) {
                return "—";
            }
            return DATE_TIME_FORMAT.format(date);
        } catch (Exception e) {
            return "—";
        }
    }
}
