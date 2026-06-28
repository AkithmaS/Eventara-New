package com.eventara.auth.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Component
public class JwtTokenProvider {

    @Value("${app.jwt.secret}")
    private String secret;

    @Value("${app.jwt.expiration-ms}")
    private long expirationMs;

    @Value("${app.jwt.refresh-expiration-ms}")
    private long refreshExpirationMs;

    // ── Key ──────────────────────────────────────────────────────────────────

    private SecretKey signingKey() {
        return Keys.hmacShaKeyFor(Decoders.BASE64.decode(secret));
    }

    // ── Generate ─────────────────────────────────────────────────────────────

    public String generateAccessToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        userDetails.getAuthorities().stream()
                .findFirst()
                .ifPresent(a -> claims.put("role", a.getAuthority()));
        return buildToken(claims, userDetails.getUsername(), expirationMs);
    }

    public String generateRefreshToken(UserDetails userDetails) {
        return buildToken(new HashMap<>(), userDetails.getUsername(), refreshExpirationMs);
    }

    private String buildToken(Map<String, Object> claims, String subject, long ttl) {
        long now = System.currentTimeMillis();
        return Jwts.builder()
                .claims(claims)
                .subject(subject)
                .issuedAt(new Date(now))
                .expiration(new Date(now + ttl))
                .signWith(signingKey())
                .compact();
    }

    // ── Extract ──────────────────────────────────────────────────────────────

    public String extractUsername(String token) {
        return extractAllClaims(token).getSubject();
    }

    public String extractRole(String token) {
        return extractAllClaims(token).get("role", String.class);
    }

    // ── Validate ─────────────────────────────────────────────────────────────

    public boolean validateToken(String token, UserDetails userDetails) {
        try {
            String username = extractUsername(token);
            return username.equals(userDetails.getUsername()) && !isTokenExpired(token);
        } catch (JwtException | IllegalArgumentException e) {
            log.debug("Invalid JWT token: {}", e.getMessage());
            return false;
        }
    }

    public boolean isTokenValid(String token) {
        try {
            extractAllClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(signingKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    private boolean isTokenExpired(String token) {
        return extractAllClaims(token).getExpiration().before(new Date());
    }
}
