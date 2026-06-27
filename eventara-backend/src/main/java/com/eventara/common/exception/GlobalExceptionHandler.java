package com.eventara.common.exception;

// @RestControllerAdvice
// Handles: ResourceNotFoundException → 404
//          BusinessException → 409 / 400
//          MethodArgumentNotValidException → 422 (validation errors)
//          AccessDeniedException → 403
//          AuthenticationException → 401
//          Generic → 500
// Returns ApiResponse<Void> with errorCode field
