package com.homeclothing.api.service;

import com.homeclothing.api.dao.ComentarioDao;
import com.homeclothing.api.model.Comentario;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ComentarioService {

    private final ComentarioDao dao;

    public ComentarioService(ComentarioDao dao) {
        this.dao = dao;
    }

    public List<Comentario> listar() {
        return dao.allCamposComentario();
    }

    public int crear(Comentario comentario) {
        return dao.insertarComentario(comentario);
    }
}
