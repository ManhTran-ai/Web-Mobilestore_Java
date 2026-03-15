package com.mobilestore.exception;

import com.mobilestore.dto.response.ErrorResponse;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@WebFilter("/*")
public class GlobalExceptionHandler implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        try {
            chain.doFilter(request, response);
        } catch (ResourceNotFoundException ex) {
            handleException(httpRequest, httpResponse, ex.getMessage(), 404);
        } catch (ValidationException ex) {
            handleValidationException(httpRequest, httpResponse, ex);
        } catch (ConstraintViolationException ex) {
            handleConstraintViolationException(httpRequest, httpResponse, ex);
        } catch (BusinessException ex) {
            handleException(httpRequest, httpResponse, ex.getMessage(), 400);
        } catch (Exception ex) {
            handleException(httpRequest, httpResponse, "Internal server error: " + ex.getMessage(), 500);
        }
    }

    private void handleException(HttpServletRequest request, HttpServletResponse response, 
                                   String message, int statusCode) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        ErrorResponse errorResponse = new ErrorResponse(statusCode, message, request.getRequestURI());
        response.getWriter().write(errorResponse.toJson());
    }

    private void handleValidationException(HttpServletRequest request, HttpServletResponse response,
                                            ValidationException ex) throws IOException {
        response.setStatus(400);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, String> errors = ex.getErrors() != null ? ex.getErrors() : new HashMap<>();
        if (errors.isEmpty()) {
            errors.put("message", ex.getMessage());
        }
        
        ErrorResponse errorResponse = new ErrorResponse(400, "Validation failed", request.getRequestURI());
        errorResponse.setValidationErrors(errors);
        response.getWriter().write(errorResponse.toJson());
    }

    private void handleConstraintViolationException(HttpServletRequest request, HttpServletResponse response,
                                                     ConstraintViolationException ex) throws IOException {
        response.setStatus(400);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, String> errors = new HashMap<>();
        Set<ConstraintViolation<?>> violations = ex.getConstraintViolations();
        for (ConstraintViolation<?> violation : violations) {
            String fieldName = violation.getPropertyPath().toString();
            if (fieldName.contains(".")) {
                fieldName = fieldName.substring(fieldName.lastIndexOf(".") + 1);
            }
            errors.put(fieldName, violation.getMessage());
        }
        
        ErrorResponse errorResponse = new ErrorResponse(400, "Validation failed", request.getRequestURI());
        errorResponse.setValidationErrors(errors);
        response.getWriter().write(errorResponse.toJson());
    }
}