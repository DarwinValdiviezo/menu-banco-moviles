package com.bancamovil.service;

import com.bancamovil.model.Notification;
import com.bancamovil.model.User;
import com.bancamovil.repository.NotificationRepository;
import com.bancamovil.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private UserRepository userRepository;

    // Obtener una notificación por ID
    public Optional<Notification> getNotificationById(Long id) {
        return notificationRepository.findById(id);
    }

    // Obtener todas las notificaciones de un usuario por ID
    public List<Notification> getNotificationsByUserId(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        return userOpt.map(notificationRepository::findByUser).orElse(List.of()); // Evita null
    }

    // Obtener todas las notificaciones de un usuario por Email
    public List<Notification> getNotificationsByUserEmail(String email) {
        return notificationRepository.findByUser_Email(email); // ✅ Corrección
    }

    // Crear una nueva notificación
    public Notification createNotification(String email, String message) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            Notification notification = new Notification(message, user); // ✅ Ahora usa el constructor correcto
            return notificationRepository.save(notification);
        } else {
            throw new IllegalArgumentException("Usuario con email " + email + " no encontrado");
        }
    }

    // Eliminar una notificación por ID
    public void deleteNotification(Long id) {
        notificationRepository.deleteById(id);
    }
}
