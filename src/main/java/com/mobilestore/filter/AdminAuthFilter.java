package com.mobilestore.filter;

import com.mobilestore.entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=unauthorized");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user.getRoleName() == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/?error=access_denied");
            return;
        }

        String role = user.getRoleName();
        boolean isAdmin = "ADMIN".equals(role);
        boolean isInventoryManager = "INVENTORY_MANAGER".equals(role);

        if (!isAdmin && !isInventoryManager) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/?error=access_denied");
            return;
        }

        request.setAttribute("isAdmin", isAdmin);
        request.setAttribute("isInventoryManager", isInventoryManager);

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
