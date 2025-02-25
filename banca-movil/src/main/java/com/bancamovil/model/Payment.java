package com.bancamovil.model;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "payments")
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private BigDecimal amount; // Monto del pago

    @Column(nullable = false)
    private LocalDateTime date = LocalDateTime.now(); // Fecha del pago

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // Relación con el usuario

    // Método para obtener email del usuario correctamente
    public String getUserEmail() {
        return user != null ? user.getEmail() : null;
    }
}
