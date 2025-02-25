package com.bancamovil.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.bancamovil.model.Payment;
import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByUser_Email(String email); // ✅ Buscar pagos por email del usuario relacionado
}
