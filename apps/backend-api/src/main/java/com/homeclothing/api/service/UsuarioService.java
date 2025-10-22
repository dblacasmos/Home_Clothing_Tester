package com.homeclothing.api.service;

import com.homeclothing.api.dao.UsuarioDao;
import com.homeclothing.api.model.Usuario;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioService {

    private final UsuarioDao dao;

    public UsuarioService(UsuarioDao dao) {
        this.dao = dao;
    }

    public List<Usuario> listar() {
        return dao.allCamposUsuario();
    }

    public int crear(Usuario usuario) {
        return dao.insertarUsuario(usuario);
    }
}