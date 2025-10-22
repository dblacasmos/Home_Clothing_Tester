package com.homeclothing.api.controller;

import com.homeclothing.api.model.DetalleCompra;
import com.homeclothing.api.service.DetalleCompraService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/detallecompras")
public class DetalleCompraController {

    private final DetalleCompraService service;

    public DetalleCompraController(DetalleCompraService service) {
        this.service = service;
    }

    @GetMapping
    public List<DetalleCompra> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody DetalleCompra detalle) {
        return service.crear(detalle);
    }
}