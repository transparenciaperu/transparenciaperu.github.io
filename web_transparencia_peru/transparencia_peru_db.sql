-- ==================================================================
-- Script completo de la base de datos para el Portal de Transparencia Perú
-- Versión Unificada
-- Incluye todas las tablas, procedimientos almacenados y datos de prueba.
-- ==================================================================

-- Eliminar la base de datos si existe y crearla nuevamente
DROP DATABASE IF EXISTS db_transparencia_peru;
CREATE DATABASE db_transparencia_peru CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE db_transparencia_peru;

-- =========================================
-- DEFINICIÓN DE TABLAS
-- =========================================

-- -----------------------------------------------------
-- Tabla Departamento
-- -----------------------------------------------------
CREATE TABLE Departamento (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              nombre VARCHAR(100) NOT NULL,
                              codigo VARCHAR(10) NOT NULL
);

-- -----------------------------------------------------
-- Tabla EntidadPublica
-- -----------------------------------------------------
CREATE TABLE EntidadPublica (
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                nombre VARCHAR(255) NOT NULL,
                                tipo VARCHAR(100) NOT NULL, -- Ministerio, Gobierno Regional, Municipalidad, Organismo Supervisor, etc.
                                region VARCHAR(100) NOT NULL, -- Nacional, Regional, Local
                                direccion VARCHAR(255),
                                telefono VARCHAR(20),
                                email VARCHAR(100),
                                sitioWeb VARCHAR(255),
                                departamentoId INT, -- Departamento donde se ubica (puede ser null si es Nacional y no aplica una sede única)
                                FOREIGN KEY (departamentoId) REFERENCES Departamento(id)
);

-- -----------------------------------------------------
-- Tabla PeriodoFiscal
-- -----------------------------------------------------
CREATE TABLE PeriodoFiscal (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               anio INT NOT NULL UNIQUE, -- Asegura que no haya años fiscales duplicados
                               fechaInicio DATE NOT NULL,
                               fechaFin DATE NOT NULL,
                               estado VARCHAR(20) NOT NULL -- Ej: Abierto, Cerrado, Planificado
);

-- -----------------------------------------------------
-- Tabla Presupuesto
-- -----------------------------------------------------
CREATE TABLE Presupuesto (
                             id INT AUTO_INCREMENT PRIMARY KEY,
                             anio INT NOT NULL,
                             montoTotal DECIMAL(15,2) NOT NULL,
                             entidadPublicaId INT NOT NULL,
                             periodoFiscalId INT, -- Vinculado al año fiscal correspondiente
                             fechaAprobacion DATE,
                             descripcion TEXT,
                             FOREIGN KEY (entidadPublicaId) REFERENCES EntidadPublica(id),
                             FOREIGN KEY (periodoFiscalId) REFERENCES PeriodoFiscal(id)
);

-- -----------------------------------------------------
-- Tabla FuenteFinanciamiento
-- -----------------------------------------------------
CREATE TABLE FuenteFinanciamiento (
                                      id INT AUTO_INCREMENT PRIMARY KEY,
                                      nombre VARCHAR(100) NOT NULL,
                                      descripcion TEXT
);

-- -----------------------------------------------------
-- Tabla CategoriaGasto
-- -----------------------------------------------------
CREATE TABLE CategoriaGasto (
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                nombre VARCHAR(100) NOT NULL,
                                descripcion TEXT
);

-- -----------------------------------------------------
-- Tabla Proyecto
-- -----------------------------------------------------
CREATE TABLE Proyecto (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          nombre VARCHAR(255) NOT NULL,
                          descripcion TEXT,
                          presupuestoId INT NOT NULL, -- Vinculado al presupuesto general de la entidad
                          categoriaGastoId INT NOT NULL, -- Usualmente 'Inversión Pública'
                          fuenteFinanciamientoId INT,
                          fechaInicio DATE,
                          fechaFin DATE,
                          estado VARCHAR(50), -- Ej: Planificado, En ejecución, Finalizado, Paralizado
                          FOREIGN KEY (presupuestoId) REFERENCES Presupuesto(id),
                          FOREIGN KEY (categoriaGastoId) REFERENCES CategoriaGasto(id),
                          FOREIGN KEY (fuenteFinanciamientoId) REFERENCES FuenteFinanciamiento(id)
);

-- -----------------------------------------------------
-- Tabla Gasto (Ejecución presupuestal detallada)
-- -----------------------------------------------------
CREATE TABLE Gasto (
                       id INT AUTO_INCREMENT PRIMARY KEY,
                       concepto VARCHAR(255) NOT NULL,
                       monto DECIMAL(15,2) NOT NULL,
                       fecha DATE NOT NULL,
                       presupuestoId INT NOT NULL, -- Presupuesto del cual se ejecuta el gasto
                       proyectoId INT, -- Gasto asociado a un proyecto específico (puede ser null)
                       categoriaGastoId INT NOT NULL, -- Categoría específica del gasto (Bienes, Servicios, etc.)
                       FOREIGN KEY (presupuestoId) REFERENCES Presupuesto(id),
                       FOREIGN KEY (proyectoId) REFERENCES Proyecto(id),
                       FOREIGN KEY (categoriaGastoId) REFERENCES CategoriaGasto(id)
);

-- -----------------------------------------------------
-- Tabla Ciudadano (Para solicitudes de acceso)
-- -----------------------------------------------------
CREATE TABLE Ciudadano (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           nombres VARCHAR(100) NOT NULL,
                           apellidos VARCHAR(100) NOT NULL,
                           dni VARCHAR(15) NOT NULL UNIQUE, -- DNI debe ser único
                           correo VARCHAR(100) NOT NULL UNIQUE, -- Correo debe ser único
                           telefono VARCHAR(20),
                           direccion VARCHAR(255),
                           fechaRegistro DATE NOT NULL,
                           password VARCHAR(255) NOT NULL -- Considerar almacenar hash de la contraseña
);

-- -----------------------------------------------------
-- Tabla TipoSolicitud
-- -----------------------------------------------------
CREATE TABLE TipoSolicitud (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               nombre VARCHAR(100) NOT NULL,
                               descripcion TEXT
);

-- -----------------------------------------------------
-- Tabla EstadoSolicitud
-- -----------------------------------------------------
CREATE TABLE EstadoSolicitud (
                                 id INT AUTO_INCREMENT PRIMARY KEY,
                                 nombre VARCHAR(100) NOT NULL,
                                 descripcion TEXT
);

