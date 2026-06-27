package com.eventara.auth.security;

// @Configuration @EnableWebSecurity @EnableMethodSecurity
// Configures JWT filter chain, CORS, CSRF disable, role-based URL rules:
//   PUBLIC:     POST /api/v1/auth/**
//   CUSTOMER:   /api/v1/bookings/**, /api/v1/tickets/**
//   ORGANIZER:  /api/v1/organizer/**
//   ADMIN:      /api/v1/admin/**
