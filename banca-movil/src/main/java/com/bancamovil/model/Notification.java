package com.bancamovil.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "notifications")
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String message; // Contenido de la notificación

    @Column(nullable = false)
    private LocalDateTime date = LocalDateTime.now(); // Fecha de la notificación

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // Relación con el usuario

    // Constructor para crear notificaciones rápidamente
    public Notification(String message, User user) {
        this.message = message;
        this.user = user;
        this.date = LocalDateTime.now();
    }

    // Obtener email del usuario
    public String getUserEmail() {
        return user != null ? user.getEmail() : null;
    }
}
