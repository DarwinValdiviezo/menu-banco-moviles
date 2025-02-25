package com.bancamovil.controller;

import com.bancamovil.model.Card;
import com.bancamovil.service.CardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/cards")
public class CardController {

    @Autowired
    private CardService cardService;

    // Obtener tarjeta por ID
    @GetMapping("/{id}")
    public Optional<Card> getCardById(@PathVariable Long id) {
        return cardService.getCardById(id);
    }

    // Obtener tarjetas de un usuario por ID
    @GetMapping("/user/{userId}")
    public List<Card> getCardsByUserId(@PathVariable Long userId) {
        return cardService.getCardsByUserId(userId);
    }

    // Obtener tarjetas de un usuario por Email
    @GetMapping("/user/email/{email}")
    public List<Card> getCardsByUserEmail(@PathVariable String email) {
        return cardService.getCardsByUserEmail(email);
    }

    // Crear tarjeta nueva
    @PostMapping
    public Card createCard(@RequestBody Card card) {
        return cardService.createCard(card);
    }

    // Eliminar tarjeta por ID
    @DeleteMapping("/{id}")
    public String deleteCard(@PathVariable Long id) {
        cardService.deleteCard(id);
        return "Tarjeta eliminada con éxito";
    }

    // Congelar o desbloquear tarjeta
    @PostMapping("/{id}/toggle-freeze")
    public String toggleFreezeCard(@PathVariable Long id) {
        cardService.toggleFreezeCard(id);
        return "Estado de la tarjeta cambiado con éxito";
    }
}
