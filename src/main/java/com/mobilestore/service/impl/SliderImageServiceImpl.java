package com.mobilestore.service.impl;

import com.mobilestore.dao.SliderImageDAO;
import com.mobilestore.entity.SliderImage;
import com.mobilestore.service.SliderImageService;
import java.util.List;

public class SliderImageServiceImpl implements SliderImageService {
    private final SliderImageDAO sliderDAO = new SliderImageDAO();

    @Override
    public List<SliderImage> findAll() {
        return sliderDAO.findAll();
    }

    @Override
    public List<SliderImage> findActive() {
        return sliderDAO.findActive();
    }

    @Override
    public SliderImage findById(Integer id) {
        return sliderDAO.findById(id);
    }

    @Override
    public SliderImage save(SliderImage slider) {
        return sliderDAO.create(slider);
    }

    @Override
    public boolean update(SliderImage slider) {
        return sliderDAO.update(slider);
    }

    @Override
    public boolean delete(Integer id) {
        return sliderDAO.delete(id);
    }

    @Override
    public boolean toggleActive(Integer id) {
        return sliderDAO.toggleActive(id);
    }

    @Override
    public int countActive() {
        return sliderDAO.countActive();
    }

    @Override
    public int countInactive() {
        return sliderDAO.countInactive();
    }
}
