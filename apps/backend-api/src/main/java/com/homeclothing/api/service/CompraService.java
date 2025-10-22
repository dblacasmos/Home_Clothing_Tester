package com.homeclothing.api.service;

import com.homeclothing.api.dao.CompraDao;
import com.homeclothing.api.model.Compra;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CompraService {

    private final CompraDao dao;

    public CompraService(CompraDao dao) {
        this.dao = dao;
    }

    public List<Compra> listar() {
        return dao.allCamposCompra();
    }

    public int crear(Compra compra) {
        return dao.insertarCompra(compra);
    }
}