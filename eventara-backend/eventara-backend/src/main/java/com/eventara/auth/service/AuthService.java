package com.eventara.auth.service;

import com.eventara.auth.dto.request.LoginRequest;
import com.eventara.auth.dto.request.RegisterRequest;
import com.eventara.auth.dto.response.AuthResponse;
import com.eventara.organizer.dto.request.OrganizerApplicationRequest;

public interface AuthService {

    AuthResponse login(LoginRequest request);

    AuthResponse registerCustomer(RegisterRequest request);

    void applyOrganizer(OrganizerApplicationRequest request);
}
