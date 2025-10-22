package com.homeclothing.api.controller;

import com.homeclothing.api.model.MetodoPago;
import com.homeclothing.api.service.MetodoPagoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/metodospago")
public class MetodoPagoController {

    private final MetodoPagoService service;

    public MetodoPagoController(MetodoPagoService service) {
        this.service = service;
    }

    @GetMapping
    public List<MetodoPago> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody MetodoPago metodo) {
        return service.crear(metodo);
    }
}