-- -----------------------------------------------------
-- Tabla SolicitudAcceso
-- -----------------------------------------------------
CREATE TABLE SolicitudAcceso (
                                 id INT AUTO_INCREMENT PRIMARY KEY,
                                 fechaSolicitud DATE NOT NULL,
                                 descripcion TEXT NOT NULL,
                                 ciudadanoId INT NOT NULL,
                                 tipoSolicitudId INT NOT NULL,
                                 estadoSolicitudId INT NOT NULL,
                                 entidadPublicaId INT NOT NULL,
                                 fechaRespuesta DATE, -- Fecha en que se dio respuesta
                                 observaciones TEXT, -- Observaciones sobre el trámite o la solicitud
                                 FOREIGN KEY (ciudadanoId) REFERENCES Ciudadano(id),
                                 FOREIGN KEY (tipoSolicitudId) REFERENCES TipoSolicitud(id),
                                 FOREIGN KEY (estadoSolicitudId) REFERENCES EstadoSolicitud(id),
                                 FOREIGN KEY (entidadPublicaId) REFERENCES EntidadPublica(id)
);

-- -----------------------------------------------------
-- Tabla RespuestaSolicitud
-- -----------------------------------------------------
CREATE TABLE RespuestaSolicitud (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    solicitudAccesoId INT NOT NULL UNIQUE, -- Una respuesta por solicitud
                                    fechaRespuesta DATE NOT NULL,
                                    descripcion TEXT NOT NULL, -- Resumen de la respuesta o la información proporcionada
                                    archivoAdjunto VARCHAR(255), -- Nombre o ruta del archivo adjunto si existe
                                    usuarioResponsable VARCHAR(100) NOT NULL, -- Funcionario que atendió la solicitud
                                    FOREIGN KEY (solicitudAccesoId) REFERENCES SolicitudAcceso(id)
);

-- -----------------------------------------------------
-- Tablas de Gestión de Roles y Usuarios del Sistema Interno
-- -----------------------------------------------------

-- Tabla: persona (Para usuarios internos del sistema)
CREATE TABLE persona
(
    id_persona      INT PRIMARY KEY AUTO_INCREMENT,
    nombre_completo VARCHAR(45),
    correo          VARCHAR(45) UNIQUE,
    dni             VARCHAR(45) UNIQUE,
    genero          VARCHAR(45),
    fech_nac        DATE
);

-- Tabla: rol
CREATE TABLE rol
(
    id_rol      INT PRIMARY KEY AUTO_INCREMENT,
    cod_rol     VARCHAR(45) UNIQUE,
    descrip_rol VARCHAR(100)
);

-- Tabla: usuario (Usuarios internos del sistema)
CREATE TABLE usuario
(
    id_usuario  INT PRIMARY KEY AUTO_INCREMENT,
    cod_usuario VARCHAR(45) UNIQUE,
    id_persona  INT,
    id_rol      INT,
    clave       VARCHAR(255), -- Aumentado para almacenar hash de clave
    FOREIGN KEY (id_persona) REFERENCES persona (id_persona),
    FOREIGN KEY (id_rol) REFERENCES rol (id_rol)
);

-- =========================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- =========================================

-- -----------------------------------------------------
-- Datos para rol (Usuarios internos)
-- -----------------------------------------------------
INSERT INTO rol (cod_rol, descrip_rol)
VALUES  ('ADMIN', 'Administrador con acceso total al sistema'),
        ('FUNCIONARIO', 'Funcionario encargado de la gestión de transparencia y solicitudes');


-- -----------------------------------------------------
-- Datos para persona (Usuarios internos del sistema)
-- -----------------------------------------------------
INSERT INTO persona (nombre_completo, correo, dni, genero, fech_nac) VALUES
                                                                         ('Admin Sistema', 'admin@transparencia.gob.pe', '00000001', 'M', '1980-01-15'),
                                                                         ('Juan Funcionario Pérez', 'jfuncionario@transparencia.gob.pe', '45678912', 'M', '1985-05-20'),
                                                                         ('María Funcionario López', 'mfuncionario@transparencia.gob.pe', '32165498', 'F', '1990-10-25');

-- -----------------------------------------------------
-- Datos para usuario (Usuarios internos del sistema)
-- -----------------------------------------------------
INSERT INTO usuario (cod_usuario, id_persona, id_rol, clave) VALUES
                                                                 ('admin', 1, 1, '123456'), -- Admin: clave=123456
                                                                 ('jfuncionario', 2, 2, '654321'), -- Funcionario: clave=654321
                                                                 ('mfuncionario', 3, 2, 'password'); -- Funcionario: clave=password



-- -----------------------------------------------------
-- Datos para Departamento
-- -----------------------------------------------------
INSERT INTO Departamento (nombre, codigo) VALUES
                                              ('Lima', 'LIM'),
                                              ('Arequipa', 'AQP'),
                                              ('Cusco', 'CUS'),
                                              ('La Libertad', 'LAL'),
                                              ('Piura', 'PIU'),
                                              ('Amazonas', 'AMA'),
                                              ('Áncash', 'ANC'),
                                              ('Apurímac', 'APU'),
                                              ('Ayacucho', 'AYA'),
                                              ('Cajamarca', 'CAJ'),
                                              ('Callao', 'CAL'),
                                              ('Huancavelica', 'HUV'),
                                              ('Huánuco', 'HUC'),
                                              ('Ica', 'ICA'),
                                              ('Junín', 'JUN'),
                                              ('Lambayeque', 'LAM'),
                                              ('Loreto', 'LOR'),
                                              ('Madre de Dios', 'MDD'),
                                              ('Moquegua', 'MOQ'),
                                              ('Pasco', 'PAS'),
                                              ('Puno', 'PUN'),
                                              ('San Martín', 'SAM'),
                                              ('Tacna', 'TAC'),
                                              ('Tumbes', 'TUM'),
                                              ('Ucayali', 'UCA');

