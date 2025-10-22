package com.homeclothing.api.service;

import com.homeclothing.api.dao.DetalleCompraDao;
import com.homeclothing.api.model.DetalleCompra;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DetalleCompraService {

    private final DetalleCompraDao dao;

    public DetalleCompraService(DetalleCompraDao dao) {
        this.dao = dao;
    }

    public List<DetalleCompra> listar() {
        return dao.allCamposDetalle();
    }

    public int crear(DetalleCompra detalle) {
        return dao.insertarDetalle(detalle);
    }
}
