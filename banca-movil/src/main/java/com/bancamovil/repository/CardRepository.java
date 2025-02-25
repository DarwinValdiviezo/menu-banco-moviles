package com.bancamovil.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.bancamovil.model.Card;
import com.bancamovil.model.User;
import java.util.List;

public interface CardRepository extends JpaRepository<Card, Long> {
    List<Card> findByUser(User user);
    List<Card> findByUser_Email(String email);
}
