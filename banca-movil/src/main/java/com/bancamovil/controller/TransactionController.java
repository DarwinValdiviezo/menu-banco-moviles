package com.bancamovil.controller;

import com.bancamovil.model.Transaction;
import com.bancamovil.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    // Obtener transacción por ID
    @GetMapping("/{id}")
    public Transaction getTransactionById(@PathVariable Long id) {
        return transactionService.getTransactionById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Transacción no encontrada"));
    }

    // Obtener transacciones de un usuario por ID
    @GetMapping("/user/{userId}")
    public List<Transaction> getTransactionsByUserId(@PathVariable Long userId) {
        return transactionService.getTransactionsByUserId(userId);
    }

    // Obtener transacciones de un usuario por Email
    @GetMapping("/user/email/{email}")
    public List<Transaction> getTransactionsByUserEmail(@PathVariable String email) {
        return transactionService.getTransactionsByUserEmail(email);
    }

    // Realizar una transacción (Depósito o Retiro)
    @PostMapping("/make-transaction")
    public Transaction makeTransaction(@RequestBody TransactionRequest request) {
        if (request.getEmail() == null || request.getAmount() == null || request.getType() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email, monto y tipo de transacción son obligatorios");
        }
        return transactionService.makeTransaction(request.getEmail(), request.getAmount(), request.getType());
    }

    // Eliminar una transacción
    @DeleteMapping("/{id}")
    public void deleteTransaction(@PathVariable Long id) {
        transactionService.deleteTransaction(id);
    }

    // DTO para recibir la transacción en JSON
    public static class TransactionRequest {
        private String email;
        private BigDecimal amount;
        private String type;

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public void setAmount(BigDecimal amount) {
            this.amount = amount;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }
    }
}
