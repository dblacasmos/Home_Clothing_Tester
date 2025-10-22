package com.homeclothing.api.controller;

import com.homeclothing.api.model.SistemaPago;
import com.homeclothing.api.service.SistemaPagoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sistemaspago")
public class SistemaPagoController {

    private final SistemaPagoService service;

    public SistemaPagoController(SistemaPagoService service) {
        this.service = service;
    }

    @GetMapping
    public List<SistemaPago> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody SistemaPago sistema) {
        return service.crear(sistema);
    }
}