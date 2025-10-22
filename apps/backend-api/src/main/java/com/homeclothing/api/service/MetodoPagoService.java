package com.homeclothing.api.service;

import com.homeclothing.api.dao.MetodoPagoDao;
import com.homeclothing.api.model.MetodoPago;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MetodoPagoService {

    private final MetodoPagoDao dao;

    public MetodoPagoService(MetodoPagoDao dao) {
        this.dao = dao;
    }

    public List<MetodoPago> listar() {
        return dao.allCamposMetodoPago();
    }

    public int crear(MetodoPago metodo) {
        return dao.insertarMetodoPago(metodo);
    }
}