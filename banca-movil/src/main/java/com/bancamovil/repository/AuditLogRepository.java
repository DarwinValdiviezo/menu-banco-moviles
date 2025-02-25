package com.bancamovil.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.bancamovil.model.AuditLog;
import java.util.List;

public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {
    List<AuditLog> findByUserEmail(String userEmail);
}
