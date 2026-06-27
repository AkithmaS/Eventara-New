package com.eventara.admin.dto.response;

import com.eventara.common.enums.Role;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class AdminUserResponse {

    private Long id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private Role role;
    private boolean isActive;
    private boolean isEmailVerified;
    private LocalDateTime createdAt;
}
