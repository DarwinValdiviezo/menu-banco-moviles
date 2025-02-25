package com.bancamovil.model;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Data
@Table(name = "transactions")
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private BigDecimal amount; // Monto de la transacción

    @Column(nullable = false)
    private String type; // Tipo de transacción: "DEPOSIT" o "WITHDRAWAL"

    @Column(nullable = false)
    private LocalDateTime date = LocalDateTime.now(); // Fecha de la transacción

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // Relación con el usuario

    public String getUserEmail() {
        return user != null ? user.getEmail() : null;
    }

    public void setUserEmail(String email) {
        if (user == null) {
            user = new User();
        }
        user.setEmail(email);
    }
}
