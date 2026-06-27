package com.eventara.event.entity;

import com.eventara.common.enums.EventStatus;
import com.eventara.common.enums.TicketType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "events")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Event {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false)
    private Long organizerId;

    @Column
    private Long categoryId;

    @Column
    private LocalDateTime eventDate;

    @Column
    private LocalDateTime endDate;

    @Column
    private String venueName;

    @Column
    private String venueAddress;

    @Column
    private String city;

    @Column
    private String bannerImageUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private EventStatus status = EventStatus.DRAFT;

    @Enumerated(EnumType.STRING)
    @Column
    private TicketType ticketType;

    @Column
    private Integer maxCapacity;

    @Column
    private BigDecimal generalAdmissionPrice;

    @Column(columnDefinition = "TEXT")
    private String seatMapJson;

    @Column(columnDefinition = "TEXT")
    private String rejectionNotes;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(nullable = false)
    private LocalDateTime updatedAt;
}