-- -----------------------------------------------------
-- Datos para EntidadPublica
-- -----------------------------------------------------
INSERT INTO EntidadPublica (nombre, tipo, region, direccion, telefono, email, sitioWeb, departamentoId) VALUES
                                                                                                            ('Ministerio de Economía y Finanzas', 'Ministerio', 'Nacional', 'Jr. Junín 319, Cercado de Lima', '01-3115930', 'contacto@mef.gob.pe', 'www.mef.gob.pe', 1), -- Lima
                                                                                                            ('Ministerio de Educación', 'Ministerio', 'Nacional', 'Calle Del Comercio 193, San Borja', '01-6155800', 'contacto@minedu.gob.pe', 'www.gob.pe/minedu', 1), -- Lima
                                                                                                            ('Gobierno Regional de Arequipa', 'Gobierno Regional', 'Regional', 'Av. Unión 200, Arequipa', '054-382860', 'contacto@regionarequipa.gob.pe', 'www.regionarequipa.gob.pe', 2), -- Arequipa
                                                                                                            ('Municipalidad Provincial de Cusco', 'Municipalidad', 'Local', 'Plaza Regocijo s/n, Cusco', '084-226701', 'contacto@municusco.gob.pe', 'www.cusco.gob.pe', 3), -- Cusco
                                                                                                            ('Ministerio de Salud', 'Ministerio', 'Nacional', 'Av. Salaverry 801, Jesús María', '01-3156600', 'contacto@minsa.gob.pe', 'www.gob.pe/minsa', 1), -- Lima
                                                                                                            ('Ministerio de Vivienda, Construcción y Saneamiento', 'Ministerio', 'Nacional', 'Av. Paseo de la República 3361, San Isidro', '01-2117930', 'contacto@vivienda.gob.pe', 'www.gob.pe/vivienda', 1), -- Lima
                                                                                                            ('Ministerio del Interior', 'Ministerio', 'Nacional', 'Plaza 30 de Agosto s/n Urb. Corpac, San Isidro', '01-5182800', 'contacto@mininter.gob.pe', 'www.gob.pe/mininter', 1), -- Lima
                                                                                                            ('Ministerio de Transportes y Comunicaciones', 'Ministerio', 'Nacional', 'Jr. Zorritos 1203, Lima', '01-6157800', 'atencionalciudadano@mtc.gob.pe', 'www.gob.pe/mtc', 1), -- Lima
                                                                                                            ('Ministerio de Desarrollo Agrario y Riego', 'Ministerio', 'Nacional', 'Av. La Universidad 200, La Molina', '01-2098800', 'contacto@midagri.gob.pe', 'www.gob.pe/midagri', 1), -- Lima
                                                                                                            ('Ministerio del Ambiente', 'Ministerio', 'Nacional', 'Av. Antonio Miroquesada 425, Magdalena del Mar', '01-6116000', 'webmaster@minam.gob.pe', 'www.gob.pe/minam', 1), -- Lima
                                                                                                            ('OSINERGMIN', 'Organismo Supervisor', 'Nacional', 'Calle Bernardo Monteagudo 222, Magdalena del Mar', '01-2193400', 'atencionalcliente@osinergmin.gob.pe', 'www.gob.pe/osinergmin', 1), -- Lima
                                                                                                            ('SUNASS', 'Organismo Supervisor', 'Nacional', 'Av. Bernardo Monteagudo 210, Magdalena del Mar', '01-6143180', 'contacto@sunass.gob.pe', 'www.gob.pe/sunass', 1), -- Lima
                                                                                                            ('Gobierno Regional de Cusco', 'Gobierno Regional', 'Regional', 'Av. Tomasa Tito Condemayta s/n, Cusco', '084-221131', 'contacto@regioncusco.gob.pe', 'www.regioncusco.gob.pe', 3), -- Cusco
                                                                                                            ('Gobierno Regional de La Libertad', 'Gobierno Regional', 'Regional', 'Jr. Los Brillantes 650, Urb. Santa Inés, Trujillo', '044-604000', 'contacto@regionlalibertad.gob.pe', 'www.regionlalibertad.gob.pe', 4), -- La Libertad
                                                                                                            ('Gobierno Regional de Piura', 'Gobierno Regional', 'Regional', 'Av. San Ramón s/n, Urb. San Eduardo, Piura', '073-284600', 'contacto@regionpiura.gob.pe', 'www.regionpiura.gob.pe', 5), -- Piura
                                                                                                            ('Municipalidad Provincial de Lima', 'Municipalidad', 'Local', 'Jr. de la Unión 300, Lima', '01-6321300', 'contacto@munlima.gob.pe', 'www.munlima.gob.pe', 1), -- Lima
                                                                                                            ('Municipalidad Provincial de Arequipa', 'Municipalidad', 'Local', 'Plaza de Armas s/n, Arequipa', '054-380050', 'contacto@muniarequipa.gob.pe', 'www.muniarequipa.gob.pe', 2), -- Arequipa
                                                                                                            ('Contraloría General de la República', 'Organismo Constitucional Autónomo', 'Nacional', 'Jr. Camilo Carrillo 114, Jesús María', '01-3303000', 'contraloria@contraloria.gob.pe', 'www.contraloria.gob.pe', 1), -- Lima
                                                                                                            ('SUNAT', 'Organismo Público Descentralizado', 'Nacional', 'Av. Garcilaso de la Vega 1472, Lima', '01-6343400', 'contacto@sunat.gob.pe', 'www.gob.pe/sunat', 1), -- Lima
                                                                                                            ('ESSALUD', 'Seguridad Social', 'Nacional', 'Jr. Domingo Cueto 120, Jesús María', '01-2656000', 'contacto@essalud.gob.pe', 'www.gob.pe/essalud', 1); -- Lima

-- -----------------------------------------------------
-- Datos para PeriodoFiscal
-- -----------------------------------------------------
INSERT INTO PeriodoFiscal (anio, fechaInicio, fechaFin, estado) VALUES
                                                                    (2020, '2020-01-01', '2020-12-31', 'Cerrado'),
                                                                    (2021, '2021-01-01', '2021-12-31', 'Cerrado'),
                                                                    (2022, '2022-01-01', '2022-12-31', 'Cerrado'),
                                                                    (2023, '2023-01-01', '2023-12-31', 'Cerrado'),
                                                                    (2024, '2024-01-01', '2024-12-31', 'Activo'), -- Asumiendo que el año actual está activo
                                                                    (2025, '2025-01-01', '2025-12-31', 'Planificado');

-- -----------------------------------------------------
-- Datos para FuenteFinanciamiento
-- -----------------------------------------------------
INSERT INTO FuenteFinanciamiento (nombre, descripcion) VALUES
                                                           ('Recursos Ordinarios', 'Ingresos provenientes de la recaudación tributaria'),
                                                           ('Recursos Directamente Recaudados', 'Ingresos generados por las propias entidades públicas'),
                                                           ('Recursos por Operaciones Oficiales de Crédito', 'Fondos de fuentes externas e internas provenientes de operaciones de crédito'),
                                                           ('Donaciones y Transferencias', 'Fondos financieros no reembolsables recibidos por el gobierno'),
                                                           ('Recursos Determinados', 'Contribuciones a fondos, canon, regalías, etc.');

