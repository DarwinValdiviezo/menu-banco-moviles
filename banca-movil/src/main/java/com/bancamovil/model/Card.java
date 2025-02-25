package com.bancamovil.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "cards")
public class Card {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String cardNumber;

    private boolean isFrozen = false; // Por defecto, las tarjetas no están congeladas

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // Relación con el usuario

    // Constructor sin ID (para crear nuevas tarjetas)
    public Card(String cardNumber, User user) {
        this.cardNumber = cardNumber;
        this.user = user;
    }

    // Obtener email del usuario
    public String getUserEmail() {
        return user != null ? user.getEmail() : null;
    }

    // Método toString() para depuración
    @Override
    public String toString() {
        return "Card{" +
                "id=" + id +
                ", cardNumber='" + cardNumber + '\'' +
                ", isFrozen=" + isFrozen +
                ", userEmail=" + getUserEmail() +
                '}';
    }
}
