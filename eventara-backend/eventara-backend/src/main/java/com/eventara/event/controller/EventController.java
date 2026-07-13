package com.eventara.event.controller;

import com.eventara.booking.dto.response.SeatResponse;
import com.eventara.booking.service.BookingService;
import com.eventara.common.response.ApiResponse;
import com.eventara.event.dto.response.CategoryResponse;
import com.eventara.event.dto.response.EventResponse;
import com.eventara.event.service.CategoryService;
import com.eventara.event.service.EventService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/events")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;
    private final CategoryService categoryService;
    private final BookingService bookingService;

    // GET /api/events?categoryId=&keyword=  (public)
    @GetMapping
    public ResponseEntity<ApiResponse<List<EventResponse>>> getPublishedEvents(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword) {

        List<EventResponse> events = eventService.getPublishedEvents(categoryId, keyword);
        return ResponseEntity.ok(ApiResponse.success(events, "Events fetched successfully"));
    }

    // GET /api/events/{id}  (public)
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<EventResponse>> getEventById(@PathVariable Long id) {
        EventResponse event = eventService.getEventById(id);
        return ResponseEntity.ok(ApiResponse.success(event, "Event fetched successfully"));
    }

    // GET /api/events/{id}/seats  (public - fetch seat map for event)
    @GetMapping("/{id}/seats")
    public ResponseEntity<ApiResponse<List<SeatResponse>>> getEventSeats(@PathVariable Long id) {
        List<SeatResponse> seats = bookingService.getEventSeats(id);
        return ResponseEntity.ok(ApiResponse.success(seats, "Seats fetched successfully"));
    }

    // GET /api/events/categories  (public)
    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<CategoryResponse>>> getAllActiveCategories() {
        List<CategoryResponse> categories = categoryService.getAllActiveCategories();
        return ResponseEntity.ok(ApiResponse.success(categories, "Categories fetched successfully"));
    }
}

