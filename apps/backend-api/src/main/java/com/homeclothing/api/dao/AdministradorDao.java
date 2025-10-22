package com.homeclothing.api.dao;

import com.homeclothing.api.model.Administrador;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class AdministradorDao {

    private final JdbcTemplate jdbc;

    public AdministradorDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Administrador> allCamposAdmin() throws DataAccessException {
        String sql = "SELECT * FROM administrador";
        return jdbc.query(sql, new BeanPropertyRowMapper<>());
    }

    public int insertarAdmin(Administrador admin) {
        String sql = "INSERT INTO administrador (NOMBRE_ADMIN, CORREO_ADMIN, PASSWORD, ROL) VALUES (?, ?, ?, ?)";
        return jdbc.update(sql, admin.getNombreAdmin(), admin.getCorreoAdmin(), admin.getPassword(), admin.getRol());
    }
}