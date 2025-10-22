package com.homeclothing.api.service;

import com.homeclothing.api.dao.AdministradorDao;
import com.homeclothing.api.model.Administrador;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdministradorService {

    private final AdministradorDao dao;

    public AdministradorService(AdministradorDao dao) {
        this.dao = dao;
    }

    public List<Administrador> listar() {
        return dao.allCamposAdmin();
    }

    public int crear(Administrador admin) {
        return dao.insertarAdmin(admin);
    }
}