package com.eventara.auth.controller;

import com.eventara.auth.dto.request.LoginRequest;
import com.eventara.auth.dto.request.RegisterRequest;
import com.eventara.auth.dto.response.AuthResponse;
import com.eventara.auth.service.AuthService;
import com.eventara.common.response.ApiResponse;
import com.eventara.organizer.dto.request.OrganizerApplicationRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    // POST /api/auth/register
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<AuthResponse>> register(
            @Valid @RequestBody RegisterRequest request) {

        AuthResponse response = authService.registerCustomer(request);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(response, "Registration successful"));
    }

    // POST /api/auth/login
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(
            @Valid @RequestBody LoginRequest request) {

        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success(response, "Login successful"));
    }

    // POST /api/auth/organizer/apply
    @PostMapping("/organizer/apply")
    public ResponseEntity<ApiResponse<Void>> applyOrganizer(
            @Valid @RequestBody OrganizerApplicationRequest request) {

        authService.applyOrganizer(request);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success("Application submitted. You will be notified once reviewed."));
    }
}
