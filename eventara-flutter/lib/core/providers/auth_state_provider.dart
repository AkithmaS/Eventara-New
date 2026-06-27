// @riverpod AuthState authState(AuthStateRef ref)
// Reads stored JWT on app start, decodes role claim
// AuthState: { isAuthenticated, role, userId }
// Used by go_router redirect and role-based UI rendering
