package com.homeclothing.api.controller;

import com.homeclothing.api.model.Categoria;
import com.homeclothing.api.service.CategoriaService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categorias")
public class CategoriaController {

    private final CategoriaService service;

    public CategoriaController(CategoriaService service) {
        this.service = service;
    }

    @GetMapping
    public List<Categoria> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody Categoria categoria) {
        return service.crear(categoria);
    }
}