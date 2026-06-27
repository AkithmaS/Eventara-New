package com.eventara.auth.service;

import com.eventara.auth.dto.request.LoginRequest;
import com.eventara.auth.dto.request.RegisterRequest;
import com.eventara.auth.dto.response.AuthResponse;
import com.eventara.common.config.JwtUtil;
import com.eventara.common.enums.OrganizerStatus;
import com.eventara.common.enums.Role;
import com.eventara.common.exception.BadRequestException;
import com.eventara.common.exception.UnauthorizedException;
import com.eventara.organizer.dto.request.OrganizerApplicationRequest;
import com.eventara.organizer.entity.Organizer;
import com.eventara.organizer.repository.OrganizerRepository;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final OrganizerRepository organizerRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final UserDetailsService userDetailsService;

    // ── Register Customer ────────────────────────────────────────────────────

    @Override
    @Transactional
    public AuthResponse registerCustomer(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Email is already registered");
        }

        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .phoneNumber(request.getPhoneNumber())
                .role(Role.ROLE_CUSTOMER)
                .isActive(true)
                .isEmailVerified(false)
                .build();

        userRepository.save(user);

        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());
        String token = jwtUtil.generateToken(userDetails);

        return AuthResponse.builder()
                .token(token)
                .tokenType("Bearer")
                .role(user.getRole().name())
                .fullName(user.getFullName())
                .userId(user.getId())
                .build();
    }

    // ── Apply as Organizer ───────────────────────────────────────────────────

    @Override
    @Transactional
    public void applyOrganizer(OrganizerApplicationRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Email is already registered");
        }

        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .phoneNumber(request.getPhoneNumber())
                .role(Role.ROLE_ORGANIZER)
                .isActive(false)        // inactive until approved
                .isEmailVerified(false)
                .build();

        userRepository.save(user);

        Organizer organizer = Organizer.builder()
                .user(user)
                .organizationName(request.getOrganizationName())
                .organizationType(request.getOrganizationType())
                .description(request.getDescription())
                .websiteUrl(request.getWebsiteUrl())
                .status(OrganizerStatus.PENDING)
                .build();

        organizerRepository.save(organizer);
        // No JWT returned — account is pending admin approval
    }

    // ── Login ────────────────────────────────────────────────────────────────

    @Override
    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Invalid email or password"));

        if (!user.isActive()) {
            throw new UnauthorizedException("Account is not active. Please wait for approval.");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new UnauthorizedException("Invalid email or password");
        }

        // Organizers must be APPROVED before they can log in
        if (user.getRole() == Role.ROLE_ORGANIZER) {
            organizerRepository.findByUser_Id(user.getId())
                    .filter(o -> o.getStatus() == OrganizerStatus.APPROVED)
                    .orElseThrow(() -> new UnauthorizedException(
                            "Organizer account is pending approval or has been rejected"));
        }

        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());
        String token = jwtUtil.generateToken(userDetails);

        return AuthResponse.builder()
                .token(token)
                .tokenType("Bearer")
                .role(user.getRole().name())
                .fullName(user.getFullName())
                .userId(user.getId())
                .build();
    }
}
