package com.bancamovil.service;

import com.bancamovil.model.Transaction;
import com.bancamovil.model.User;
import com.bancamovil.repository.TransactionRepository;
import com.bancamovil.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private UserRepository userRepository;

    // Obtener una transacción por ID
    public Optional<Transaction> getTransactionById(Long id) {
        return transactionRepository.findById(id);
    }

    // Obtener todas las transacciones de un usuario por ID
    public List<Transaction> getTransactionsByUserId(Long userId) {
        Optional<User> user = userRepository.findById(userId);
        return user.map(transactionRepository::findByUser)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado"));
    }

    // Obtener todas las transacciones de un usuario por Email
    public List<Transaction> getTransactionsByUserEmail(String email) {
        return transactionRepository.findTransactionsByUserEmail(email); // ✅ Corrección: Usamos la consulta corregida
    }

    // Realizar una transacción (Depósito o Retiro)
    public Transaction makeTransaction(String email, BigDecimal amount, String type) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado");
        }

        User user = userOpt.get();

        // Validar tipo de transacción
        if (!type.equalsIgnoreCase("DEPOSIT") && !type.equalsIgnoreCase("WITHDRAWAL")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tipo de transacción inválido (DEPOSIT o WITHDRAWAL)");
        }

        // Validar saldo en caso de retiro
        if (type.equalsIgnoreCase("WITHDRAWAL") && user.getSaldo().compareTo(amount) < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Saldo insuficiente");
        }

        // Crear la transacción
        Transaction transaction = new Transaction();
        transaction.setAmount(amount);
        transaction.setType(type.toUpperCase());
        transaction.setUser(user);
        Transaction savedTransaction = transactionRepository.save(transaction);

        // Actualizar saldo del usuario
        if (type.equalsIgnoreCase("DEPOSIT")) {
            user.setSaldo(user.getSaldo().add(amount));
        } else if (type.equalsIgnoreCase("WITHDRAWAL")) {
            user.setSaldo(user.getSaldo().subtract(amount));
        }
        userRepository.save(user);

        return savedTransaction;
    }

    // Eliminar una transacción por ID
    public void deleteTransaction(Long id) {
        if (!transactionRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Transacción no encontrada");
        }
        transactionRepository.deleteById(id);
    }
}
