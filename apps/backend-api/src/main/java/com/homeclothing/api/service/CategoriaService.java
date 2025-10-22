package com.homeclothing.api.service;

import com.homeclothing.api.dao.CategoriaDao;
import com.homeclothing.api.model.Categoria;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {

    private final CategoriaDao dao;

    public CategoriaService(CategoriaDao dao) {
        this.dao = dao;
    }

    public List<Categoria> listar() {
        return dao.allCamposCategoria();
    }

    public int crear(Categoria categoria) {
        return dao.insertarCategoria(categoria);
    }
}