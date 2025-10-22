package com.homeclothing.api.service;

import com.homeclothing.api.dao.PrendaDao;
import com.homeclothing.api.model.Prenda;
import jakarta.validation.Valid;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional

public class PrendaService {

    private final PrendaDao repo;
    private final JdbcTemplate jdbc;

    public PrendaService(PrendaDao repo, JdbcTemplate jdbc) {
        this.repo = repo;
        this.jdbc = jdbc;
    }

    public List<Prenda> listarTodas() {
        return repo.allCamposPrenda();
    }

    public Optional<Prenda> buscarPorId(int id) {
        return repo.idPrendaCampo(id);
    }

    public Prenda crear(Prenda p) {
        if (!categoriaExiste(p.getIdCategoria())) {
            throw new IllegalArgumentException("ID_CATEGORIA no válido: " + p.getIdCategoria());
        }
        if (!adminExiste(p.getIdAdmin())) {
            throw new IllegalArgumentException("ID_ADMIN no válido: " + p.getIdAdmin());
        }
        return repo.insertarPrenda(p);
    }

    public int actualizarStock(int id, int nuevoStock) {
        return repo.modificarStock(id, nuevoStock);
    }

    public int eliminar(int id) {
        return repo.borrarPrendaId(id);
    }

    // --- Métodos de validación ---
    private boolean categoriaExiste(int idCategoria) {
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM categoria WHERE ID_CATEGORIA = ?",
                Integer.class,
                idCategoria
        );
        return count != null && count > 0;
    }

    private boolean adminExiste(int idAdmin) {
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM administrador WHERE ID_ADMIN = ?",
                Integer.class,
                idAdmin
        );
        return count != null && count > 0;
    }

    public Prenda actualizar(@Valid Prenda p) {
        return repo.update(p);
    }
}