package com.homeclothing.api.service;

import com.homeclothing.api.dao.SistemaPagoDao;
import com.homeclothing.api.model.SistemaPago;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SistemaPagoService {

    private final SistemaPagoDao dao;

    public SistemaPagoService(SistemaPagoDao dao) {
        this.dao = dao;
    }

    public List<SistemaPago> listar() {
        return dao.allCamposSistemaPago();
    }

    public int crear(SistemaPago sistema) {
        return dao.insertarSistemaPago(sistema);
    }
}