package com.homeclothing.api.dao;

import com.homeclothing.api.model.Prenda;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class PrendaDao {

    private final JdbcTemplate jdbc;
    private final RowMapper<Prenda> rowMapper = (rs, rowNum) -> {
        Prenda p = new Prenda();
        p.setIdPrenda(rs.getInt("ID_PRENDA"));
        p.setIdCategoria(rs.getInt("ID_CATEGORIA"));
        p.setIdAdmin(rs.getInt("ID_ADMIN"));
        p.setNombre(rs.getString("NOMBRE"));
        p.setDescripcion(rs.getString("DESCRIPCION"));
        p.setPrecio(rs.getDouble("PRECIO"));
        p.setTalla(rs.getString("TALLA"));
        p.setColor(rs.getString("COLOR"));
        p.setStockDisponible(rs.getInt("STOCKDISPONIBLE"));
        p.setEstadoPrenda(Prenda.EstadoPrenda.valueOf(rs.getString("ESTADO_PRENDA")));
        return p;
    };

    public PrendaDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Prenda> allCamposPrenda() {
        return jdbc.query("SELECT * FROM prenda", rowMapper);
    }

    public Optional<Prenda> idPrendaCampo(int id) {
        String sql = "SELECT * FROM prenda WHERE ID_PRENDA = ?";
        return jdbc.query(sql, rowMapper, id).stream().findFirst();
    }

    public Prenda insertarPrenda(Prenda p) {
        String sql = """
                    INSERT INTO prenda (ID_CATEGORIA, ID_ADMIN, NOMBRE, DESCRIPCION, PRECIO, TALLA, COLOR, STOCKDISPONIBLE, ESTADO_PRENDA)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        jdbc.update(sql,
                p.getIdCategoria(), p.getIdAdmin(), p.getNombre(), p.getDescripcion(),
                p.getPrecio(), p.getTalla(), p.getColor(), p.getStockDisponible(), p.getEstadoPrenda().name()
        );

        int newId = jdbc.queryForObject("SELECT LAST_INSERT_ID()", Integer.class);
        p.setIdPrenda(newId);
        return p;
    }

    public int modificarStock(int id, int nuevoStock) {
        return jdbc.update("UPDATE prenda SET STOCKDISPONIBLE = ? WHERE ID_PRENDA = ?", nuevoStock, id);
    }

    public Prenda update(Prenda p) {
        String sql = """
                    UPDATE prenda
                    SET id_Categoria     = ?,
                        id_Admin         = ?,
                        nombre          = ?,
                        descripcion     = ?,
                        precio          = ?,
                        talla           = ?,
                        color           = ?,
                        stockDisponible = ?,
                        estado_Prenda    = ?
                    WHERE id_Prenda      = ?
                """;
        jdbc.update(
                sql,
                p.getIdCategoria(),
                p.getIdAdmin(),
                p.getNombre(),
                p.getDescripcion(),
                p.getPrecio(),
                p.getTalla(),
                p.getColor(),
                p.getStockDisponible(),
                p.getEstadoPrenda() != null
                        ? p.getEstadoPrenda().name()
                        : null,
                p.getIdPrenda()
        );
        return p;
    }

    public int borrarPrendaId(int id) {
        return jdbc.update("DELETE FROM prenda WHERE ID_PRENDA = ?", id);
    }
}
