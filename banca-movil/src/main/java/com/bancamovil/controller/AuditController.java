package com.bancamovil.controller;

import com.bancamovil.model.AuditLog;
import com.bancamovil.service.AuditLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/audit")
public class AuditController {

    @Autowired
    private AuditLogService auditLogService;

    // Obtener todos los logs de auditoría
    @GetMapping
    public List<AuditLog> getAllAuditLogs() {
        return auditLogService.getAllAuditLogs();
    }
}
