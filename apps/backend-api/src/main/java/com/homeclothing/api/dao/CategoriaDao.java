package com.homeclothing.api.dao;

import com.homeclothing.api.model.Categoria;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CategoriaDao {

    private final JdbcTemplate jdbc;

    public CategoriaDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Categoria> allCamposCategoria() {
        String sql = "SELECT * FROM categoria";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(Categoria.class));
    }

    public int insertarCategoria(Categoria categoria) {
        String sql = "INSERT INTO categoria (NOMBRE_CATEGORIA, DESCRIPCION) VALUES (?, ?)";
        return jdbc.update(sql,
                categoria.getNombreCategoria(),
                categoria.getDescripcion());
    }
}