-- -----------------------------------------------------
-- Datos para CategoriaGasto
-- -----------------------------------------------------
INSERT INTO CategoriaGasto (nombre, descripcion) VALUES
                                                     ('Personal y Obligaciones Sociales', 'Gastos por el pago del personal activo del sector público'),
                                                     ('Pensiones y Prestaciones Sociales', 'Gastos por el pago de pensiones'),
                                                     ('Bienes y Servicios', 'Gastos por adquisición de bienes y contratación de servicios'),
                                                     ('Donaciones y Transferencias', 'Gastos por donaciones y transferencias a instituciones'),
                                                     ('Inversión Pública', 'Gastos destinados a proyectos de inversión pública');

-- -----------------------------------------------------
-- Datos para Presupuesto (Combinados y asignando periodoFiscalId correcto)
-- -----------------------------------------------------
-- Nota: periodoFiscalId se relaciona con el 'id' de la tabla PeriodoFiscal según el año.
-- 2020 -> id 1, 2021 -> id 2, 2022 -> id 3, 2023 -> id 4, 2024 -> id 5, 2025 -> id 6

-- Presupuestos iniciales
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion) VALUES
                                                                                                                (2023, 10000000.00, 1, 4, '2022-12-15', 'Presupuesto anual 2023 del Ministerio de Economía y Finanzas'),
                                                                                                                (2023, 8000000.00, 2, 4, '2022-12-20', 'Presupuesto anual 2023 del Ministerio de Educación'),
                                                                                                                -- (2023, 5000000.00, 3, 4, '2022-12-18', 'Presupuesto anual 2023 del Gobierno Regional de Arequipa'), -- Duplicado, se inserta abajo
                                                                                                                (2024, 12000000.00, 1, 5, '2023-12-15', 'Presupuesto anual 2024 del Ministerio de Economía y Finanzas'),
                                                                                                                (2024, 9000000.00, 2, 5, '2023-12-22', 'Presupuesto anual 2024 del Ministerio de Educación');

-- Presupuestos adicionales por año y entidad
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion) VALUES
-- Presupuestos del año 2023 (periodoFiscalId = 4)
(2023, 7350000000.00, 6, 4, '2022-12-19', 'Presupuesto anual 2023 del Ministerio de Vivienda, Construcción y Saneamiento'),
(2023, 9250000000.00, 7, 4, '2022-12-18', 'Presupuesto anual 2023 del Ministerio del Interior'),
(2023, 8150000000.00, 8, 4, '2022-12-17', 'Presupuesto anual 2023 del Ministerio de Transportes y Comunicaciones'),
(2023, 3850000000.00, 9, 4, '2022-12-15', 'Presupuesto anual 2023 del Ministerio de Desarrollo Agrario y Riego'),
(2023, 1250000000.00, 10, 4, '2022-12-16', 'Presupuesto anual 2023 del Ministerio del Ambiente'),
(2023, 750000000.00, 11, 4, '2022-12-20', 'Presupuesto anual 2023 de OSINERGMIN'),
(2023, 350000000.00, 12, 4, '2022-12-19', 'Presupuesto anual 2023 de SUNASS'),
(2023, 1250000000.00, 3, 4, '2022-12-18', 'Presupuesto anual 2023 del Gobierno Regional de Arequipa'),
(2023, 1450000000.00, 13, 4, '2022-12-17', 'Presupuesto anual 2023 del Gobierno Regional de Cusco'),
(2023, 1350000000.00, 14, 4, '2022-12-16', 'Presupuesto anual 2023 del Gobierno Regional de La Libertad'),
(2023, 1150000000.00, 15, 4, '2022-12-15', 'Presupuesto anual 2023 del Gobierno Regional de Piura'),
(2023, 950000000.00, 4, 4, '2022-12-20', 'Presupuesto anual 2023 de la Municipalidad Provincial de Cusco'),
(2023, 1850000000.00, 16, 4, '2022-12-19', 'Presupuesto anual 2023 de la Municipalidad Provincial de Lima'),
(2023, 750000000.00, 17, 4, '2022-12-18', 'Presupuesto anual 2023 de la Municipalidad Provincial de Arequipa'),

