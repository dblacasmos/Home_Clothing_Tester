package com.homeclothing.api.controller;

import com.homeclothing.api.model.Sistema_RA;
import com.homeclothing.api.service.Sistema_RAService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/sistema_ra")
@CrossOrigin(origins = "*") // permite que el frontend acceda
public class Sistema_RAController {

    @Autowired
    private Sistema_RAService sistema_RAService;

    // POST → Registrar nueva prueba virtual
    @PostMapping
    public ResponseEntity<Map<String, String>> registrar(@RequestBody Sistema_RA prueba) {
        prueba.setFecha(LocalDateTime.now());
        sistema_RAService.crear(prueba);

        Map<String, String> resp = new HashMap<>();
        resp.put("item", "Denim Jacket");
        resp.put("resultado", "Simulación guardada correctamente");

        return ResponseEntity.ok(resp);
    }

    // GET → Listar todas las pruebas registradas
    @GetMapping
    public ResponseEntity<List<Sistema_RA>> listar() {
        List<Sistema_RA> lista = sistema_RAService.listar();
        return ResponseEntity.ok(lista);
    }
}