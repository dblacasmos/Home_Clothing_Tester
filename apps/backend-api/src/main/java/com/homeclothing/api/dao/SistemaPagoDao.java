package com.homeclothing.api.dao;

import com.homeclothing.api.model.SistemaPago;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class SistemaPagoDao {

    private final JdbcTemplate jdbc;

    public SistemaPagoDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<SistemaPago> allCamposSistemaPago() {
        String sql = "SELECT * FROM sistemapago";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(SistemaPago.class));
    }

    public int insertarSistemaPago(SistemaPago sistema) {
        String sql = "INSERT INTO sistemapago (FECHA_TRANSACCION, ESTADO_TRANSACCION) VALUES (?, ?)";
        return jdbc.update(sql,
                sistema.getFechaTransaccion(),
                sistema.getEstadoTransaccion().toString());
    }
}