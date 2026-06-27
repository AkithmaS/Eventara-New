package com.eventara.event.service;

import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.event.dto.response.CategoryResponse;
import com.eventara.event.entity.Category;
import com.eventara.event.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CategoryResponse> getAllActiveCategories() {
        return categoryRepository.findByIsActiveTrue().stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<CategoryResponse> getAllCategories() {
        return categoryRepository.findAll().stream()
                .map(this::toResponse)
                .toList();
    }

    @Override
    @Transactional
    public CategoryResponse createCategory(String name, String icon, String description) {
        if (categoryRepository.findByName(name).isPresent()) {
            throw new BadRequestException("Category with name '" + name + "' already exists");
        }

        Category category = Category.builder()
                .name(name)
                .icon(icon)
                .description(description)
                .isActive(true)
                .build();

        return toResponse(categoryRepository.save(category));
    }

    @Override
    @Transactional
    public CategoryResponse updateCategory(Long id, String name, String icon, String description) {
        Category category = findById(id);
        category.setName(name);
        category.setIcon(icon);
        category.setDescription(description);
        return toResponse(categoryRepository.save(category));
    }

    @Override
    @Transactional
    public void toggleCategoryActive(Long id) {
        Category category = findById(id);
        category.setActive(!category.isActive());
        categoryRepository.save(category);
    }

    private Category findById(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
    }

    private CategoryResponse toResponse(Category c) {
        return CategoryResponse.builder()
                .id(c.getId())
                .name(c.getName())
                .icon(c.getIcon())
                .description(c.getDescription())
                .isActive(c.isActive())
                .build();
    }
}
