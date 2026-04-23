package com.mobilestore.service;

import com.mobilestore.entity.SliderImage;
import java.util.List;

public interface SliderImageService {
    List<SliderImage> findAll();
    List<SliderImage> findAllActive();
    SliderImage findById(Integer id);
    SliderImage save(SliderImage slider);
    boolean update(SliderImage slider);
    boolean toggleActive(Integer id);
    boolean delete(Integer id);
    int countTotal();
    int countActive();
}
