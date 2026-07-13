package com.eventara.user.service;

import com.eventara.user.dto.request.UpdateUserRequest;
import com.eventara.user.dto.response.UserResponse;

public interface UserService {

    UserResponse getCurrentUser(Long userId);

    UserResponse updateUserProfile(Long userId, UpdateUserRequest request);

    UserResponse changePassword(Long userId, String currentPassword, String newPassword);
}
