package com.mobilestore.controller.admin;

import com.mobilestore.constant.UserAccountStatus;
import com.mobilestore.dao.UserDAO;
import com.mobilestore.entity.User;
import com.mobilestore.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users", "/admin/users/*"})
public class AdminUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getPathInfo();
        if (path == null || "/".equals(path)) {
            listUsers(request, response);
        } else if ("/view".equals(path)) {
            viewUser(request, response);
        } else if ("/create".equals(path)) {
            showCreateForm(request, response);
        } else if ("/edit".equals(path)) {
            showEditForm(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String path = request.getPathInfo();

        if ("/create".equals(path)) {
            createUser(request, response);
        } else if ("/update".equals(path)) {
            updateUser(request, response);
        } else if ("/delete".equals(path)) {
            deleteUser(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.findAllForAdmin(false);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/views/admin/users/user-list.jsp").forward(request, response);
    }

    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = loadUserOrRedirect(request, response);
        if (user == null) {
            return;
        }
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/admin/users/user-detail.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("isEdit", false);
        request.setAttribute("user", new User());
        request.getRequestDispatcher("/views/admin/users/user-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = loadUserOrRedirect(request, response);
        if (user == null) {
            return;
        }
        request.setAttribute("isEdit", true);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/admin/users/user-form.jsp").forward(request, response);
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");
        String roleName = trim(request.getParameter("roleName"));
        String accountStatus = trim(request.getParameter("accountStatus"));

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            forwardFormError(request, response, false, null, "Vui lòng nhập username và mật khẩu.");
            return;
        }

        if (userDAO.findByUsername(username) != null) {
            forwardFormError(request, response, false, null, "Username đã tồn tại.");
            return;
        }

        User user = buildUserFromRequest(request, username, roleName, accountStatus);
        user.setPassword(PasswordUtil.hashPassword(password));

        User created = userDAO.createByAdmin(user);
        if (created != null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
        } else {
            forwardFormError(request, response, false, user, "Không thể tạo người dùng.");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = parseId(request.getParameter("id"));
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            return;
        }

        User existing = userDAO.findById(id);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=not_found");
            return;
        }

        if (UserAccountStatus.DELETED.getCode().equals(existing.getAccountStatus())) {
            response.sendRedirect(request.getContextPath() + "/admin/users/view?id=" + id + "&error=deleted");
            return;
        }

        User user = buildUserFromRequest(request, trim(request.getParameter("username")), trim(request.getParameter("roleName")), trim(request.getParameter("accountStatus")));
        user.setId(id);

        if (userDAO.updateAdmin(user)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
        } else {
            forwardFormError(request, response, true, user, "Không thể cập nhật người dùng.");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = parseId(request.getParameter("id"));
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            return;
        }

        if (userDAO.softDelete(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=delete_failed");
        }
    }

    private User buildUserFromRequest(HttpServletRequest request, String username, String roleName, String accountStatus) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(trim(request.getParameter("email")));
        user.setRoleName(roleName != null && !roleName.isBlank() ? roleName : "CUSTOMER");
        user.setAccountStatus(accountStatus != null && !accountStatus.isBlank() ? accountStatus : UserAccountStatus.ACTIVE.getCode());
        user.setCustomerPhone(trim(request.getParameter("customerPhone")));
        user.setShippingAddress(trim(request.getParameter("shippingAddress")));
        user.setNote(trim(request.getParameter("note")));
        return user;
    }

    private User loadUserOrRedirect(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = parseId(request.getParameter("id"));
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            return null;
        }
        User user = userDAO.findById(id);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=not_found");
            return null;
        }
        return user;
    }

    private void forwardFormError(HttpServletRequest request, HttpServletResponse response,
                                  boolean isEdit, User user, String message) {
        try {
            request.setAttribute("isEdit", isEdit);
            request.setAttribute("user", user != null ? user : new User());
            request.setAttribute("errorMessage", message);
            request.getRequestDispatcher("/views/admin/users/user-form.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            throw new RuntimeException(e);
        }
    }

    private Integer parseId(String idStr) {
        if (idStr == null || idStr.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trim(String value) {
        return value != null ? value.trim() : null;
    }
}
