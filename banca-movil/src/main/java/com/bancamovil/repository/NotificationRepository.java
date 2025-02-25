package com.bancamovil.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.bancamovil.model.Notification;
import com.bancamovil.model.User;
import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByUser(User user); // ✅ Buscar notificaciones por usuario (corregido)
    List<Notification> findByUser_Email(String email); // ✅ Buscar por email del usuario
}
