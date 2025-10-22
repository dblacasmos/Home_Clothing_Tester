package com.homeclothing.api.dao;

import com.homeclothing.api.model.Comentario;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ComentarioDao {

    private final JdbcTemplate jdbc;

    public ComentarioDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Comentario> allCamposComentario() {
        String sql = "SELECT * FROM comentario";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(Comentario.class));
    }

    public int insertarComentario(Comentario comentario) {
        String sql = "INSERT INTO comentario (ID_USUARIO, ID_PRENDA, CONTENIDO, CALIFICACION, FECHA_COMENTARIO) VALUES (?, ?, ?, ?, ?)";
        return jdbc.update(sql,
                comentario.getIdUsuario(),
                comentario.getIdPrenda(),
                comentario.getContenido(),
                comentario.getCalificacion(),
                comentario.getFechaComentario());
    }
}