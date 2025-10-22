package com.homeclothing.api.controller;

import com.homeclothing.api.model.Comentario;
import com.homeclothing.api.service.ComentarioService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/comentarios")
public class ComentarioController {

    private final ComentarioService service;

    public ComentarioController(ComentarioService service) {
        this.service = service;
    }

    @GetMapping
    public List<Comentario> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody Comentario comentario) {
        return service.crear(comentario);
    }
}
