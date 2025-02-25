package com.bancamovil.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.bancamovil.model.Transaction;
import com.bancamovil.model.User;
import java.util.List;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {

    List<Transaction> findByUser(User user); // Busca transacciones por usuario


    // ✅ Corrección: Usamos @Query para buscar por el email del usuario relacionado
    @Query("SELECT t FROM Transaction t WHERE t.user.email = :email")
    List<Transaction> findTransactionsByUserEmail(@Param("email") String email);
}
