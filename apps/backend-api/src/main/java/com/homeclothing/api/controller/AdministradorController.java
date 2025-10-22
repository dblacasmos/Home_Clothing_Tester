package com.homeclothing.api.controller;

import com.homeclothing.api.model.Administrador;
import com.homeclothing.api.service.AdministradorService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/administradores")
public class AdministradorController {

    private final AdministradorService service;

    public AdministradorController(AdministradorService service) {
        this.service = service;
    }

    @GetMapping
    public List<Administrador> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody Administrador admin) {
        return service.crear(admin);
    }
}