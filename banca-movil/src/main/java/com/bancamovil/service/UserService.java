package com.bancamovil.service;

import com.bancamovil.model.User;
import com.bancamovil.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // Registrar un nuevo usuario
    public User registerUser(User user) {
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new RuntimeException("El usuario ya existe");
        }
        return userRepository.save(user);
    }

    // Validar usuario (para login sin BCrypt)
    public Optional<User> validateUser(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent() && userOpt.get().getPassword().equals(password)) {
            return userOpt;
        }
        return Optional.empty();
    }

    // Obtener usuario por ID
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }

    // Obtener usuario por Email
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    // Obtener todos los usuarios
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    // Guardar o actualizar usuario
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    // Eliminar usuario
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    // Actualizar saldo del usuario
    public void updateSaldo(String email, BigDecimal amount) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setSaldo(user.getSaldo().add(amount)); // Sumar saldo
            userRepository.save(user);
        } else {
            throw new RuntimeException("Usuario no encontrado");
        }
    }
}
