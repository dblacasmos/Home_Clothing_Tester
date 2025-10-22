package com.homeclothing.api.dao;

import com.homeclothing.api.model.Sistema_RA;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class Sistema_RADao {

    private final JdbcTemplate jdbc;

    public Sistema_RADao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Sistema_RA> allCamposSistema_RADao() {
        String sql = "SELECT * FROM sistema_ra";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(Sistema_RA.class));
    }

    public int insertarSistemaRA(Sistema_RA sistema) {
        String sql = "INSERT INTO sistema_ra (id_Usuario, id_Prenda, fecha, resultado) VALUES (?, ?, ?, ?)";
        return jdbc.update(sql,
                sistema.getId_Usuario(),
                sistema.getId_Prenda(),
                sistema.getFecha(),
                sistema.getResultado());
    }
}