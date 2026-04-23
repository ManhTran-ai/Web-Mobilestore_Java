package com.mobilestore.dao;

import com.mobilestore.entity.SliderImage;
import com.mobilestore.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SliderImageDAO {

    public List<SliderImage> findAll() {
        List<SliderImage> sliders = new ArrayList<>();
        String sql = "SELECT id, image_url, is_active FROM slider_images ORDER BY id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                sliders.add(mapResultSetToSliderImage(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy tất cả slider images: " + e.getMessage());
            e.printStackTrace();
        }
        return sliders;
    }

    public List<SliderImage> findAllActive() {
        List<SliderImage> sliders = new ArrayList<>();
        String sql = "SELECT id, image_url, is_active FROM slider_images WHERE is_active = 1 ORDER BY id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                sliders.add(mapResultSetToSliderImage(rs));
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy slider images active: " + e.getMessage());
            e.printStackTrace();
        }
        return sliders;
    }

    public SliderImage findById(Integer id) {
        String sql = "SELECT id, image_url, is_active FROM slider_images WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSliderImage(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tìm slider image theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public SliderImage create(SliderImage slider) {
        String sql = "INSERT INTO slider_images (image_url, is_active) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, slider.getImageUrl());
            ps.setInt(2, Boolean.TRUE.equals(slider.getIsActive()) ? 1 : 0);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        slider.setId(generatedKeys.getInt(1));
                        return slider;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo slider image: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(SliderImage slider) {
        String sql = "UPDATE slider_images SET image_url = ?, is_active = ? WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slider.getImageUrl());
            ps.setInt(2, Boolean.TRUE.equals(slider.getIsActive()) ? 1 : 0);
            ps.setInt(3, slider.getId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật slider image: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleActive(Integer id) {
        String sql = "UPDATE slider_images SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi toggle slider image: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(Integer id) {
        String sql = "DELETE FROM slider_images WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi khi xóa slider image: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public int countTotal() {
        String sql = "SELECT COUNT(*) FROM slider_images";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm slider images: " + e.getMessage());
        }
        return 0;
    }

    public int countActive() {
        String sql = "SELECT COUNT(*) FROM slider_images WHERE is_active = 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi đếm slider images active: " + e.getMessage());
        }
        return 0;
    }

    private SliderImage mapResultSetToSliderImage(ResultSet rs) throws SQLException {
        SliderImage slider = new SliderImage();
        slider.setId(rs.getInt("id"));
        slider.setImageUrl(rs.getString("image_url"));
        slider.setIsActive(rs.getInt("is_active") == 1);
        return slider;
    }
}
