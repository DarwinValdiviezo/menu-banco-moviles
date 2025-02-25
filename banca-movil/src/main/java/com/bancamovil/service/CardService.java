package com.bancamovil.service;

import com.bancamovil.model.Card;
import com.bancamovil.model.User;
import com.bancamovil.repository.CardRepository;
import com.bancamovil.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class CardService {

    @Autowired
    private CardRepository cardRepository;

    @Autowired
    private UserRepository userRepository;

    // Obtener una tarjeta por ID
    public Optional<Card> getCardById(Long id) {
        return cardRepository.findById(id);
    }

    // Obtener todas las tarjetas de un usuario por ID
    public List<Card> getCardsByUserId(Long userId) {
        Optional<User> user = userRepository.findById(userId);
        return user.map(cardRepository::findByUser).orElse(null);
    }

    // Obtener todas las tarjetas de un usuario por Email
    public List<Card> getCardsByUserEmail(String email) {
        return cardRepository.findByUser_Email(email);
    }

    // Crear una tarjeta nueva
    public Card createCard(Card card) {
        if (card.getUser() == null || card.getUser().getEmail() == null) {
            throw new RuntimeException("Debe asociar la tarjeta a un usuario válido");
        }
        Optional<User> userOpt = userRepository.findByEmail(card.getUser().getEmail());
        if (userOpt.isPresent()) {
            card.setUser(userOpt.get());
            return cardRepository.save(card);
        } else {
            throw new RuntimeException("Usuario no encontrado");
        }
    }

    // Eliminar una tarjeta por ID
    public void deleteCard(Long id) {
        cardRepository.deleteById(id);
    }

    // Congelar o desbloquear una tarjeta
    public void toggleFreezeCard(Long cardId) {
        Optional<Card> cardOpt = cardRepository.findById(cardId);
        if (cardOpt.isPresent()) {
            Card card = cardOpt.get();
            card.setFrozen(!card.isFrozen());
            cardRepository.save(card);
        } else {
            throw new RuntimeException("Tarjeta no encontrada");
        }
    }
}
