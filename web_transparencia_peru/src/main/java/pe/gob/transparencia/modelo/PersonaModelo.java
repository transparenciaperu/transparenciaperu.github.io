package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.PersonaEntidad;
import pe.gob.transparencia.interfaces.PersonaInterface;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PersonaModelo implements PersonaInterface {

    @Override
    public int registrarPersona(String nombreCompleto, String correo, String dni, String genero, Date fechNac) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            cn = MySQLConexion.getConexion();
            cs = cn.prepareCall("{call sp_registrar_persona(?, ?, ?, ?, ?)}");
            cs.setString(1, nombreCompleto);
            cs.setString(2, correo);
            cs.setString(3, dni);
            cs.setString(4, genero);
            cs.setDate(5, new java.sql.Date(fechNac.getTime()));

            resultado = cs.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cs != null) cs.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public List<PersonaEntidad> listarPersonas() {
        List<PersonaEntidad> personas = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM persona ORDER BY id_persona";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                PersonaEntidad persona = new PersonaEntidad();
                persona.setIdPersona(rs.getInt("id_persona"));
                persona.setNombreCompleto(rs.getString("nombre_completo"));
                persona.setCorreo(rs.getString("correo"));
                persona.setDni(rs.getString("dni"));
                persona.setGenero(rs.getString("genero"));
                persona.setFechNac(rs.getDate("fech_nac"));
                personas.add(persona);
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

        return personas;
    }

    @Override
    public PersonaEntidad buscarPorId(int idPersona) {
        PersonaEntidad persona = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM persona WHERE id_persona = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idPersona);
            rs = ps.executeQuery();

            if (rs.next()) {
                persona = new PersonaEntidad();
                persona.setIdPersona(rs.getInt("id_persona"));
                persona.setNombreCompleto(rs.getString("nombre_completo"));
                persona.setCorreo(rs.getString("correo"));
                persona.setDni(rs.getString("dni"));
                persona.setGenero(rs.getString("genero"));
                persona.setFechNac(rs.getDate("fech_nac"));
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

        return persona;
    }

    @Override
    public int actualizarPersona(int idPersona, String nombreCompleto, String correo, String dni, String genero, Date fechNac) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE persona SET nombre_completo = ?, correo = ?, dni = ?, genero = ?, fech_nac = ? WHERE id_persona = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nombreCompleto);
            ps.setString(2, correo);
            ps.setString(3, dni);
            ps.setString(4, genero);
            ps.setDate(5, new java.sql.Date(fechNac.getTime()));
            ps.setInt(6, idPersona);

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
    public int eliminarPersona(int idPersona) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "DELETE FROM persona WHERE id_persona = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idPersona);

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