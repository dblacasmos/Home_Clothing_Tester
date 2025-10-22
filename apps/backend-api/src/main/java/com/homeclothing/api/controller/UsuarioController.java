package com.homeclothing.api.controller;

import com.homeclothing.api.model.Usuario;
import com.homeclothing.api.service.UsuarioService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/usuarios")
public class UsuarioController {

    private final UsuarioService service;

    public UsuarioController(UsuarioService service) {
        this.service = service;
    }

    @GetMapping
    public List<Usuario> listar() {
        return service.listar();
    }

    @PostMapping
    public int crear(@RequestBody Usuario usuario) {
        return service.crear(usuario);
    }
}
