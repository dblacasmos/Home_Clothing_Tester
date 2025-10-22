package com.homeclothing.api.controller;

import com.homeclothing.api.model.Prenda;
import com.homeclothing.api.service.PrendaService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/prendas")
public class PrendaController {

    private final PrendaService service;

    public PrendaController(PrendaService service) {
        this.service = service;
    }

    @GetMapping
    public List<Prenda> listar() {
        return service.listarTodas();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Prenda> porId(@PathVariable int id) {
        return service.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Prenda> crear(@Valid @RequestBody Prenda p) {
        return ResponseEntity.status(HttpStatus.CREATED).body(service.crear(p));
    }

    @PatchMapping("/{id}/stock")
    public ResponseEntity<?> actualizarStock(@PathVariable int id, @RequestParam int nuevoStock) {
        int actualizadas = service.actualizarStock(id, nuevoStock);
        return actualizadas > 0 ? ResponseEntity.ok().build() : ResponseEntity.notFound().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Prenda> actualizar(@PathVariable int id, @Valid @RequestBody Prenda p) {
        if (service.buscarPorId(id).isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        p.setIdPrenda(id);
        Prenda actualizado = service.actualizar(p);
        return ResponseEntity.ok(actualizado);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> eliminar(@PathVariable int id) {
        int filasAfectadas = service.eliminar(id);
        if (filasAfectadas > 0) {
            return ResponseEntity.noContent().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}