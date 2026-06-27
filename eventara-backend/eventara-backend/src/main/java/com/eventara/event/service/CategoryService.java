package com.eventara.event.service;

import com.eventara.event.dto.response.CategoryResponse;

import java.util.List;

public interface CategoryService {

    List<CategoryResponse> getAllActiveCategories();

    List<CategoryResponse> getAllCategories();

    CategoryResponse createCategory(String name, String icon, String description);

    CategoryResponse updateCategory(Long id, String name, String icon, String description);

    void toggleCategoryActive(Long id);
}
