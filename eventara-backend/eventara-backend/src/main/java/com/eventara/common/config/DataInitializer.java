package com.eventara.common.config;

import com.eventara.common.enums.OrganizerStatus;
import com.eventara.common.enums.Role;
import com.eventara.event.entity.Category;
import com.eventara.event.repository.CategoryRepository;
import com.eventara.organizer.entity.Organizer;
import com.eventara.organizer.repository.OrganizerRepository;
import com.eventara.user.entity.User;
import com.eventara.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final UserRepository userRepository;
    private final OrganizerRepository organizerRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        seedAdmin();
        seedOrganizer();
        seedCategories();
    }

    // ── Admin Seed ───────────────────────────────────────────────────────────

    private void seedAdmin() {
        final String adminEmail = "admin@eventara.com";
        final String encodedPassword = passwordEncoder.encode("Admin@1234");

        userRepository.findByEmail(adminEmail).ifPresentOrElse(
                existing -> {
                    existing.setPassword(encodedPassword);
                    existing.setActive(true);
                    existing.setEmailVerified(true);
                    existing.setRole(Role.ROLE_ADMIN);
                    userRepository.save(existing);
                    log.info("Updated admin account password: {}", adminEmail);
                },
                () -> {
                    User admin = User.builder()
                            .fullName("System Admin")
                            .email(adminEmail)
                            .password(encodedPassword)
                            .role(Role.ROLE_ADMIN)
                            .isActive(true)
                            .isEmailVerified(true)
                            .build();
                    userRepository.save(admin);
                    log.info("Seeded default admin account: {}", adminEmail);
                }
        );
    }

    // ── Organizer Seed ───────────────────────────────────────────────────────

    private void seedOrganizer() {
        final String organizerEmail = "organizer@eventara.com";
        final String encodedPassword = passwordEncoder.encode("Organizer@1234");

        userRepository.findByEmail(organizerEmail).ifPresentOrElse(
                existing -> {
                    existing.setPassword(encodedPassword);
                    existing.setActive(true);
                    existing.setRole(Role.ROLE_ORGANIZER);
                    userRepository.save(existing);
                    log.info("Updated organizer account password: {}", organizerEmail);
                },
                () -> {
                    User user = User.builder()
                            .fullName("Demo Organizer")
                            .email(organizerEmail)
                            .password(encodedPassword)
                            .phoneNumber("+2000000000")
                            .role(Role.ROLE_ORGANIZER)
                            .isActive(true)
                            .isEmailVerified(true)
                            .build();
                    userRepository.save(user);

                    Organizer organizer = Organizer.builder()
                            .user(user)
                            .organizationName("Eventara Events Co.")
                            .organizationType("Entertainment")
                            .description("Official demo organizer account")
                            .websiteUrl("https://eventara.com")
                            .status(OrganizerStatus.APPROVED)
                            .build();
                    organizerRepository.save(organizer);
                    log.info("Seeded default organizer account: {}", organizerEmail);
                }
        );
    }

    // ── Category Seed ────────────────────────────────────────────────────────

    private void seedCategories() {
        if (categoryRepository.count() == 0) {
            log.info("Seeding default categories...");

            List<Category> defaults = List.of(
                    buildCategory("Music & Concerts",          "🎵", "Live music events and concerts"),
                    buildCategory("Sports",                    "🏟️", "Sports matches and tournaments"),
                    buildCategory("Theatre & Performing Arts", "🎭", "Theatre, dance, and stage performances"),
                    buildCategory("Comedy Shows",              "🎤", "Stand-up comedy and comedy events"),
                    buildCategory("Conferences & Seminars",    "🎓", "Professional conferences and seminars"),
                    buildCategory("Workshops",                 "🎨", "Hands-on workshops and training sessions"),
                    buildCategory("Film & Cinema",             "🎬", "Movie screenings and film festivals"),
                    buildCategory("Cultural Events",           "🕌", "Cultural and heritage events"),
                    buildCategory("Family & Kids",             "👶", "Events for families and children"),
                    buildCategory("Other",                     "📌", "Other events")
            );

            categoryRepository.saveAll(defaults);
            log.info("Seeded {} default categories", defaults.size());
        }
    }

    private Category buildCategory(String name, String icon, String description) {
        return Category.builder()
                .name(name)
                .icon(icon)
                .description(description)
                .isActive(true)
                .build();
    }
}
