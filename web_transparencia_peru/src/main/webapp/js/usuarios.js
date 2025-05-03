/**
 * Script para la gestión de usuarios en el panel de administración
 */
$(document).ready(function () {
    console.log("Inicializando funcionalidad de usuarios...");

    // Inicializar DataTables
    $('#tablaUsuarios').DataTable({
        language: {
            url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
        },
        pageLength: 10,
        responsive: true,
        order: [[0, 'asc']]
    });

    // Inicializar tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    // Event listeners para todos los formularios de gestión de usuarios
    setupFormListeners();

    console.log("Inicialización completa.");
});

/**
 * Configura listeners para los formularios
 */
function setupFormListeners() {
    // Formulario de nuevo usuario
    $('#formNuevoUsuario').on('submit', function (e) {
        e.preventDefault();

        // Validación básica
        var usuario = $('#usuario').val();
        var nombre = $('#nombre').val();
        var correo = $('#correo').val();
        var clave = $('#clave').val();
        var rol = $('#rol').val();

        if (!usuario || !nombre || !correo || !clave || !rol) {
            alert("Todos los campos son obligatorios");
            return false;
        }

        console.log("Enviando formulario de nuevo usuario...");
        this.submit();
    });

    // Formulario de edición de usuario
    $('#formEditarUsuario').on('submit', function (e) {
        e.preventDefault();

        // Validación básica
        var usuario = $('#editUsuario').val();
        var nombre = $('#editNombre').val();
        var correo = $('#editCorreo').val();
        var rol = $('#editRol').val();

        if (!usuario || !nombre || !correo || !rol) {
            alert("Los campos usuario, nombre, correo y rol son obligatorios");
            return false;
        }

        console.log("Enviando formulario de edición de usuario...");
        this.submit();
    });

    // Formulario de eliminación de usuario
    $('#formEliminarUsuario').on('submit', function (e) {
        console.log("Enviando formulario de eliminación de usuario...");
    });
}

/**
 * Función para editar un usuario
 * @param {number} id - ID del usuario
 * @param {string} usuario - Nombre de usuario
 * @param {string} nombre - Nombre completo
 * @param {string} correo - Correo electrónico
 * @param {string} rol - Código de rol
 * @param {boolean|string|number} activo - Estado activo
 */
function editarUsuario(id, usuario, nombre, correo, rol, activo) {
    console.log("Editando usuario:", id, usuario, nombre, correo, rol, activo);
    console.log("Tipo de activo:", typeof activo);

    try {
        // Rellenar los campos del modal
        $('#editId').val(id);
        $('#editUsuario').val(usuario);
        $('#editNombre').val(nombre);
        $('#editCorreo').val(correo);
        $('#editRol').val(rol || 'FUNCIONARIO');  // Valor por defecto

        // Manejar el campo activo
        let isActive = false;

        // Convertir el valor a booleano independientemente del tipo de entrada
        if (typeof activo === 'string') {
            isActive = (activo.toLowerCase() === 'true');
        } else if (typeof activo === 'number') {
            isActive = (activo === 1);
        } else {
            isActive = Boolean(activo);
        }

        console.log("Estado activo después de conversión:", isActive);
        $('#editActivo').prop('checked', isActive);

        // Mostrar el modal
        var editarModal = new bootstrap.Modal(document.getElementById('editarUsuarioModal'));
        editarModal.show();

        console.log("Modal de edición mostrado correctamente");
    } catch (error) {
        console.error("Error al abrir el modal de edición:", error);
        alert("Error al cargar el formulario de edición. Por favor, inténtelo de nuevo.");
    }
}

/**
 * Función para confirmar la eliminación de un usuario
 * @param {number} id - ID del usuario
 * @param {string} nombre - Nombre del usuario
 */
function confirmarEliminacion(id, nombre) {
    console.log("Confirmando eliminación del usuario:", id, nombre);

    try {
        $('#idUsuarioEliminar').val(id);
        $('#nombreUsuarioEliminar').text(nombre);

        // Mostrar el modal de confirmación
        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarUsuarioModal'));
        eliminarModal.show();

        console.log("Modal de confirmación mostrado correctamente");
    } catch (error) {
        console.error("Error al abrir el modal de confirmación:", error);
        alert("Error al cargar la confirmación. Por favor, inténtelo de nuevo.");
    }
}