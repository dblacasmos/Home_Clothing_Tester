package com.homeclothing.api.controller;

import com.homeclothing.api.model.Compra;
import com.homeclothing.api.service.CompraService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/compras")
public class CompraController {

    private final CompraService service;

    public CompraController(CompraService service) {
        this.service = service;
    }

    @GetMapping
    public List<Compra> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody Compra compra) {
        return service.crear(compra);
    }
}
