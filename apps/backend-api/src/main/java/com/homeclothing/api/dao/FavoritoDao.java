package com.homeclothing.api.dao;

import com.homeclothing.api.model.Favorito;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FavoritoDao {

    private final JdbcTemplate jdbc;

    public FavoritoDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Favorito> allCamposFavorito() {
        String sql = "SELECT * FROM favorito";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(Favorito.class));
    }

    public int insertarFavorito(Favorito favorito) {
        String sql = "INSERT INTO favorito (ID_USUARIO, ID_PRENDA, FECHA_ADD) VALUES (?, ?, ?)";
        return jdbc.update(sql,
                favorito.getIdUsuario(),
                favorito.getIdPrenda(),
                favorito.getFechaAdd());
    }
}