-- Presupuestos del año 2024 (periodoFiscalId = 5)
(2024, 8150000000.00, 6, 5, '2023-12-20', 'Presupuesto anual 2024 del Ministerio de Vivienda, Construcción y Saneamiento'),
(2024, 10150000000.00, 7, 5, '2023-12-19', 'Presupuesto anual 2024 del Ministerio del Interior'),
(2024, 9250000000.00, 8, 5, '2023-12-18', 'Presupuesto anual 2024 del Ministerio de Transportes y Comunicaciones'),
(2024, 4250000000.00, 9, 5, '2023-12-17', 'Presupuesto anual 2024 del Ministerio de Desarrollo Agrario y Riego'),
(2024, 1450000000.00, 10, 5, '2023-12-16', 'Presupuesto anual 2024 del Ministerio del Ambiente'),
(2024, 1450000000.00, 3, 5, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Arequipa'),
(2024, 1650000000.00, 13, 5, '2023-12-14', 'Presupuesto anual 2024 del Gobierno Regional de Cusco'),
(2024, 1550000000.00, 14, 5, '2023-12-13', 'Presupuesto anual 2024 del Gobierno Regional de La Libertad'),
(2024, 1350000000.00, 15, 5, '2023-12-12', 'Presupuesto anual 2024 del Gobierno Regional de Piura'),
(2024, 1050000000.00, 4, 5, '2023-12-11', 'Presupuesto anual 2024 de la Municipalidad Provincial de Cusco'),
(2024, 2050000000.00, 16, 5, '2023-12-10', 'Presupuesto anual 2024 de la Municipalidad Provincial de Lima'),
(2024, 850000000.00, 17, 5, '2023-12-09', 'Presupuesto anual 2024 de la Municipalidad Provincial de Arequipa'),

-- Presupuestos para años anteriores (2022 - periodoFiscalId = 3)
(2022, 7000000000.00, 6, 3, '2021-12-19', 'Presupuesto anual 2022 del Ministerio de Vivienda, Construcción y Saneamiento'),
(2022, 8500000000.00, 7, 3, '2021-12-18', 'Presupuesto anual 2022 del Ministerio del Interior'),
(2022, 7800000000.00, 8, 3, '2021-12-17', 'Presupuesto anual 2022 del Ministerio de Transportes y Comunicaciones'),
(2022, 1200000000.00, 3, 3, '2021-12-16', 'Presupuesto anual 2022 del Gobierno Regional de Arequipa'),
(2022, 1350000000.00, 13, 3, '2021-12-15', 'Presupuesto anual 2022 del Gobierno Regional de Cusco'),
(2022, 1250000000.00, 14, 3, '2021-12-14', 'Presupuesto anual 2022 del Gobierno Regional de La Libertad'),
(2022, 1050000000.00, 15, 3, '2021-12-13', 'Presupuesto anual 2022 del Gobierno Regional de Piura');

-- -----------------------------------------------------
-- Datos para Ciudadano (Combinados)
-- -----------------------------------------------------
-- Actualizar los datos de prueba de Ciudadano para usar contraseñas más simples
INSERT INTO Ciudadano (nombres, apellidos, dni, correo, telefono, direccion, fechaRegistro, password) VALUES
                                                                                                          ('Juan', 'Pérez López', '12345678', 'juan.perez@gmail.com', '987654321', 'Av. Arequipa 123, Lima', '2023-01-10', '12345678'), -- Usando el DNI como contraseña
                                                                                                          ('María', 'García Rodríguez', '87654321', 'maria.garcia@hotmail.com', '912345678', 'Jr. Huancayo 456, Arequipa', '2023-02-05', '87654321'),
                                                                                                          ('Carlos', 'López Sánchez', '23456789', 'carlos.lopez@gmail.com', '945678123', 'Calle Los Pinos 789, Cusco', '2023-03-12', '23456789'),
                                                                                                          ('Ana', 'Martínez Torres', '98765432', 'ana.martinez@gmail.com', '978123456', 'Av. La Marina 567, Lima', '2023-04-18', '98765432'),
                                                                                                          ('Pedro', 'Ramírez Flores', '34567890', 'pedro.ramirez@hotmail.com', '956781234', 'Jr. Tacna 890, La Libertad', '2023-05-22', '34567890'),
                                                                                                          ('Roberto', 'Sánchez Mendoza', '45673829', 'roberto.sanchez@gmail.com', '987123456', 'Av. La Paz 452, Miraflores, Lima', '2024-01-15', '45673829'),
                                                                                                          ('María Luisa', 'Paredes Torres', '09876543', 'mluisa.paredes@hotmail.com', '941236547', 'Jr. Amazonas 1234, Trujillo', '2024-01-20', '09876543'),
                                                                                                          ('Jorge Luis', 'Vargas Mendoza', '72145639', 'jvargas@gmail.com', '932568741', 'Calle Los Pinos 328, Arequipa', '2024-02-05', '72145639'),
                                                                                                          ('Carmen Rosa', 'Huamán Quispe', '43215678', 'chuaman@gmail.com', '912345678', 'Av. Sol 340, Cusco', '2024-02-10', '43215678'),
                                                                                                          ('Miguel Ángel', 'Rodríguez Pérez', '25631478', 'marodriguez@outlook.com', '963258741', 'Av. José Pardo 450, Chimbote', '2024-02-15', '25631478'),
                                                                                                          ('Lucía', 'Mendoza Castro', '10293847', 'lmendoza@gmail.com', '951357846', 'Calle Real 123, Huancayo', '2024-02-20', '10293847'),
                                                                                                          ('Juan Carlos', 'Flores Ríos', '40506070', 'jcflores@hotmail.com', '974125836', 'Av. Pardo 780, Miraflores, Lima', '2024-03-01', '40506070'),
                                                                                                          ('Rosa María', 'Chávez Luna', '30405060', 'rmchavez@gmail.com', '985213674', 'Jr. Arequipa 578, Piura', '2024-03-05', '30405060'),
                                                                                                          ('Fernando', 'Díaz Sánchez', '20304050', 'fdiaz@outlook.com', '964738291', 'Av. Grau 857, Tacna', '2024-03-10', '20304050'),
                                                                                                          ('Patricia', 'Gonzales Torres', '10203040', 'pgonzales@gmail.com', '937418529', 'Calle Lima 324, Ayacucho', '2024-03-15', '10203040');


-- -----------------------------------------------------
-- Datos para TipoSolicitud (Combinados)
-- -----------------------------------------------------
INSERT INTO TipoSolicitud (nombre, descripcion) VALUES
                                                    ('Información Presupuestal', 'Solicitud de información sobre presupuestos públicos'),
                                                    ('Información de Proyectos', 'Solicitud de información sobre proyectos de inversión'),
                                                    ('Información de Contrataciones', 'Solicitud de información sobre contrataciones públicas'),
                                                    ('Información de Personal', 'Solicitud de información sobre personal de entidades públicas'),
                                                    ('Información General', 'Solicitud de información general sobre entidades públicas'),
                                                    ('Información de Gestión Administrativa', 'Solicitud relacionada con procesos administrativos, normativa interna, y gestión institucional'),
                                                    ('Información de Recursos Humanos', 'Solicitud sobre contrataciones, remuneraciones, y gestión de personal'),
                                                    ('Información Presupuestal y Financiera', 'Solicitud sobre ejecución presupuestal, gastos e inversiones'), -- Similar a la 1, considerar unificar
                                                    ('Información de Obras Públicas', 'Solicitud sobre proyectos de infraestructura y obras públicas'), -- Similar a la 2
                                                    ('Información Ambiental', 'Solicitud sobre estudios, permisos e información de impacto ambiental');

-- -----------------------------------------------------
-- Datos para EstadoSolicitud
-- -----------------------------------------------------
INSERT INTO EstadoSolicitud (nombre, descripcion) VALUES
                                                      ('Pendiente', 'La solicitud ha sido recibida pero aún no ha sido procesada'),
                                                      ('En Proceso', 'La solicitud está siendo procesada'),
                                                      ('Atendida', 'La solicitud ha sido atendida y respondida'),
                                                      ('Observada', 'La solicitud tiene observaciones que deben ser subsanadas'),
                                                      ('Rechazada', 'La solicitud ha sido rechazada');

-- -----------------------------------------------------
-- Datos para Proyecto (Combinados)
-- Nota: Ajustar presupuestoId para que coincida con los IDs generados en la tabla Presupuesto.
-- Se usarán IDs placeholders asumiendo el orden de inserción de Presupuesto (desde el ID 1)
-- -----------------------------------------------------
INSERT INTO Proyecto (nombre, descripcion, presupuestoId, categoriaGastoId, fuenteFinanciamientoId, fechaInicio, fechaFin, estado) VALUES
                                                                                                                                       ('Construcción de Hospital Regional Arequipa', 'Proyecto para la construcción de un hospital regional en Arequipa', 13, 5, 1, '2023-03-01', '2024-06-30', 'En ejecución'), -- Presupuesto GRA 2023 (id=13) / Categoria Inv. Pub (id=5) / Fuente RO (id=1)
                                                                                                                                       ('Mejoramiento de Vías Urbanas Cusco', 'Proyecto para el mejoramiento de las vías urbanas en Cusco', 17, 5, 3, '2023-04-15', '2023-12-15', 'Finalizado'), -- Presupuesto Muni Cusco 2023 (id=17) / Categoria Inv. Pub (id=5) / Fuente Crédito (id=3)
                                                                                                                                       ('Programa Nacional de Becas 2023', 'Financiamiento de becas para estudiantes destacados', 2, 4, 1, '2023-02-01', '2023-12-31', 'Finalizado'), -- Presupuesto MINEDU 2023 (id=2) / Categoria Donaciones/Transf (id=4) / Fuente RO (id=1)
                                                                                                                                       ('Modernización de la Gestión Pública 2023', 'Proyecto para la modernización de la gestión pública a nivel nacional', 1, 3, 2, '2023-01-15', '2023-10-31', 'Finalizado'), -- Presupuesto MEF 2023 (id=1) / Categoria Bienes/Servicios (id=3) / Fuente RDR (id=2)
                                                                                                                                       ('Construcción de Escuelas Rurales 2024', 'Proyecto para la construcción de escuelas en zonas rurales', 5, 5, 1, '2024-03-01', '2025-02-28', 'Planificado'), -- Presupuesto MINEDU 2024 (id=5) / Categoria Inv. Pub (id=5) / Fuente RO (id=1)
                                                                                                                                       ('Ampliación del sistema de agua potable en SJL', 'Proyecto para mejorar el acceso al agua potable para más de 50,000 familias en SJL', 6, 5, 1, '2023-02-15', '2024-08-30', 'En ejecución'), -- Presupuesto MVCS 2023 (id=6)
                                                                                                                                       ('Reconstrucción de colegios afectados por el Fenómeno del Niño en Piura', 'Reconstrucción de 25 instituciones educativas dañadas por las lluvias e inundaciones', 7, 5, 1, '2023-03-20', '2023-12-15', 'Finalizado'), -- Presupuesto MININTER 2023 (id=7) ??? Debería ser MINEDU o ARCC
                                                                                                                                       ('Mejoramiento de la carretera Cusco - Quillabamba', 'Proyecto de mantenimiento y ampliación de 180 km de vía', 8, 5, 3, '2023-04-10', '2024-10-30', 'En ejecución'), -- Presupuesto MTC 2023 (id=8)
                                                                                                                                       ('Programa de titulación de tierras en zonas rurales', 'Entrega de títulos de propiedad a comunidades campesinas en 10 regiones del país', 9, 3, 2, '2023-05-15', '2024-05-15', 'En ejecución'), -- Presupuesto MIDAGRI 2023 (id=9) / Categoria Bienes/Servicios (id=3)
                                                                                                                                       ('Construcción del Hospital Regional de Loreto', 'Construcción de hospital de nivel III-1 con capacidad para 250 camas', 6, 5, 3, '2023-06-01', '2025-01-30', 'En ejecución'), -- Presupuesto MVCS 2023 (id=6) ??? Debería ser MINSA o GORE Loreto
                                                                                                                                       ('Ampliación de la Línea 1 del Metro de Lima', 'Extensión de la Línea 1 hacia San Juan de Lurigancho', 8, 5, 3, '2023-07-15', '2025-12-30', 'En ejecución'), -- Presupuesto MTC 2023 (id=8)
                                                                                                                                       ('Mejoramiento del sistema de alcantarillado en Chiclayo', 'Renovación del sistema de alcantarillado en zonas críticas de la ciudad', 6, 5, 1, '2023-08-10', '2024-04-30', 'En ejecución'), -- Presupuesto MVCS 2023 (id=6)
                                                                                                                                       ('Programa Nacional de Tambos', 'Construcción de plataformas de servicios en zonas rurales altoandinas', 9, 5, 1, '2023-02-15', '2025-02-15', 'En ejecución'), -- Presupuesto MIDAGRI 2023 (id=9) ??? Podría ser MIDIS
                                                                                                                                       ('Rehabilitación de la carretera Central tramo Matucana - La Oroya', 'Mejoramiento y ampliación de 120 km de la vía', 8, 5, 3, '2023-03-10', '2024-06-30', 'En ejecución'), -- Presupuesto MTC 2023 (id=8)
                                                                                                                                       ('Electrificación rural en la región Amazonas', 'Proyecto para llevar energía eléctrica a 200 comunidades aisladas', 10, 5, 2, '2023-04-20', '2024-10-15', 'En ejecución'); -- Presupuesto MINAM 2023 (id=10) ??? Debería ser MINEM

-- -----------------------------------------------------
-- Datos para SolicitudAcceso
-- Nota: Ajustar IDs de ciudadano, tipoSolicitud, estadoSolicitud, entidadPublica
-- ciudadanoId: 1-15
-- tipoSolicitudId: 1-10
-- estadoSolicitudId: 1-5
-- entidadPublicaId: 1-20
-- -----------------------------------------------------
INSERT INTO SolicitudAcceso (fechaSolicitud, descripcion, ciudadanoId, tipoSolicitudId, estadoSolicitudId, entidadPublicaId, fechaRespuesta, observaciones) VALUES
                                                                                                                                                                ('2024-01-10', 'Solicitud de información sobre el gasto detallado en la construcción del Hospital Regional de Loreto y estado actual de la obra', 6, 9, 3, 6, '2024-01-25', 'Se proporcionó la información completa dentro del plazo'), -- Ciudadano 6 / Tipo Obra Pub (9) / Estado Atendida (3) / Entidad MVCS (6)
                                                                                                                                                                ('2024-01-15', 'Solicito información sobre los contratos adjudicados para la Reconstrucción con Cambios en Piura durante el periodo 2023', 7, 3, 3, 10, '2024-01-30', 'Se entregó la información dentro del plazo establecido'), -- Ciudadano 7 / Tipo Contrataciones (3) / Estado Atendida (3) / Entidad MINAM (10)? ARCC no está registrada
                                                                                                                                                                ('2024-01-20', 'Requiero información sobre el proceso de selección y contratos de la empresa encargada de la supervisión técnica del proyecto de la Línea 2 del Metro de Lima', 8, 3, 2, 8, NULL, 'En proceso de recopilación por su complejidad'), -- Ciudadano 8 / Tipo Contrataciones (3) / Estado En Proceso (2) / Entidad MTC (8)
                                                                                                                                                                ('2024-01-25', 'Solicito información sobre el presupuesto asignado y ejecutado en 2023 para programas de lucha contra la anemia infantil', 9, 8, 3, 5, '2024-02-08', 'Información proporcionada con estadísticas adicionales'), -- Ciudadano 9 / Tipo Presupuestal (8) / Estado Atendida (3) / Entidad MINSA (5)
                                                                                                                                                                ('2024-02-01', 'Solicito acceso a los expedientes técnicos del proyecto de agua y saneamiento en San Juan de Lurigancho', 10, 9, 4, 6, NULL, 'Se requiere precisar qué componentes específicos del expediente técnico necesita'), -- Ciudadano 10 / Tipo Obra Pub (9) / Estado Observada (4) / Entidad MVCS (6)
                                                                                                                                                                ('2024-02-05', 'Solicito información sobre las contrataciones directas realizadas por el Ministerio de Salud durante la emergencia sanitaria 2020-2022', 1, 3, 1, 5, NULL, 'Pendiente de asignación'), -- Ciudadano 1 / Tipo Contrataciones (3) / Estado Pendiente (1) / Entidad MINSA (5)
                                                                                                                                                                ('2024-02-10', 'Requiero datos sobre la ejecución presupuestal de los fondos asignados a la reconstrucción post Niño Costero en los departamentos del norte', 2, 8, 3, 6, '2024-03-01', 'Se proporcionó la información con un día de retraso por la complejidad'), -- Ciudadano 2 / Tipo Presupuestal (8) / Estado Atendida (3) / Entidad MVCS (6)? ARCC no está
                                                                                                                                                                ('2024-02-15', 'Solicito la relación de funcionarios sancionados por casos de corrupción en los últimos 3 años en el Ministerio de Transportes', 3, 7, 5, 8, '2024-03-01', 'Solicitud rechazada por contener datos personales protegidos'), -- Ciudadano 3 / Tipo RH (7) / Estado Rechazada (5) / Entidad MTC (8)
                                                                                                                                                                ('2024-02-20', 'Requiero información sobre los estudios de impacto ambiental del proyecto minero Tía María', 4, 10, 2, 10, NULL, 'En proceso de consolidación de la información'), -- Ciudadano 4 / Tipo Ambiental (10) / Estado En Proceso (2) / Entidad MINAM (10)
                                                                                                                                                                ('2024-02-25', 'Solicito información sobre los gastos de publicidad estatal realizados por el Ministerio del Interior en el 2023', 5, 8, 1, 7, NULL, 'Recientemente ingresada'); -- Ciudadano 5 / Tipo Presupuestal (8) / Estado Pendiente (1) / Entidad MININTER (7)

-- -----------------------------------------------------
-- Datos para RespuestaSolicitud
-- Nota: solicitudAccesoId debe coincidir con los IDs generados para SolicitudAcceso (1-10)
-- -----------------------------------------------------
INSERT INTO RespuestaSolicitud (solicitudAccesoId, fechaRespuesta, descripcion, archivoAdjunto, usuarioResponsable) VALUES
                                                                                                                        (1, '2024-01-25', 'Se adjunta informe detallado del avance físico y financiero del proyecto Hospital Regional de Loreto, así como las actas de supervisión de obra de los últimos 6 meses. El proyecto presenta un avance físico del 65% y un avance financiero del 58%.', 'informe_hospital_loreto_2023.pdf', 'Carlos Morales - Director de Transparencia MVCS'),
                                                                                                                        (2, '2024-01-30', 'Se remite la relación de contratos adjudicados para la Reconstrucción con Cambios en Piura durante 2023, detallando montos, empresas ganadoras, plazos de ejecución y estado actual de cada obra. Se han ejecutado 35 proyectos por un total de S/ 450 millones.', 'contratos_rcc_piura_2023.xlsx', 'Sandra Pacheco - Oficina de Acceso a la Información ARCC'),
                                                                                                                        (4, '2024-02-08', 'Se adjunta informe de la Dirección de Intervenciones Estratégicas con el presupuesto asignado y ejecutado en 2023 para programas de lucha contra anemia infantil. Se destinaron S/ 350 millones logrando reducir la prevalencia de anemia en 3.5 puntos porcentuales a nivel nacional.', 'presupuesto_anemia_2023.pdf', 'Dr. Eduardo Sánchez - Director de Transparencia MINSA'),
                                                                                                                        (7, '2024-03-01', 'Se remite información consolidada sobre la ejecución presupuestal de los fondos de reconstrucción en Piura, Lambayeque, La Libertad y Tumbes. El informe incluye los proyectos priorizados, montos transferidos y porcentajes de avance por región.', 'ejecucion_reconstruccion_2023.pdf', 'Ing. Luis Velásquez - Autoridad para la Reconstrucción con Cambios');

-- -----------------------------------------------------
-- Datos para Gasto
-- Nota: Ajustar presupuestoId, proyectoId, categoriaGastoId
-- presupuestoId: 1-34
-- proyectoId: 1-15
-- categoriaGastoId: 1-5
-- -----------------------------------------------------
INSERT INTO Gasto (concepto, monto, fecha, presupuestoId, proyectoId, categoriaGastoId) VALUES
                                                                                            ('Adquisición de equipamiento médico para el Hospital Regional de Loreto', 15000000.00, '2023-09-15', 6, 10, 3), -- Presupuesto MVCS 2023 (id=6) / Proyecto Hosp Loreto (id=10) / Cat Bienes/Serv (id=3)
                                                                                            ('Materiales de construcción para el sistema de agua potable en SJL', 8500000.00, '2023-05-20', 6, 6, 5), -- Presupuesto MVCS 2023 (id=6) / Proyecto Agua SJL (id=6) / Cat Inv Pub (id=5)
                                                                                            ('Pago a contratista por avance de obra - Hospital Regional Loreto', 25000000.00, '2023-10-10', 6, 10, 5), -- Presupuesto MVCS 2023 (id=6) / Proyecto Hosp Loreto (id=10) / Cat Inv Pub (id=5)
                                                                                            ('Adquisición de tuberías y accesorios para sistema de agua SJL', 4800000.00, '2023-06-30', 6, 6, 3), -- Presupuesto MVCS 2023 (id=6) / Proyecto Agua SJL (id=6) / Cat Bienes/Serv (id=3)
                                                                                            ('Pago por servicios de consultoría y supervisión - SJL', 1200000.00, '2023-07-15', 6, 6, 3), -- Presupuesto MVCS 2023 (id=6) / Proyecto Agua SJL (id=6) / Cat Bienes/Serv (id=3)
                                                                                            ('Adquisición de materiales para reconstrucción de colegios en Piura', 6500000.00, '2023-05-10', 7, 7, 5), -- Presupuesto MININTER 2023 (id=7)?? / Proyecto Colegios Piura (id=7) / Cat Inv Pub (id=5)
                                                                                            ('Pago a contratista por avance de obra - Colegios Piura', 12000000.00, '2023-08-25', 7, 7, 5), -- Presupuesto MININTER 2023 (id=7)?? / Proyecto Colegios Piura (id=7) / Cat Inv Pub (id=5)
                                                                                            ('Equipamiento educativo para colegios reconstruidos', 3800000.00, '2023-11-05', 7, 7, 3), -- Presupuesto MININTER 2023 (id=7)?? / Proyecto Colegios Piura (id=7) / Cat Bienes/Serv (id=3)
                                                                                            ('Servicios de supervisión técnica - Colegios Piura', 950000.00, '2023-07-20', 7, 7, 3), -- Presupuesto MININTER 2023 (id=7)?? / Proyecto Colegios Piura (id=7) / Cat Bienes/Serv (id=3)
                                                                                            ('Asfalto y materiales para carretera Cusco-Quillabamba', 18500000.00, '2023-06-15', 8, 8, 5), -- Presupuesto MTC 2023 (id=8) / Proyecto Carretera C-Q (id=8) / Cat Inv Pub (id=5)
                                                                                            ('Maquinaria pesada para obra vial Cusco-Quillabamba', 7800000.00, '2023-07-05', 8, 8, 3), -- Presupuesto MTC 2023 (id=8) / Proyecto Carretera C-Q (id=8) / Cat Bienes/Serv (id=3)
                                                                                            ('Servicios de consultoría ambiental - Carretera Cusco-Quillabamba', 1500000.00, '2023-05-15', 8, 8, 3), -- Presupuesto MTC 2023 (id=8) / Proyecto Carretera C-Q (id=8) / Cat Bienes/Serv (id=3)
                                                                                            ('Elaboración de estudios de ingeniería - Metro de Lima extensión', 5200000.00, '2023-08-15', 8, 11, 3); -- Presupuesto MTC 2023 (id=8) / Proyecto Metro L1 (id=11) / Cat Bienes/Serv (id=3)

-- =========================================
-- PROCEDIMIENTOS ALMACENADOS (Gestión de Usuarios Internos)
-- =========================================

-- Procedimiento almacenado para registrar persona
DELIMITER $$
CREATE PROCEDURE sp_registrar_persona(
    IN p_nombre_completo VARCHAR (45),
    IN p_correo VARCHAR (45),
    IN p_dni VARCHAR (45),
    IN p_genero VARCHAR (45),
    IN p_fech_nac DATE
)
BEGIN
INSERT INTO persona (nombre_completo, correo, dni, genero, fech_nac)
VALUES (p_nombre_completo, p_correo, p_dni, p_genero, p_fech_nac);
END $$
DELIMITER ;

-- Procedimiento almacenado para registrar usuario
DELIMITER $$
CREATE PROCEDURE sp_registrar_usuario(
    IN p_cod_usuario VARCHAR (45),
    IN p_id_persona INT,
    IN p_id_rol INT,
    IN p_clave VARCHAR (255) -- Acepta clave en texto plano para hashearla aquí (o ya hasheada)
)
BEGIN
    -- Aquí se debería hashear la clave antes de insertarla. Ejemplo simple:
    -- DECLARE hashed_clave VARCHAR(255);
    -- SET hashed_clave = SHA2(p_clave, 256); -- O el método de hash preferido
    -- INSERT INTO usuario (cod_usuario, id_persona, id_rol, clave)
    -- VALUES (p_cod_usuario, p_id_persona, p_id_rol, hashed_clave);

    -- Inserción directa (asumiendo que p_clave ya viene hasheada o para prueba)
INSERT INTO usuario (cod_usuario, id_persona, id_rol, clave)
VALUES (p_cod_usuario, p_id_persona, p_id_rol, p_clave);
END $$
DELIMITER ;

-- Procedimiento para autenticar usuario
DELIMITER $$
CREATE PROCEDURE sp_autenticar_usuario(
    IN p_cod_usuario VARCHAR (45),
    IN p_clave VARCHAR (255) -- Clave en texto plano ingresada por el usuario
)
BEGIN
    -- Aquí se compararía el hash almacenado con el hash de la clave ingresada
    -- DECLARE stored_hash VARCHAR(255);
    -- SELECT clave INTO stored_hash FROM usuario WHERE cod_usuario = p_cod_usuario;
    -- IF stored_hash IS NOT NULL AND stored_hash = SHA2(p_clave, 256) THEN
    --      SELECT ... (datos del usuario)
    -- ELSE
    --      SELECT NULL; -- O un indicador de fallo
    -- END IF;

    -- Comparación directa (para prueba, NO seguro en producción)
SELECT u.id_usuario,
       u.cod_usuario,
       p.nombre_completo,
       r.cod_rol,
       r.descrip_rol
FROM usuario u
         INNER JOIN persona p ON u.id_persona = p.id_persona
         INNER JOIN rol r ON u.id_rol = r.id_rol
WHERE u.cod_usuario = p_cod_usuario
  AND u.clave = p_clave; -- Comparación directa insegura
END $$
DELIMITER ;

-- Procedimiento para autenticar ciudadano
DELIMITER $$
CREATE PROCEDURE sp_autenticar_ciudadano(
    IN p_correo VARCHAR(100),
    IN p_password VARCHAR(255) -- O DNI si prefieres autenticar por DNI
)
BEGIN
SELECT id, nombres, apellidos, dni, correo, telefono, direccion, fechaRegistro
FROM Ciudadano
WHERE correo = p_correo AND password = p_password;
END $$
DELIMITER ;

-- Procedimiento para registrar un nuevo ciudadano
DELIMITER $$
CREATE PROCEDURE sp_registrar_ciudadano(
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_dni VARCHAR(15),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_direccion VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
INSERT INTO Ciudadano (nombres, apellidos, dni, correo, telefono, direccion, fechaRegistro, password)
VALUES (p_nombres, p_apellidos, p_dni, p_correo, p_telefono, p_direccion, CURDATE(), p_password);
END $$
DELIMITER ;


-- Procedimiento para obtener todos los usuarios con sus roles
DELIMITER $$
CREATE PROCEDURE sp_listar_usuarios()
BEGIN
SELECT u.id_usuario,
       u.cod_usuario,
       p.nombre_completo,
       p.correo,
       p.dni,
       r.descrip_rol
FROM usuario u
         INNER JOIN persona p ON u.id_persona = p.id_persona
         INNER JOIN rol r ON u.id_rol = r.id_rol
ORDER BY u.id_usuario;
END $$
DELIMITER ;

-- =========================================
-- FIN DEL SCRIPT
-- =========================================

SELECT 'Script ejecutado completamente.' AS Estado;