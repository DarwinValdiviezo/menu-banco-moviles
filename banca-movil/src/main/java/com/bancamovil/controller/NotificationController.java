package com.bancamovil.controller;

import com.bancamovil.model.Notification;
import com.bancamovil.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    // Obtener notificación por ID
    @GetMapping("/{id}")
    public Optional<Notification> getNotificationById(@PathVariable Long id) {
        return notificationService.getNotificationById(id);
    }

    // Obtener notificaciones de un usuario por ID
    @GetMapping("/user/{userId}")
    public List<Notification> getNotificationsByUserId(@PathVariable Long userId) {
        return notificationService.getNotificationsByUserId(userId);
    }

    // Obtener notificaciones de un usuario por Email
    @GetMapping("/user/email/{email}")
    public List<Notification> getNotificationsByUserEmail(@PathVariable String email) {
        return notificationService.getNotificationsByUserEmail(email);
    }

    // Crear una nueva notificación
    @PostMapping("/create")
    public Notification createNotification(@RequestParam String email, @RequestParam String message) {
        return notificationService.createNotification(email, message);
    }

    // Eliminar una notificación
    @DeleteMapping("/{id}")
    public String deleteNotification(@PathVariable Long id) {
        notificationService.deleteNotification(id);
        return "Notificación eliminada correctamente";
    }
}
