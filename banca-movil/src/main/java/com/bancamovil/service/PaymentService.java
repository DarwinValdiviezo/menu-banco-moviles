package com.bancamovil.service;

import com.bancamovil.model.Payment;
import com.bancamovil.model.User;
import com.bancamovil.repository.PaymentRepository;
import com.bancamovil.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private UserRepository userRepository;

    // Obtener pago por ID
    public Optional<Payment> getPaymentById(Long id) {
        return paymentRepository.findById(id);
    }

    // Obtener todos los pagos de un usuario por ID
    public List<Payment> getPaymentsByUserId(Long userId) {
        return paymentRepository.findByUser_Email(userId.toString());
    }

    // Obtener pagos de un usuario por Email
    public List<Payment> getPaymentsByUserEmail(String email) {
        return paymentRepository.findByUser_Email(email);
    }

    // Realizar un pago y actualizar saldo del usuario
    public Payment makePayment(String email, BigDecimal amount) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();

            // Validar saldo suficiente
            if (user.getSaldo().compareTo(amount) < 0) {
                throw new ResponseStatusException(org.springframework.http.HttpStatus.BAD_REQUEST, "Saldo insuficiente");
            }

            // Crear el pago
            Payment payment = new Payment();
            payment.setAmount(amount);
            payment.setUser(user);
            Payment savedPayment = paymentRepository.save(payment);

            // Restar saldo del usuario
            user.setSaldo(user.getSaldo().subtract(amount));
            userRepository.save(user);

            return savedPayment;
        } else {
            throw new ResponseStatusException(org.springframework.http.HttpStatus.NOT_FOUND, "Usuario no encontrado");
        }
    }

    // Eliminar un pago por ID
    public void deletePayment(Long id) {
        paymentRepository.deleteById(id);
    }
}
