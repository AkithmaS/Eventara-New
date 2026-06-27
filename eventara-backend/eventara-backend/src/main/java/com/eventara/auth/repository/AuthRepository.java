package com.eventara.auth.repository;

import com.eventara.auth.entity.Auth;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AuthRepository extends JpaRepository<Auth, Long> {
    // queries will be added later
}
