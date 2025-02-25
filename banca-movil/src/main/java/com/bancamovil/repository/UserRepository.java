package com.bancamovil.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.bancamovil.model.User;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email); // Para buscar usuarios por email
}
