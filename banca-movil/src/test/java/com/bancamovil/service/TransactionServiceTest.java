package com.bancamovil.service;

import com.bancamovil.model.Transaction;
import com.bancamovil.model.User;
import com.bancamovil.repository.TransactionRepository;
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
@Epic("Gestión de Transacciones")
@Feature("Servicio de Transacciones")
class TransactionServiceTest {

    @Mock
    private TransactionRepository transactionRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private TransactionService transactionService;

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
    @Story("Realizar un depósito exitosamente")
    @Description("Verifica que un usuario pueda realizar un depósito correctamente")
    @Severity(SeverityLevel.CRITICAL)
    void shouldMakeDepositSuccessfully() {
        log.info("Iniciando prueba: shouldMakeDepositSuccessfully");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(transactionRepository.save(any(Transaction.class))).thenAnswer(invocation -> invocation.getArgument(0));

        log.info("Realizando depósito de 50.00 para el usuario {}", user.getEmail());
        Transaction result = transactionService.makeTransaction("test@example.com", new BigDecimal("50.00"), "DEPOSIT");

        assertNotNull(result);
        assertEquals(new BigDecimal("150.00"), user.getSaldo());

        log.info("Depósito realizado correctamente. Nuevo saldo: {}", user.getSaldo());
    }

    @Test
    @Story("Realizar un retiro exitosamente")
    @Description("Verifica que un usuario pueda realizar un retiro correctamente si tiene saldo suficiente")
    @Severity(SeverityLevel.CRITICAL)
    void shouldMakeWithdrawalSuccessfully() {
        log.info("Iniciando prueba: shouldMakeWithdrawalSuccessfully");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));
        when(transactionRepository.save(any(Transaction.class))).thenAnswer(invocation -> invocation.getArgument(0));

        log.info("Realizando retiro de 50.00 para el usuario {}", user.getEmail());
        Transaction result = transactionService.makeTransaction("test@example.com", new BigDecimal("50.00"), "WITHDRAWAL");

        assertNotNull(result);
        assertEquals(new BigDecimal("50.00"), user.getSaldo());

        log.info("Retiro realizado correctamente. Nuevo saldo: {}", user.getSaldo());
    }

    @Test
    @Story("Intentar realizar una transacción con tipo inválido")
    @Description("Verifica que el sistema no permita realizar transacciones con un tipo inválido")
    @Severity(SeverityLevel.BLOCKER)
    void shouldThrowExceptionForInvalidTransactionType() {
        log.info("Iniciando prueba: shouldThrowExceptionForInvalidTransactionType");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));

        log.warn("Intentando realizar transacción con tipo inválido...");
        ResponseStatusException exception = assertThrows(ResponseStatusException.class,
                () -> transactionService.makeTransaction("test@example.com", new BigDecimal("50.00"), "INVALID"));

        assertEquals("Tipo de transacción inválido (DEPOSIT o WITHDRAWAL)", exception.getReason());

        log.error("Error esperado: {}", exception.getReason());
    }
}
