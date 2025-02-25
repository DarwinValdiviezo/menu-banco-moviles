package com.bancamovil.service;

import com.bancamovil.model.Payment;
import com.bancamovil.model.User;
import com.bancamovil.repository.PaymentRepository;
import com.bancamovil.repository.UserRepository;
import io.qameta.allure.*;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@Slf4j
@ExtendWith(MockitoExtension.class)
@Epic("Gestión de Pagos")
@Feature("Servicio de Pagos")
class PaymentServiceTest {

    @Mock
    private PaymentRepository paymentRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private PaymentService paymentService;

    private User user;

    @BeforeEach
    @Step("Configurando datos de prueba")
    void setUp() {
        log.info("Configurando datos de prueba...");
        user = new User();
        user.setId(1L);
        user.setEmail("test@example.com");
        user.setSaldo(new BigDecimal("100.00"));
        log.info("Usuario de prueba configurado: {} con saldo inicial {}", user.getEmail(), user.getSaldo());
    }

    @Test
    @Story("Realizar un pago exitosamente")
    @Description("Verifica que un usuario pueda realizar un pago correctamente cuando tiene saldo suficiente")
    @Severity(SeverityLevel.CRITICAL)
    void shouldMakePaymentSuccessfully() {
        log.info("Iniciando prueba: shouldMakePaymentSuccessfully");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(paymentRepository.save(any(Payment.class))).thenAnswer(invocation -> invocation.getArgument(0));

        log.info("Realizando pago de 50.00 para el usuario {}", user.getEmail());
        Payment result = paymentService.makePayment("test@example.com", new BigDecimal("50.00"));

        assertNotNull(result);
        assertEquals(new BigDecimal("50.00"), result.getAmount());
        assertEquals(new BigDecimal("50.00"), user.getSaldo());

        log.info("Pago realizado correctamente. Nuevo saldo: {}", user.getSaldo());
    }

    @Test
    @Story("Intentar pago con usuario no existente")
    @Description("Verifica que el sistema devuelva un error cuando el usuario no existe en la base de datos")
    @Severity(SeverityLevel.BLOCKER)
    void shouldThrowExceptionWhenUserNotFound() {
        log.info("Iniciando prueba: shouldThrowExceptionWhenUserNotFound");

        when(userRepository.findByEmail("test@example.com")).thenReturn(Optional.empty());

        log.warn("Intentando realizar pago para usuario no existente...");
        ResponseStatusException exception = assertThrows(ResponseStatusException.class,
                () -> paymentService.makePayment("test@example.com", new BigDecimal("50.00")));

        assertEquals("Usuario no encontrado", exception.getReason());

        log.error("Error esperado: {}", exception.getReason());
    }

    @Test
    @Story("Intentar pago con saldo insuficiente")
    @Description("Verifica que el sistema no permita pagos si el usuario tiene saldo insuficiente")
    @Severity(SeverityLevel.CRITICAL)
    void shouldThrowExceptionWhenInsufficientFunds() {
        log.info("Iniciando prueba: shouldThrowExceptionWhenInsufficientFunds");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));

        log.warn("Intentando realizar pago de 200.00 con saldo insuficiente...");
        ResponseStatusException exception = assertThrows(ResponseStatusException.class,
                () -> paymentService.makePayment("test@example.com", new BigDecimal("200.00")));

        assertEquals("Saldo insuficiente", exception.getReason());

        log.error("Error esperado: {}", exception.getReason());
    }
}
