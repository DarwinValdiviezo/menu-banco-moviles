package com.bancamovil.model;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;

@Entity
@Data
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    private String name;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private BigDecimal saldo = BigDecimal.ZERO;

    // Método setPassword sin encriptación
    public void setPassword(String password) {
        this.password = password; // Se almacena directamente sin encriptar
    }
}
