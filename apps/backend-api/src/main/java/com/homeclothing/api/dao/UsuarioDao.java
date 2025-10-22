package com.homeclothing.api.dao;

import com.homeclothing.api.model.Usuario;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class UsuarioDao {

    private final JdbcTemplate jdbc;

    public UsuarioDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Usuario> allCamposUsuario() {
        String sql = "SELECT * FROM usuario";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(Usuario.class));
    }

    public int insertarUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuario (ID_ADMIN, NOMBRE_USUARIO, CORREO_USUARIO, PASSWORD, ESTADO) VALUES (?, ?, ?, ?, ?)";
        return jdbc.update(sql,
                usuario.getIdAdmin(),
                usuario.getNombreUsuario(),
                usuario.getCorreoUsuario(),
                usuario.getPassword(),
                usuario.getEstado().toString());
    }
}