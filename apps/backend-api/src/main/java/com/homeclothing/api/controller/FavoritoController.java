package com.homeclothing.api.controller;

import com.homeclothing.api.model.Favorito;
import com.homeclothing.api.service.FavoritoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favoritos")
public class FavoritoController {

    private final FavoritoService service;

    public FavoritoController(FavoritoService service) {
        this.service = service;
    }

    @GetMapping
    public List<Favorito> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody Favorito favorito) {
        return service.crear(favorito);
    }
}