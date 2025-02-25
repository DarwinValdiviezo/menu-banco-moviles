package com.bancamovil.service;

import com.bancamovil.model.AuditLog;
import com.bancamovil.repository.AuditLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AuditLogService {

    @Autowired
    private AuditLogRepository auditLogRepository;

    // Guardar un log de auditoría
    public void logAction(String action, String userEmail) {
        AuditLog auditLog = new AuditLog();
        auditLog.setAction(action);
        auditLog.setUserEmail(userEmail);
        auditLogRepository.save(auditLog);
    }

    // Obtener todos los logs de auditoría
    public List<AuditLog> getAllAuditLogs() {
        return auditLogRepository.findAll();
    }
}
