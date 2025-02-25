package com.bancamovil.service;

import com.bancamovil.model.User;
import com.bancamovil.repository.UserRepository;
import io.qameta.allure.*;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@Slf4j
@ExtendWith(MockitoExtension.class)
@Epic("Gestión de Usuarios")
@Feature("Servicio de Usuarios")
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    @Step("Configurando datos de prueba")
    void setUp() {
        log.info("Configurando datos de prueba...");
        user = new User();
        user.setId(1L);
        user.setEmail("test@example.com");
        user.setPassword("password");
        log.info("Usuario de prueba configurado: {} con contraseña {}", user.getEmail(), user.getPassword());
    }

    @Test
    @Story("Registrar un usuario exitosamente")
    @Description("Verifica que un usuario nuevo pueda registrarse correctamente")
    @Severity(SeverityLevel.CRITICAL)
    void shouldRegisterUserSuccessfully() {
        log.info("Iniciando prueba: shouldRegisterUserSuccessfully");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.empty());
        when(userRepository.save(user)).thenReturn(user);

        log.info("Intentando registrar un nuevo usuario con email: {}", user.getEmail());
        User savedUser = userService.registerUser(user);

        assertNotNull(savedUser);
        assertEquals("test@example.com", savedUser.getEmail());

        log.info("Usuario registrado exitosamente: {}", savedUser.getEmail());
    }

    @Test
    @Story("Intentar registrar un usuario ya existente")
    @Description("Verifica que el sistema no permita registrar un usuario si el email ya está registrado")
    @Severity(SeverityLevel.BLOCKER)
    void shouldNotRegisterUserIfAlreadyExists() {
        log.info("Iniciando prueba: shouldNotRegisterUserIfAlreadyExists");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));

        log.warn("Intentando registrar un usuario ya existente...");
        Exception exception = assertThrows(RuntimeException.class, () -> userService.registerUser(user));

        assertEquals("El usuario ya existe", exception.getMessage());

        log.error("Error esperado: {}", exception.getMessage());
    }

    @Test
    @Story("Obtener usuario por email")
    @Description("Verifica que el sistema pueda buscar correctamente un usuario existente por su email")
    @Severity(SeverityLevel.NORMAL)
    void shouldGetUserByEmail() {
        log.info("Iniciando prueba: shouldGetUserByEmail");

        when(userRepository.findByEmail(user.getEmail())).thenReturn(Optional.of(user));

        log.info("Buscando usuario con email: {}", user.getEmail());
        Optional<User> foundUser = userService.getUserByEmail("test@example.com");

        assertTrue(foundUser.isPresent());
        assertEquals("test@example.com", foundUser.get().getEmail());

        log.info("Usuario encontrado: {}", foundUser.get().getEmail());
    }
}
