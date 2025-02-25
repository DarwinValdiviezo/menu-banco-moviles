package com.bancamovil.controller;

import com.bancamovil.model.Payment;
import com.bancamovil.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    // Obtener pago por ID
    @GetMapping("/{id}")
    public Payment getPaymentById(@PathVariable Long id) {
        return paymentService.getPaymentById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Pago no encontrado"));
    }

    // Obtener pagos de un usuario por ID
    @GetMapping("/user/{userId}")
    public List<Payment> getPaymentsByUserId(@PathVariable Long userId) {
        return paymentService.getPaymentsByUserId(userId);
    }

    // Obtener pagos de un usuario por Email
    @GetMapping("/user/email/{email}")
    public List<Payment> getPaymentsByUserEmail(@PathVariable String email) {
        return paymentService.getPaymentsByUserEmail(email);
    }

    // Realizar un pago
    @PostMapping("/make-payment")
    public Payment makePayment(@RequestBody PaymentRequest request) {
        if (request.getEmail() == null || request.getAmount() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email y monto son obligatorios");
        }
        return paymentService.makePayment(request.getEmail(), request.getAmount());
    }

    // Eliminar un pago
    @DeleteMapping("/{id}")
    public void deletePayment(@PathVariable Long id) {
        paymentService.deletePayment(id);
    }

    // DTO para recibir el pago en JSON
    public static class PaymentRequest {
        private String email;
        private BigDecimal amount;

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
    }
}
