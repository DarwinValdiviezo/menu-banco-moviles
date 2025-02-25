package com.bancamovil.controller;

import com.bancamovil.model.User;
import com.bancamovil.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // Obtener usuario por ID
    @GetMapping("/{id}")
    public Optional<User> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    // Obtener usuario por Email
    @GetMapping("/email/{email}")
    public Optional<User> getUserByEmail(@PathVariable String email) {
        return userService.getUserByEmail(email);
    }

    // Obtener todos los usuarios (opcional si lo necesitas)
    @GetMapping
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    // Registrar usuario (POST sí funcionaba)
    @PostMapping
    public User registerUser(@RequestBody User user) {
        return userService.registerUser(user);
    }

    // Eliminar usuario por ID
    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
    }
}
