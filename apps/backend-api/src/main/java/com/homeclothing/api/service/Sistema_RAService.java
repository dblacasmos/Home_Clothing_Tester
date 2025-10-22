package com.homeclothing.api.service;

import com.homeclothing.api.dao.Sistema_RADao;
import com.homeclothing.api.model.Sistema_RA;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class Sistema_RAService {

    private final Sistema_RADao dao;

    public Sistema_RAService(Sistema_RADao dao) {
        this.dao = dao;
    }

    public List<Sistema_RA> listar() {
        return dao.allCamposSistema_RADao();
    }

    public Sistema_RA crear(Sistema_RA sistema) {
        sistema.setFecha(LocalDateTime.now());
        dao.insertarSistemaRA(sistema);
        return sistema;
    }
}