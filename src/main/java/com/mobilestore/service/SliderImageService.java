package com.mobilestore.service;

import com.mobilestore.entity.SliderImage;
import java.util.List;

public interface SliderImageService {
    List<SliderImage> findAll();
    List<SliderImage> findActive();
    SliderImage findById(Integer id);
    SliderImage save(SliderImage slider);
    boolean update(SliderImage slider);
    boolean delete(Integer id);
    boolean toggleActive(Integer id);
    int countActive();
    int countInactive();
}
