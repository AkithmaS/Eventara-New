package com.eventara.user.controller;

import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.common.response.ApiResponse;
import com.eventara.user.dto.request.ChangePasswordRequest;
import com.eventara.user.dto.request.UpdateUserRequest;
import com.eventara.user.dto.response.UserResponse;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import com.eventara.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_CUSTOMER')")
public class UserController {

    private final UserService userService;
    private final UserRepository userRepository;

    // GET /api/users/me - Get current user profile
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserResponse>> getCurrentUser() {
        Long userId = resolveUserId();
        UserResponse user = userService.getCurrentUser(userId);
        return ResponseEntity.ok(ApiResponse.success(user, "User profile fetched successfully"));
    }

    // PUT /api/users/me - Update current user profile
    @PutMapping("/me")
    public ResponseEntity<ApiResponse<UserResponse>> updateProfile(
            @Valid @RequestBody UpdateUserRequest request) {
        Long userId = resolveUserId();
        UserResponse user = userService.updateUserProfile(userId, request);
        return ResponseEntity.ok(ApiResponse.success(user, "Profile updated successfully"));
    }

    // POST /api/users/me/change-password - Change password
    @PostMapping("/me/change-password")
    public ResponseEntity<ApiResponse<Void>> changePassword(
            @Valid @RequestBody ChangePasswordRequest request) {
        Long userId = resolveUserId();
        userService.changePassword(userId, request.getCurrentPassword(), request.getNewPassword());
        return ResponseEntity.ok(ApiResponse.success("Password changed successfully"));
    }

    // ── Helper ───────────────────────────────────────────────────────────────

    private Long resolveUserId() {
        String email = SecurityContextHolder.getContext().getAuthentication().getName();
        return userRepository.findByEmail(email)
                .map(User::getId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}
