package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.InformeEntidad;
import pe.gob.transparencia.interfaces.InformeInterface;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InformeModelo implements InformeInterface {

    @Override
    public InformeEntidad buscarPorId(int id) {
        InformeEntidad informe = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Informe WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                informe = new InformeEntidad();
                informe.setId(rs.getInt("id"));
                informe.setTitulo(rs.getString("titulo"));
                informe.setTipo(rs.getString("tipo"));
                informe.setAnio(rs.getInt("anio"));
                informe.setFechaGeneracion(rs.getDate("fechaGeneracion"));
                informe.setNivelGobierno(rs.getString("nivelGobierno"));
                informe.setDescripcion(rs.getString("descripcion"));
                informe.setEstado(rs.getString("estado"));
                informe.setRutaArchivo(rs.getString("rutaArchivo"));
                informe.setDatosJson(rs.getString("datosJson"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return informe;
    }

    @Override
    public List<InformeEntidad> listarInformes() {
        List<InformeEntidad> informes = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Informe ORDER BY fechaGeneracion DESC";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                InformeEntidad informe = new InformeEntidad();
                informe.setId(rs.getInt("id"));
                informe.setTitulo(rs.getString("titulo"));
                informe.setTipo(rs.getString("tipo"));
                informe.setAnio(rs.getInt("anio"));
                informe.setFechaGeneracion(rs.getDate("fechaGeneracion"));
                informe.setNivelGobierno(rs.getString("nivelGobierno"));
                informe.setDescripcion(rs.getString("descripcion"));
                informe.setEstado(rs.getString("estado"));
                informe.setRutaArchivo(rs.getString("rutaArchivo"));
                informe.setDatosJson(rs.getString("datosJson"));
                informes.add(informe);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return informes;
    }

    @Override
    public List<InformeEntidad> listarInformesPorTipo(String tipo) {
        List<InformeEntidad> informes = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Informe WHERE tipo = ? ORDER BY fechaGeneracion DESC";
            ps = cn.prepareStatement(sql);
            ps.setString(1, tipo);
            rs = ps.executeQuery();

            while (rs.next()) {
                InformeEntidad informe = new InformeEntidad();
                informe.setId(rs.getInt("id"));
                informe.setTitulo(rs.getString("titulo"));
                informe.setTipo(rs.getString("tipo"));
                informe.setAnio(rs.getInt("anio"));
                informe.setFechaGeneracion(rs.getDate("fechaGeneracion"));
                informe.setNivelGobierno(rs.getString("nivelGobierno"));
                informe.setDescripcion(rs.getString("descripcion"));
                informe.setEstado(rs.getString("estado"));
                informe.setRutaArchivo(rs.getString("rutaArchivo"));
                informe.setDatosJson(rs.getString("datosJson"));
                informes.add(informe);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return informes;
    }

    @Override
    public List<InformeEntidad> listarInformesPorAnio(int anio) {
        List<InformeEntidad> informes = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Informe WHERE anio = ? ORDER BY fechaGeneracion DESC";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, anio);
            rs = ps.executeQuery();

            while (rs.next()) {
                InformeEntidad informe = new InformeEntidad();
                informe.setId(rs.getInt("id"));
                informe.setTitulo(rs.getString("titulo"));
                informe.setTipo(rs.getString("tipo"));
                informe.setAnio(rs.getInt("anio"));
                informe.setFechaGeneracion(rs.getDate("fechaGeneracion"));
                informe.setNivelGobierno(rs.getString("nivelGobierno"));
                informe.setDescripcion(rs.getString("descripcion"));
                informe.setEstado(rs.getString("estado"));
                informe.setRutaArchivo(rs.getString("rutaArchivo"));
                informe.setDatosJson(rs.getString("datosJson"));
                informes.add(informe);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return informes;
    }

    @Override
    public List<InformeEntidad> listarInformesPorNivelGobierno(String nivelGobierno) {
        List<InformeEntidad> informes = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Informe WHERE nivelGobierno = ? ORDER BY fechaGeneracion DESC";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nivelGobierno);
            rs = ps.executeQuery();

            while (rs.next()) {
                InformeEntidad informe = new InformeEntidad();
                informe.setId(rs.getInt("id"));
                informe.setTitulo(rs.getString("titulo"));
                informe.setTipo(rs.getString("tipo"));
                informe.setAnio(rs.getInt("anio"));
                informe.setFechaGeneracion(rs.getDate("fechaGeneracion"));
                informe.setNivelGobierno(rs.getString("nivelGobierno"));
                informe.setDescripcion(rs.getString("descripcion"));
                informe.setEstado(rs.getString("estado"));
                informe.setRutaArchivo(rs.getString("rutaArchivo"));
                informe.setDatosJson(rs.getString("datosJson"));
                informes.add(informe);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return informes;
    }

    @Override
    public int registrarInforme(InformeEntidad informe) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "INSERT INTO Informe (titulo, tipo, anio, fechaGeneracion, nivelGobierno, descripcion, estado, rutaArchivo, datosJson) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, informe.getTitulo());
            ps.setString(2, informe.getTipo());
            ps.setInt(3, informe.getAnio());
            ps.setDate(4, new java.sql.Date(informe.getFechaGeneracion().getTime()));
            ps.setString(5, informe.getNivelGobierno());
            ps.setString(6, informe.getDescripcion());
            ps.setString(7, informe.getEstado());
            ps.setString(8, informe.getRutaArchivo());
            ps.setString(9, informe.getDatosJson());

            resultado = ps.executeUpdate();

            // Obtener el ID generado
            if (resultado > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    informe.setId(rs.getInt(1));
                }
                rs.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public int actualizarInforme(InformeEntidad informe) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE Informe SET titulo = ?, tipo = ?, anio = ?, fechaGeneracion = ?, nivelGobierno = ?, descripcion = ?, estado = ?, rutaArchivo = ?, datosJson = ? WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, informe.getTitulo());
            ps.setString(2, informe.getTipo());
            ps.setInt(3, informe.getAnio());
            ps.setDate(4, new java.sql.Date(informe.getFechaGeneracion().getTime()));
            ps.setString(5, informe.getNivelGobierno());
            ps.setString(6, informe.getDescripcion());
            ps.setString(7, informe.getEstado());
            ps.setString(8, informe.getRutaArchivo());
            ps.setString(9, informe.getDatosJson());
            ps.setInt(10, informe.getId());

            resultado = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public int eliminarInforme(int id) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "DELETE FROM Informe WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, id);

            resultado = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }
}