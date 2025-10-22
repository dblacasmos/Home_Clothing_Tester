package com.homeclothing.api.dao;

import com.homeclothing.api.model.MetodoPago;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MetodoPagoDao {

    private final JdbcTemplate jdbc;

    public MetodoPagoDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<MetodoPago> allCamposMetodoPago() {
        String sql = "SELECT * FROM metodopago";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(MetodoPago.class));
    }

    public int insertarMetodoPago(MetodoPago metodo) {
        String sql = "INSERT INTO metodopago (FORMA_PAGO, DETALLES) VALUES (?, ?)";
        return jdbc.update(sql,
                metodo.getFormaPago(),
                metodo.getDetalles());
    }
}