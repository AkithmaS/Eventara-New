package com.eventara.organizer.controller;

import com.eventara.common.exception.ResourceNotFoundException;
import com.eventara.common.response.ApiResponse;
import com.eventara.organizer.dto.request.UpdateOrganizerRequest;
import com.eventara.organizer.dto.response.OrganizerDashboardResponse;
import com.eventara.organizer.dto.response.OrganizerResponse;
import com.eventara.organizer.service.OrganizerService;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/organizer")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ORGANIZER')")
public class OrganizerController {

    private final OrganizerService organizerService;
    private final UserRepository userRepository;

    // GET /api/organizer/profile
    @GetMapping("/profile")
    public ResponseEntity<ApiResponse<OrganizerResponse>> getProfile(
            @AuthenticationPrincipal UserDetails principal) {

        Long userId = resolveUserId(principal);
        OrganizerResponse response = organizerService.getOrganizerProfile(userId);
        return ResponseEntity.ok(ApiResponse.success(response, "Profile fetched successfully"));
    }

    // PUT /api/organizer/profile
    @PutMapping("/profile")
    public ResponseEntity<ApiResponse<OrganizerResponse>> updateProfile(
            @AuthenticationPrincipal UserDetails principal,
            @Valid @RequestBody UpdateOrganizerRequest request) {

        Long userId = resolveUserId(principal);
        OrganizerResponse response = organizerService.updateOrganizerProfile(userId, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Profile updated successfully"));
    }

    // GET /api/organizer/dashboard
    @GetMapping("/dashboard")
    public ResponseEntity<ApiResponse<OrganizerDashboardResponse>> getDashboard(
            @AuthenticationPrincipal UserDetails principal) {

        Long userId = resolveUserId(principal);
        OrganizerDashboardResponse response = organizerService.getOrganizerDashboard(userId);
        return ResponseEntity.ok(ApiResponse.success(response, "Dashboard fetched successfully"));
    }

    private Long resolveUserId(UserDetails principal) {
        return userRepository.findByEmail(principal.getUsername())
                .map(User::getId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}
