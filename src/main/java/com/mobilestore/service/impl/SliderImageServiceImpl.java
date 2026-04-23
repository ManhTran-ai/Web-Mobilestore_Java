package com.mobilestore.service.impl;

import com.mobilestore.dao.SliderImageDAO;
import com.mobilestore.entity.SliderImage;
import com.mobilestore.service.SliderImageService;
import java.util.List;

public class SliderImageServiceImpl implements SliderImageService {
    private final SliderImageDAO sliderImageDAO = new SliderImageDAO();

    @Override
    public List<SliderImage> findAll() {
        return sliderImageDAO.findAll();
    }

    @Override
    public List<SliderImage> findAllActive() {
        return sliderImageDAO.findAllActive();
    }

    @Override
    public SliderImage findById(Integer id) {
        return sliderImageDAO.findById(id);
    }

    @Override
    public SliderImage save(SliderImage slider) {
        if (slider.getIsActive() == null) {
            slider.setIsActive(true);
        }
        return sliderImageDAO.create(slider);
    }

    @Override
    public boolean update(SliderImage slider) {
        return sliderImageDAO.update(slider);
    }

    @Override
    public boolean toggleActive(Integer id) {
        return sliderImageDAO.toggleActive(id);
    }

    @Override
    public boolean delete(Integer id) {
        return sliderImageDAO.delete(id);
    }

    @Override
    public int countTotal() {
        return sliderImageDAO.countTotal();
    }

    @Override
    public int countActive() {
        return sliderImageDAO.countActive();
    }
}
