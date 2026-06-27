package com.eventara.event.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "seat_zones")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SeatZone {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long eventId;

    @Column
    private String zoneName;

    @Column
    private String zoneColor;

    @Column(nullable = false)
    private BigDecimal price;

    @Column
    private Integer totalSeats;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
}
