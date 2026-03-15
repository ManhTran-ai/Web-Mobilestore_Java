package com.mobilestore.controller.admin;

import com.mobilestore.service.CategoryService;
import com.mobilestore.service.impl.CategoryServiceImpl;
import com.mobilestore.entity.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCategoryServlet", urlPatterns = {"/admin/categories", "/admin/categories/*"})
public class AdminCategoryServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private final CategoryService categoryService = new CategoryServiceImpl();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String pathInfo = request.getPathInfo();
		if (pathInfo == null || "/".equals(pathInfo)) {
			showList(request, response);
		} else if ("/add".equals(pathInfo)) {
			showForm(request, response, false);
		} else if ("/edit".equals(pathInfo)) {
			showForm(request, response, true);
		} else if ("/delete".equals(pathInfo)) {
			confirmDelete(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String pathInfo = request.getPathInfo();
		if ("/add".equals(pathInfo)) {
			processAdd(request, response);
		} else if ("/edit".equals(pathInfo)) {
			processEdit(request, response);
		} else if ("/delete".equals(pathInfo)) {
			processDelete(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void showList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<Category> categories = categoryService.findAll();
		request.setAttribute("categories", categories);
		request.getRequestDispatcher("/views/admin/categories/category-list.jsp").forward(request, response);
	}

	private void showForm(HttpServletRequest request, HttpServletResponse response, boolean isEdit)
			throws ServletException, IOException {
		if (!isEdit) {
			response.sendRedirect(request.getContextPath() + "/admin/categories");
			return;
		}

		request.setAttribute("isEdit", true);
		String idParam = request.getParameter("id");
		if (idParam == null) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=missing_id");
			return;
		}
		try {
			Integer id = Integer.parseInt(idParam);
			Category category = categoryService.findById(id);
			if (category == null) {
				response.sendRedirect(request.getContextPath() + "/admin/categories?error=not_found");
				return;
			}
			request.setAttribute("category", category);
			request.getRequestDispatcher("/views/admin/categories/category-list.jsp").forward(request, response);
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=invalid_id");
			return;
		}
	}

	private void processAdd(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String name = request.getParameter("name");
		if (name == null || name.trim().isEmpty()) {
			request.setAttribute("error", "Tên danh mục không được để trống");
			request.setAttribute("isEdit", false);
			request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
			return;
		}
		if (name.trim().length() > 255) {
			request.setAttribute("error", "Tên danh mục không được vượt quá 255 ký tự");
			request.setAttribute("isEdit", false);
			request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
			return;
		}

		if (categoryService.findByName(name.trim()) != null) {
			request.setAttribute("error", "Danh mục đã tồn tại");
			request.setAttribute("isEdit", false);
			request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
			return;
		}

		Category category = new Category();
		category.setCategoryName(name.trim());
		Category created = categoryService.save(category);
		if (created != null) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?success=created");
		} else {
			request.setAttribute("error", "Không thể tạo danh mục. Vui lòng thử lại.");
			request.setAttribute("isEdit", false);
			request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
		}
	}

	private void processEdit(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String idParam = request.getParameter("id");
		String name = request.getParameter("name");
		if (idParam == null) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=missing_id");
			return;
		}
		try {
			Integer id = Integer.parseInt(idParam);
			Category existing = categoryService.findById(id);
			if (existing == null) {
				response.sendRedirect(request.getContextPath() + "/admin/categories?error=not_found");
				return;
			}

			if (name == null || name.trim().isEmpty()) {
				request.setAttribute("error", "Tên danh mục không được để trống");
				request.setAttribute("isEdit", true);
				request.setAttribute("category", existing);
				request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
				return;
			}
			if (name.trim().length() > 255) {
				request.setAttribute("error", "Tên danh mục không được vượt quá 255 ký tự");
				request.setAttribute("isEdit", true);
				request.setAttribute("category", existing);
				request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
				return;
			}

			Category byName = categoryService.findByName(name.trim());
			if (byName != null && !byName.getCategoryId().equals(id)) {
				request.setAttribute("error", "Tên danh mục đã được sử dụng bởi danh mục khác");
				request.setAttribute("isEdit", true);
				request.setAttribute("category", existing);
				request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
				return;
			}

			existing.setCategoryName(name.trim());
			boolean updated = categoryService.update(existing);
			if (updated) {
				response.sendRedirect(request.getContextPath() + "/admin/categories?success=updated");
			} else {
				request.setAttribute("error", "Không thể cập nhật danh mục. Vui lòng thử lại.");
				request.setAttribute("isEdit", true);
				request.setAttribute("category", existing);
				request.getRequestDispatcher("/views/admin/categories/category-form.jsp").forward(request, response);
			}

		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=invalid_id");
		}
	}

	private void confirmDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String idParam = request.getParameter("id");
		if (idParam == null) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=missing_id");
			return;
		}
		response.sendRedirect(request.getContextPath() + "/admin/categories?confirm=true&id=" + idParam);
	}

	private void processDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String idParam = request.getParameter("id");
		String confirm = request.getParameter("confirm");
		if (idParam == null) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=missing_id");
			return;
		}
		if (!"true".equals(confirm)) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=confirm_required&id=" + idParam);
			return;
		}
		try {
			Integer id = Integer.parseInt(idParam);
			boolean deleted = categoryService.delete(id);
			if (deleted) {
				response.sendRedirect(request.getContextPath() + "/admin/categories?success=deleted");
			} else {
				response.sendRedirect(request.getContextPath() + "/admin/categories?error=delete_failed");
			}
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/admin/categories?error=invalid_id");
		}
	}
}
