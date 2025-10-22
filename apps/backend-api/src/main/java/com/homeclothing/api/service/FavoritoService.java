package com.homeclothing.api.service;

import com.homeclothing.api.dao.FavoritoDao;
import com.homeclothing.api.model.Favorito;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FavoritoService {

    private final FavoritoDao dao;

    public FavoritoService(FavoritoDao dao) {
        this.dao = dao;
    }

    public List<Favorito> listar() {
        return dao.allCamposFavorito();
    }

    public int crear(Favorito favorito) {
        return dao.insertarFavorito(favorito);
    }
}
