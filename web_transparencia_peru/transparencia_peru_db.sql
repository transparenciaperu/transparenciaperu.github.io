-- filepath: d:\PROYECTOS-CIBERTEC\Lenguaje_de_Programacion_1\intellij_idea\transparenciaperu.github.io\web_transparencia_peru\transparencia_peru_db_modificado.sql
-- ==================================================================
-- Script completo de la base de datos para el Portal de Transparencia Perú
-- Versión Actualizada
-- Incluye todas las tablas, procedimientos almacenados y datos de prueba.
-- Adaptado para el enfoque de niveles de gobierno (Nacional, Regional, Municipal)
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
-- Tabla NivelGobierno
-- -----------------------------------------------------
CREATE TABLE NivelGobierno (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               nombre VARCHAR(100) NOT NULL UNIQUE, -- Nacional, Regional, Municipal
                               descripcion TEXT
);

-- -----------------------------------------------------
-- Tabla Region
-- -----------------------------------------------------
CREATE TABLE Region (
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
                                tipo VARCHAR(100) NOT NULL, -- Ministerio, Gobierno Regional, Municipalidad Provincial, Municipalidad Distrital, etc.
                                nivelGobiernoId INT NOT NULL, -- Nacional, Regional, Municipal
                                regionId INT, -- Región donde se ubica (puede ser null si es Nacional)
                                direccion VARCHAR(255),
                                telefono VARCHAR(20),
                                email VARCHAR(100),
                                sitioWeb VARCHAR(255),
                                FOREIGN KEY (nivelGobiernoId) REFERENCES NivelGobierno(id),
                                FOREIGN KEY (regionId) REFERENCES Region(id)
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
-- Tabla TipoGasto
-- -----------------------------------------------------
CREATE TABLE TipoGasto (
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
                          tipoGastoId INT NOT NULL, -- Usualmente 'Inversión Pública'
                          fuenteFinanciamientoId INT,
                          fechaInicio DATE,
                          fechaFin DATE,
                          estado VARCHAR(50), -- Ej: Planificado, En ejecución, Finalizado, Paralizado
                          FOREIGN KEY (presupuestoId) REFERENCES Presupuesto(id),
                          FOREIGN KEY (tipoGastoId) REFERENCES TipoGasto(id),
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
                       tipoGastoId INT NOT NULL, -- Categoría específica del gasto (Bienes, Servicios, etc.)
                       FOREIGN KEY (presupuestoId) REFERENCES Presupuesto(id),
                       FOREIGN KEY (proyectoId) REFERENCES Proyecto(id),
                       FOREIGN KEY (tipoGastoId) REFERENCES TipoGasto(id)
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
                           password VARCHAR(255) NOT NULL -- Hash de la contraseña
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
CREATE TABLE persona (
                         id_persona INT PRIMARY KEY AUTO_INCREMENT,
                         nombre_completo VARCHAR(45),
                         correo VARCHAR(45) UNIQUE,
                         dni VARCHAR(45) UNIQUE,
                         genero VARCHAR(45),
                         fech_nac DATE
);

-- Tabla: rol
CREATE TABLE rol (
                     id_rol INT PRIMARY KEY AUTO_INCREMENT,
                     cod_rol VARCHAR(45) UNIQUE,
                     descrip_rol VARCHAR(100)
);

-- Tabla: usuario (Usuarios internos del sistema)
CREATE TABLE usuario (
                         id_usuario INT PRIMARY KEY AUTO_INCREMENT,
                         cod_usuario VARCHAR(45) UNIQUE,
                         id_persona INT,
                         id_rol INT,
                         clave VARCHAR(255), -- Hash de clave
                         FOREIGN KEY (id_persona) REFERENCES persona (id_persona),
                         FOREIGN KEY (id_rol) REFERENCES rol (id_rol)
);

-- =========================================
-- INSERCIÓN DE DATOS DE PRUEBA
-- =========================================

-- -----------------------------------------------------
-- Datos para NivelGobierno
-- -----------------------------------------------------
INSERT INTO NivelGobierno (nombre, descripcion) VALUES
                                                    ('Nacional', 'Entidades del gobierno central, ministerios y organismos nacionales'),
                                                    ('Regional', 'Gobiernos regionales de las 25 regiones del Perú'),
                                                    ('Municipal', 'Municipalidades provinciales y distritales');

-- -----------------------------------------------------
-- Datos para Region (antes Departamento)
-- -----------------------------------------------------
INSERT INTO Region (nombre, codigo) VALUES
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
-- Datos para rol (Usuarios internos)
-- -----------------------------------------------------
INSERT INTO rol (cod_rol, descrip_rol) VALUES
                                           ('ADMIN', 'Administrador con acceso total al sistema'),
                                           ('FUNCIONARIO', 'Funcionario encargado de la gestión de transparencia y solicitudes');

-- -----------------------------------------------------
-- Datos para persona (Usuarios internos del sistema)
-- -----------------------------------------------------
INSERT INTO persona (nombre_completo, correo, dni, genero, fech_nac) VALUES
                                                                         ('Admin Sistema', 'admin@transparencia.gob.pe', '00000001', 'M', '1980-01-15'),
                                                                         ('Juan Funcionario Pérez', 'jfuncionario@transparencia.gob.pe', '45678912', 'M', '1985-05-20'),
                                                                         ('María Funcionario López', 'mfuncionario@transparencia.gob.pe', '32165498', 'F', '1990-10-25'),
                                                                         ('Carlos Funcionario Rodríguez', 'cfuncionario@transparencia.gob.pe', '78945612', 'M', '1988-03-12'),
                                                                         ('Ana Funcionario González', 'afuncionario@transparencia.gob.pe', '65432198', 'F', '1992-07-08');

-- -----------------------------------------------------
-- Datos para usuario (Usuarios internos del sistema)
-- -----------------------------------------------------
INSERT INTO usuario (cod_usuario, id_persona, id_rol, clave) VALUES
                                                                 ('admin', 1, 1, '123456'), -- Admin: clave=123456
                                                                 ('jfuncionario', 2, 2, '654321'), -- Funcionario: clave=654321
                                                                 ('mfuncionario', 3, 2, 'password'), -- Funcionario: clave=password
                                                                 ('cfuncionario', 4, 2, 'password123'), -- Funcionario: clave=password123
                                                                 ('afuncionario', 5, 2, '123password'); -- Funcionario: clave=123password

-- -----------------------------------------------------
-- Datos para EntidadPublica
-- -----------------------------------------------------
INSERT INTO EntidadPublica (nombre, tipo, nivelGobiernoId, regionId, direccion, telefono, email, sitioWeb) VALUES
-- Entidades Nacionales
('Ministerio de Economía y Finanzas', 'Ministerio', 1, 1, 'Jr. Junín 319, Cercado de Lima', '01-3115930', 'contacto@mef.gob.pe', 'www.mef.gob.pe'),
('Ministerio de Educación', 'Ministerio', 1, 1, 'Calle Del Comercio 193, San Borja', '01-6155800', 'contacto@minedu.gob.pe', 'www.gob.pe/minedu'),
('Ministerio de Salud', 'Ministerio', 1, 1, 'Av. Salaverry 801, Jesús María', '01-3156600', 'contacto@minsa.gob.pe', 'www.gob.pe/minsa'),
('Ministerio de Vivienda, Construcción y Saneamiento', 'Ministerio', 1, 1, 'Av. Paseo de la República 3361, San Isidro', '01-2117930', 'contacto@vivienda.gob.pe', 'www.gob.pe/vivienda'),
('Ministerio del Interior', 'Ministerio', 1, 1, 'Plaza 30 de Agosto s/n Urb. Corpac, San Isidro', '01-5182800', 'contacto@mininter.gob.pe', 'www.gob.pe/mininter'),
('Ministerio de Transportes y Comunicaciones', 'Ministerio', 1, 1, 'Jr. Zorritos 1203, Lima', '01-6157800', 'atencionalciudadano@mtc.gob.pe', 'www.gob.pe/mtc'),
('Ministerio de Desarrollo Agrario y Riego', 'Ministerio', 1, 1, 'Av. La Universidad 200, La Molina', '01-2098800', 'contacto@midagri.gob.pe', 'www.gob.pe/midagri'),
('Ministerio del Ambiente', 'Ministerio', 1, 1, 'Av. Antonio Miroquesada 425, Magdalena del Mar', '01-6116000', 'webmaster@minam.gob.pe', 'www.gob.pe/minam'),
('OSINERGMIN', 'Organismo Supervisor', 1, 1, 'Calle Bernardo Monteagudo 222, Magdalena del Mar', '01-2193400', 'atencionalcliente@osinergmin.gob.pe', 'www.gob.pe/osinergmin'),
('SUNASS', 'Organismo Supervisor', 1, 1, 'Av. Bernardo Monteagudo 210, Magdalena del Mar', '01-6143180', 'contacto@sunass.gob.pe', 'www.gob.pe/sunass'),

-- Entidades Regionales
('Gobierno Regional de Arequipa', 'Gobierno Regional', 2, 2, 'Av. Unión 200, Arequipa', '054-382860', 'contacto@regionarequipa.gob.pe', 'www.regionarequipa.gob.pe'),
('Gobierno Regional de Cusco', 'Gobierno Regional', 2, 3, 'Av. Tomasa Tito Condemayta s/n, Cusco', '084-221131', 'contacto@regioncusco.gob.pe', 'www.regioncusco.gob.pe'),
('Gobierno Regional de La Libertad', 'Gobierno Regional', 2, 4, 'Jr. Los Brillantes 650, Urb. Santa Inés, Trujillo', '044-604000', 'contacto@regionlalibertad.gob.pe', 'www.regionlalibertad.gob.pe'),
('Gobierno Regional de Piura', 'Gobierno Regional', 2, 5, 'Av. San Ramón s/n, Urb. San Eduardo, Piura', '073-284600', 'contacto@regionpiura.gob.pe', 'www.regionpiura.gob.pe'),
('Gobierno Regional de Lima', 'Gobierno Regional', 2, 1, 'Av. Circunvalación S/N, Huacho', '01-2321200', 'contacto@regionlima.gob.pe', 'www.regionlima.gob.pe'),
('Gobierno Regional de Loreto', 'Gobierno Regional', 2, 17, 'Av. Abelardo Quiñones Km 1.5, Iquitos', '065-267010', 'contacto@regionloreto.gob.pe', 'www.regionloreto.gob.pe'),
('Gobierno Regional de Puno', 'Gobierno Regional', 2, 21, 'Jr. Deustua 356, Puno', '051-354000', 'contacto@regionpuno.gob.pe', 'www.regionpuno.gob.pe'),
('Gobierno Regional de Lambayeque', 'Gobierno Regional', 2, 16, 'Av. Juan Tomis Stack 975, Chiclayo', '074-606060', 'contacto@regionlambayeque.gob.pe', 'www.regionlambayeque.gob.pe'),

-- Entidades Municipales
('Municipalidad Provincial de Lima', 'Municipalidad Provincial', 3, 1, 'Jr. de la Unión 300, Lima', '01-6321300', 'contacto@munlima.gob.pe', 'www.munlima.gob.pe'),
('Municipalidad Provincial de Arequipa', 'Municipalidad Provincial', 3, 2, 'Plaza de Armas s/n, Arequipa', '054-380050', 'contacto@muniarequipa.gob.pe', 'www.muniarequipa.gob.pe'),
('Municipalidad Provincial de Cusco', 'Municipalidad Provincial', 3, 3, 'Plaza Regocijo s/n, Cusco', '084-226701', 'contacto@municusco.gob.pe', 'www.cusco.gob.pe'),
('Municipalidad Provincial de Trujillo', 'Municipalidad Provincial', 3, 4, 'Jr. Pizarro 412, Trujillo', '044-484242', 'contacto@munitrujillo.gob.pe', 'www.munitrujillo.gob.pe'),
('Municipalidad Provincial de Piura', 'Municipalidad Provincial', 3, 5, 'Jr. Ayacucho 377, Piura', '073-304000', 'contacto@munipiura.gob.pe', 'www.munipiura.gob.pe'),
('Municipalidad Distrital de Miraflores', 'Municipalidad Distrital', 3, 1, 'Av. Larco 400, Miraflores', '01-6177272', 'contacto@miraflores.gob.pe', 'www.miraflores.gob.pe'),
('Municipalidad Distrital de San Isidro', 'Municipalidad Distrital', 3, 1, 'Av. República de Panamá 3505, San Isidro', '01-5139000', 'contacto@munisanisidro.gob.pe', 'www.msi.gob.pe'),
('Municipalidad Distrital de San Juan de Lurigancho', 'Municipalidad Distrital', 3, 1, 'Jr. Los Amautas 180, Zárate', '01-4580838', 'contacto@munisjl.gob.pe', 'www.munisjl.gob.pe'),
('Municipalidad Distrital de Santiago de Surco', 'Municipalidad Distrital', 3, 1, 'Av. Juan Antonio Pezet 120, Santiago de Surco', '01-4116480', 'contacto@munisurco.gob.pe', 'www.munisurco.gob.pe'),
('Municipalidad Distrital de La Molina', 'Municipalidad Distrital', 3, 1, 'Av. Elías Aparicio 740, La Molina', '01-3130300', 'contacto@munimolina.gob.pe', 'www.munimolina.gob.pe');

-- -----------------------------------------------------
-- Datos para PeriodoFiscal
-- -----------------------------------------------------
INSERT INTO PeriodoFiscal (anio, fechaInicio, fechaFin, estado) VALUES
                                                                    (2022, '2022-01-01', '2022-12-31', 'Cerrado'),
                                                                    (2023, '2023-01-01', '2023-12-31', 'Cerrado'),
                                                                    (2024, '2024-01-01', '2024-12-31', 'Activo'),
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
-- Datos para TipoGasto (antes CategoriaGasto)
-- -----------------------------------------------------
INSERT INTO TipoGasto (nombre, descripcion) VALUES
                                                ('Personal y Obligaciones Sociales', 'Gastos por el pago del personal activo del sector público'),
                                                ('Pensiones y Prestaciones Sociales', 'Gastos por el pago de pensiones'),
                                                ('Bienes y Servicios', 'Gastos por adquisición de bienes y contratación de servicios'),
                                                ('Donaciones y Transferencias', 'Gastos por donaciones y transferencias a instituciones'),
                                                ('Inversión Pública', 'Gastos destinados a proyectos de inversión pública');

-- -----------------------------------------------------
-- Datos para Presupuesto (por nivel de gobierno)
-- -----------------------------------------------------

-- Presupuestos del nivel Nacional (2024)
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion) VALUES
-- Ministerios (entidades 1-8)
(2024, 42500000000.00, 1, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio de Economía y Finanzas'),
(2024, 32580000000.00, 2, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio de Educación'),
(2024, 24300000000.00, 3, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio de Salud'),
(2024, 8150000000.00, 4, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio de Vivienda, Construcción y Saneamiento'),
(2024, 10150000000.00, 5, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio del Interior'),
(2024, 9250000000.00, 6, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio de Transportes y Comunicaciones'),
(2024, 4250000000.00, 7, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio de Desarrollo Agrario y Riego'),
(2024, 1450000000.00, 8, 3, '2023-12-15', 'Presupuesto anual 2024 del Ministerio del Ambiente');

-- Presupuestos del nivel Regional (2024)
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion) VALUES
-- Gobiernos Regionales (entidades 11-18)
(2024, 1450000000.00, 11, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Arequipa'),
(2024, 1650000000.00, 12, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Cusco'),
(2024, 1550000000.00, 13, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de La Libertad'),
(2024, 1350000000.00, 14, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Piura'),
(2024, 2250000000.00, 15, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Lima'),
(2024, 1750000000.00, 16, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Loreto'),
(2024, 1350000000.00, 17, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Puno'),
(2024, 1550000000.00, 18, 3, '2023-12-15', 'Presupuesto anual 2024 del Gobierno Regional de Lambayeque');

-- Presupuestos del nivel Municipal (2024)
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion) VALUES
-- Municipalidades Provinciales (entidades 19-23)
(2024, 2050000000.00, 19, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Provincial de Lima'),
(2024, 850000000.00, 20, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Provincial de Arequipa'),
(2024, 950000000.00, 21, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Provincial de Cusco'),
(2024, 780000000.00, 22, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Provincial de Trujillo'),
(2024, 680000000.00, 23, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Provincial de Piura'),

-- Municipalidades Distritales (entidades 24-28)
(2024, 450000000.00, 24, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Distrital de Miraflores'),
(2024, 520000000.00, 25, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Distrital de San Isidro'),
(2024, 650000000.00, 26, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Distrital de San Juan de Lurigancho'),
(2024, 480000000.00, 27, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Distrital de Santiago de Surco'),
(2024, 380000000.00, 28, 3, '2023-12-15', 'Presupuesto anual 2024 de la Municipalidad Distrital de La Molina');

-- Datos históricos para 2023 (Algunos ejemplos)
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion) VALUES
-- Nacional
(2023, 40200000000.00, 1, 2, '2022-12-15', 'Presupuesto anual 2023 del Ministerio de Economía y Finanzas'),
(2023, 30500000000.00, 2, 2, '2022-12-15', 'Presupuesto anual 2023 del Ministerio de Educación'),
(2023, 22800000000.00, 3, 2, '2022-12-15', 'Presupuesto anual 2023 del Ministerio de Salud'),

-- Regional
(2023, 1350000000.00, 11, 2, '2022-12-15', 'Presupuesto anual 2023 del Gobierno Regional de Arequipa'),
(2023, 1550000000.00, 12, 2, '2022-12-15', 'Presupuesto anual 2023 del Gobierno Regional de Cusco'),

-- Municipal
(2023, 1950000000.00, 19, 2, '2022-12-15', 'Presupuesto anual 2023 de la Municipalidad Provincial de Lima'),
(2023, 780000000.00, 20, 2, '2022-12-15', 'Presupuesto anual 2023 de la Municipalidad Provincial de Arequipa');

-- -----------------------------------------------------
-- Datos para Proyecto
-- -----------------------------------------------------
INSERT INTO Proyecto (nombre, descripcion, presupuestoId, tipoGastoId, fuenteFinanciamientoId, fechaInicio, fechaFin, estado) VALUES
-- Proyectos de Nivel Nacional
('Ampliación del sistema de agua potable en zonas urbano-marginales', 'Proyecto para mejorar el acceso al agua potable para más de 100,000 familias en zonas periurbanas', 4, 5, 1, '2024-03-15', '2025-08-30', 'En ejecución'),
('Programa Nacional de Infraestructura Educativa', 'Construcción y mejoramiento de 500 instituciones educativas a nivel nacional', 2, 5, 1, '2024-02-15', '2026-12-30', 'En ejecución'),
('Modernización de hospitales regionales', 'Equipamiento y mejora de 25 hospitales regionales a nivel nacional', 3, 5, 3, '2024-04-10', '2025-10-15', 'En ejecución'),
('Mejoramiento de la red vial nacional', 'Rehabilitación y mantenimiento de 1,500 km de carreteras nacionales', 6, 5, 1, '2024-03-01', '2025-09-30', 'En ejecución'),
('Programa de reforestación de áreas naturales protegidas', 'Reforestación de 20,000 hectáreas en zonas de amortiguamiento', 8, 5, 4, '2024-04-05', '2026-04-05', 'En ejecución'),

-- Proyectos de Nivel Regional
('Construcción de Hospital Regional de Arequipa', 'Proyecto para la construcción de un hospital regional en Arequipa con capacidad para 350 camas', 9, 5, 1, '2024-03-15', '2026-06-30', 'En ejecución'),
('Mejoramiento de riego en la región Cusco', 'Implementación de sistemas de riego tecnificado en 15 distritos de la región', 10, 5, 2, '2024-05-10', '2025-11-30', 'En ejecución'),
('Construcción de colegios en zonas rurales de La Libertad', 'Edificación de 12 colegios en distritos rurales de la región', 11, 5, 1, '2024-03-01', '2025-06-30', 'En ejecución'),
('Reconstrucción con cambios en Piura', 'Obras de prevención y reconstrucción en zonas afectadas por fenómenos naturales', 12, 5, 3, '2024-02-15', '2025-08-30', 'En ejecución'),
('Mejoramiento de la carretera intrarregional Lima-Cañete', 'Rehabilitación y ampliación de 120 km de vía', 13, 5, 1, '2024-04-15', '2025-10-30', 'En ejecución'),

-- Proyectos de Nivel Municipal (Provincial)
('Implementación del sistema integrado de transporte en Lima', 'Modernización del sistema de transporte público en la capital', 19, 5, 3, '2024-06-01', '2026-06-30', 'En ejecución'),
('Construcción del nuevo terminal terrestre de Arequipa', 'Edificación del terminal en el distrito de Cerro Colorado', 20, 5, 2, '2024-05-15', '2025-11-30', 'En ejecución'),
('Puesta en valor del centro histórico de Cusco', 'Restauración y mejoramiento de calles y plazas históricas', 21, 5, 5, '2024-03-20', '2025-12-15', 'En ejecución'),
('Ampliación del sistema de alcantarillado en Trujillo', 'Mejoramiento de la cobertura de saneamiento en distritos periféricos', 22, 5, 1, '2024-04-10', '2025-10-15', 'En ejecución'),

-- Proyectos de Nivel Municipal (Distrital)
('Parque recreativo ecológico en Miraflores', 'Construcción de espacios verdes y zonas recreativas', 24, 5, 2, '2024-05-01', '2025-01-30', 'En ejecución'),
('Mejoramiento de pistas y veredas en San Isidro', 'Rehabilitación de vías en sectores 1, 2 y 3 del distrito', 25, 5, 2, '2024-03-15', '2024-09-30', 'En ejecución'),
('Construcción de centro cultural en San Juan de Lurigancho', 'Edificación de un complejo cultural con biblioteca, auditorio y talleres', 26, 5, 3, '2024-07-15', '2025-12-30', 'En ejecución'),
('Ampliación de sistema de videovigilancia en Surco', 'Instalación de 200 cámaras de seguridad integradas al centro de monitoreo', 27, 5, 2, '2024-03-10', '2024-12-15', 'En ejecución');

-- -----------------------------------------------------
-- Datos para Ciudadano (Usuarios ciudadanos)
-- -----------------------------------------------------
INSERT INTO Ciudadano (nombres, apellidos, dni, correo, telefono, direccion, fechaRegistro, password) VALUES
                                                                                                          ('Juan', 'Pérez López', '12345678', 'juan.perez@gmail.com', '987654321', 'Av. Arequipa 123, Lima', '2023-01-10', '12345678'),
                                                                                                          ('María', 'García Rodríguez', '87654321', 'maria.garcia@hotmail.com', '912345678', 'Jr. Huancayo 456, Arequipa', '2023-02-05', '87654321'),
                                                                                                          ('Carlos', 'López Sánchez', '23456789', 'carlos.lopez@gmail.com', '945678123', 'Calle Los Pinos 789, Cusco', '2023-03-12', '23456789'),
                                                                                                          ('Ana', 'Martínez Torres', '98765432', 'ana.martinez@gmail.com', '978123456', 'Av. La Marina 567, Lima', '2023-04-18', '98765432'),
                                                                                                          ('Pedro', 'Ramírez Flores', '34567890', 'pedro.ramirez@hotmail.com', '956781234', 'Jr. Tacna 890, La Libertad', '2023-05-22', '34567890'),
                                                                                                          ('Roberto', 'Sánchez Mendoza', '45673829', 'roberto.sanchez@gmail.com', '987123456', 'Av. La Paz 452, Miraflores, Lima', '2024-01-15', '45673829'),
                                                                                                          ('María Luisa', 'Paredes Torres', '09876543', 'mluisa.paredes@hotmail.com', '941236547', 'Jr. Amazonas 1234, Trujillo', '2024-01-20', '09876543'),
                                                                                                          ('Jorge Luis', 'Vargas Mendoza', '72145639', 'jvargas@gmail.com', '932568741', 'Calle Los Pinos 328, Arequipa', '2024-02-05', '72145639'),
                                                                                                          ('Carmen Rosa', 'Huamán Quispe', '43215678', 'chuaman@gmail.com', '912345678', 'Av. Sol 340, Cusco', '2024-02-10', '43215678'),
                                                                                                          ('Miguel Ángel', 'Rodríguez Pérez', '25631478', 'marodriguez@outlook.com', '963258741', 'Av. José Pardo 450, Chimbote', '2024-02-15', '25631478');

-- -----------------------------------------------------
-- Datos para TipoSolicitud
-- -----------------------------------------------------
INSERT INTO TipoSolicitud (nombre, descripcion) VALUES
                                                    ('Información Presupuestal', 'Solicitud de información sobre presupuestos públicos'),
                                                    ('Información de Proyectos', 'Solicitud de información sobre proyectos de inversión'),
                                                    ('Información de Contrataciones', 'Solicitud de información sobre contrataciones públicas'),
                                                    ('Información de Personal', 'Solicitud de información sobre personal de entidades públicas'),
                                                    ('Información General', 'Solicitud de información general sobre entidades públicas'),
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
-- Datos para SolicitudAcceso
-- -----------------------------------------------------
INSERT INTO SolicitudAcceso (fechaSolicitud, descripcion, ciudadanoId, tipoSolicitudId, estadoSolicitudId, entidadPublicaId, fechaRespuesta, observaciones) VALUES
                                                                                                                                                                ('2024-01-10', 'Solicitud de información sobre el gasto detallado en la construcción del Hospital Regional de Arequipa', 1, 2, 3, 11, '2024-01-25', 'Se proporcionó la información completa dentro del plazo'),
                                                                                                                                                                ('2024-01-15', 'Solicito información sobre los contratos adjudicados para la Reconstrucción con Cambios en Piura durante el periodo 2024', 2, 3, 3, 14, '2024-01-30', 'Se entregó la información dentro del plazo establecido'),
                                                                                                                                                                ('2024-01-20', 'Requiero información sobre el proceso de selección y contratos de la empresa encargada de la supervisión técnica del proyecto de transporte de Lima', 3, 3, 2, 19, NULL, 'En proceso de recopilación por su complejidad'),
                                                                                                                                                                ('2024-01-25', 'Solicito información sobre el presupuesto asignado y ejecutado en 2024 para programas de lucha contra la anemia infantil', 4, 1, 3, 3, '2024-02-08', 'Información proporcionada con estadísticas adicionales'),
                                                                                                                                                                ('2024-02-01', 'Solicito acceso a los expedientes técnicos del proyecto de agua y saneamiento en San Juan de Lurigancho', 5, 2, 4, 26, NULL, 'Se requiere precisar qué componentes específicos del expediente técnico necesita'),
                                                                                                                                                                ('2024-02-05', 'Solicito información sobre las contrataciones directas realizadas por el Ministerio de Salud durante la emergencia sanitaria', 6, 3, 1, 3, NULL, 'Pendiente de asignación'),
                                                                                                                                                                ('2024-02-10', 'Requiero datos sobre la ejecución presupuestal de los fondos asignados a la reconstrucción post Niño Costero', 7, 1, 3, 14, '2024-03-01', 'Se proporcionó la información con un día de retraso por la complejidad'),
                                                                                                                                                                ('2024-02-15', 'Solicito la relación de funcionarios sancionados por casos de corrupción en los últimos 3 años en el Ministerio de Transportes', 8, 4, 5, 6, '2024-03-01', 'Solicitud rechazada por contener datos personales protegidos'),
                                                                                                                                                                ('2024-02-20', 'Requiero información sobre los estudios de impacto ambiental del proyecto minero Tía María', 9, 6, 2, 8, NULL, 'En proceso de consolidación de la información'),
                                                                                                                                                                ('2024-02-25', 'Solicito información sobre los gastos de publicidad estatal realizados por el Ministerio del Interior en el 2024', 10, 1, 1, 5, NULL, 'Recientemente ingresada');

-- -----------------------------------------------------
-- Datos para RespuestaSolicitud
-- -----------------------------------------------------
INSERT INTO RespuestaSolicitud (solicitudAccesoId, fechaRespuesta, descripcion, archivoAdjunto, usuarioResponsable) VALUES
                                                                                                                        (1, '2024-01-25', 'Se adjunta informe detallado del avance físico y financiero del proyecto Hospital Regional de Arequipa, así como las actas de supervisión de obra de los últimos 6 meses. El proyecto presenta un avance físico del 65% y un avance financiero del 58%.', 'informe_hospital_arequipa_2024.pdf', 'Carlos Morales - Director de Transparencia GRA'),
                                                                                                                        (2, '2024-01-30', 'Se remite la relación de contratos adjudicados para la Reconstrucción con Cambios en Piura durante 2024, detallando montos, empresas ganadoras, plazos de ejecución y estado actual de cada obra. Se han ejecutado 35 proyectos por un total de S/ 450 millones.', 'contratos_rcc_piura_2024.xlsx', 'Sandra Pacheco - Oficina de Acceso a la Información GRP'),
                                                                                                                        (4, '2024-02-08', 'Se adjunta informe de la Dirección de Intervenciones Estratégicas con el presupuesto asignado y ejecutado en 2024 para programas de lucha contra anemia infantil. Se destinaron S/ 350 millones logrando reducir la prevalencia de anemia en 3.5 puntos porcentuales a nivel nacional.', 'presupuesto_anemia_2024.pdf', 'Dr. Eduardo Sánchez - Director de Transparencia MINSA'),
                                                                                                                        (7, '2024-03-01', 'Se remite información consolidada sobre la ejecución presupuestal de los fondos de reconstrucción en Piura. El informe incluye los proyectos priorizados, montos transferidos y porcentajes de avance por región.', 'ejecucion_reconstruccion_2024.pdf', 'Ing. Luis Velásquez - Autoridad para la Reconstrucción con Cambios');

-- -----------------------------------------------------
-- Datos para Gasto
-- -----------------------------------------------------
INSERT INTO Gasto (concepto, monto, fecha, presupuestoId, proyectoId, tipoGastoId) VALUES
-- Gastos de Nivel Nacional
('Adquisición de materiales y equipos para sistema de agua potable', 25000000.00, '2024-04-15', 4, 1, 3),
('Contratación de obras para construcción de instituciones educativas', 85000000.00, '2024-05-20', 2, 2, 5),
('Equipamiento médico para hospitales regionales', 45000000.00, '2024-06-10', 3, 3, 3),
('Materiales y maquinaria para mejoramiento vial', 68000000.00, '2024-05-15', 6, 4, 3),
('Servicios de consultoría ambiental y reforestación', 12500000.00, '2024-06-30', 8, 5, 3),

-- Gastos de Nivel Regional
('Materiales de construcción para Hospital Regional de Arequipa', 35000000.00, '2024-04-20', 9, 6, 5),
('Equipos y sistemas de riego tecnificado para Cusco', 18500000.00, '2024-05-30', 10, 7, 3),
('Materiales de construcción para colegios en La Libertad', 22000000.00, '2024-04-25', 11, 8, 5),
('Obras de prevención y reconstrucción en Piura', 28000000.00, '2024-05-15', 12, 9, 5),
('Maquinaria y materiales para carretera Lima-Cañete', 32000000.00, '2024-06-05', 13, 10, 5),

-- Gastos de Nivel Municipal
('Implementación de sistema de transporte integrado Lima', 45000000.00, '2024-07-10', 19, 11, 5),
('Materiales y equipos para terminal terrestre Arequipa', 22000000.00, '2024-06-15', 20, 12, 5),
('Restauración del centro histórico de Cusco', 15000000.00, '2024-05-25', 21, 13, 5),
('Sistema de alcantarillado en Trujillo', 18500000.00, '2024-06-20', 22, 14, 5),
('Construcción de parque ecológico en Miraflores', 8500000.00, '2024-07-05', 24, 15, 5),
('Mejoramiento de pistas y veredas en San Isidro', 12000000.00, '2024-05-15', 25, 16, 5),
('Materiales y equipamiento para centro cultural en SJL', 14500000.00, '2024-08-10', 26, 17, 5),
('Sistema de videovigilancia para Santiago de Surco', 7800000.00, '2024-05-20', 27, 18, 3);

-- =========================================
-- PROCEDIMIENTOS ALMACENADOS (Gestión de Usuarios)
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
    IN p_clave VARCHAR (255)
)
BEGIN
    INSERT INTO usuario (cod_usuario, id_persona, id_rol, clave)
    VALUES (p_cod_usuario, p_id_persona, p_id_rol, p_clave);
END $$
DELIMITER ;

-- Procedimiento para autenticar usuario
DELIMITER $$
CREATE PROCEDURE sp_autenticar_usuario(
    IN p_cod_usuario VARCHAR (45),
    IN p_clave VARCHAR (255)
)
BEGIN
    SELECT u.id_usuario,
           u.cod_usuario,
           p.nombre_completo,
           r.cod_rol,
           r.descrip_rol
    FROM usuario u
             INNER JOIN persona p ON u.id_persona = p.id_persona
             INNER JOIN rol r ON u.id_rol = r.id_rol
    WHERE u.cod_usuario = p_cod_usuario
      AND u.clave = p_clave;
END $$
DELIMITER ;

-- Procedimiento para autenticar ciudadano
DELIMITER $$
CREATE PROCEDURE sp_autenticar_ciudadano(
    IN p_correo VARCHAR(100),
    IN p_password VARCHAR(255)
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

-- Procedimiento para listar entidades por nivel de gobierno
DELIMITER $$
CREATE PROCEDURE sp_listar_entidades_por_nivel(
    IN p_nivel_id INT
)
BEGIN
    SELECT e.id, e.nombre, e.tipo, n.nombre as nivel, r.nombre as region, e.direccion, e.telefono, e.email, e.sitioWeb
    FROM EntidadPublica e
             INNER JOIN NivelGobierno n ON e.nivelGobiernoId = n.id
             LEFT JOIN Region r ON e.regionId = r.id
    WHERE e.nivelGobiernoId = p_nivel_id
    ORDER BY e.nombre;
END $$
DELIMITER ;

-- Procedimiento para listar niveles de gobierno
DELIMITER $$
CREATE PROCEDURE sp_listar_niveles_gobierno()
BEGIN
    SELECT id, nombre, descripcion
    FROM NivelGobierno
    ORDER BY id;
END $$
DELIMITER ;

-- Procedimiento para obtener estadísticas presupuestales por nivel de gobierno
DELIMITER $$
CREATE PROCEDURE sp_estadisticas_por_nivel(
    IN p_anio INT
)
BEGIN
    SELECT ng.nombre as nivel, SUM(p.montoTotal) as presupuesto_total, COUNT(p.id) as cantidad_entidades
    FROM Presupuesto p
             INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id
             INNER JOIN NivelGobierno ng ON e.nivelGobiernoId = ng.id
    WHERE p.anio = p_anio
    GROUP BY ng.nombre
    ORDER BY presupuesto_total DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener datos de presupuesto por nivel y año
DELIMITER
$$
CREATE PROCEDURE sp_presupuesto_por_nivel_y_anio(
    IN p_nivel_id INT
)
BEGIN
    SELECT p.anio, SUM(p.montoTotal) as presupuesto_total
    FROM Presupuesto p
             INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id
    WHERE e.nivelGobiernoId = p_nivel_id
    GROUP BY p.anio
    ORDER BY p.anio;
END $$
DELIMITER ;

-- Procedimiento para obtener datos de gasto por nivel de gobierno
DELIMITER
$$
CREATE PROCEDURE sp_gasto_por_nivel(
    IN p_nivel_id INT
)
BEGIN
    SELECT g.concepto, g.monto, g.fecha, tg.nombre as tipo_gasto
    FROM Gasto g
             INNER JOIN EntidadPublica e ON g.presupuestoId = e.id
             INNER JOIN TipoGasto tg ON g.tipoGastoId = tg.id
    WHERE e.nivelGobiernoId = p_nivel_id
    ORDER BY g.fecha DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener la distribución del presupuesto por ministerios
DELIMITER
$$
CREATE PROCEDURE sp_distribucion_presupuesto_ministerios(
    IN p_anio INT
)
BEGIN
    SELECT e.id,
           e.nombre,
           SUM(p.montoTotal)                                                                         as montoTotal,
           (SUM(p.montoTotal) / (SELECT SUM(montoTotal) FROM Presupuesto WHERE anio = p_anio)) * 100 as porcentaje
    FROM Presupuesto p
             INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id
    WHERE e.nivelGobiernoId = 1 -- Nacional
      AND e.tipo = 'Ministerio'
      AND p.anio = p_anio
    GROUP BY e.id, e.nombre
    ORDER BY montoTotal DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener proyectos por nivel de gobierno
DELIMITER
$$
CREATE PROCEDURE sp_proyectos_por_nivel(
    IN p_nivel_id INT
)
BEGIN
    SELECT p.id,
           p.nombre,
           p.descripcion,
           p.estado,
           e.nombre     as entidad_nombre,
           p.fechaInicio,
           p.fechaFin,
           SUM(g.monto) as presupuesto_ejecutado
    FROM Proyecto p
             INNER JOIN Presupuesto pr ON p.presupuestoId = pr.id
             INNER JOIN EntidadPublica e ON pr.entidadPublicaId = e.id
             LEFT JOIN Gasto g ON g.proyectoId = p.id
    WHERE e.nivelGobiernoId = p_nivel_id
    GROUP BY p.id, p.nombre, p.descripcion, p.estado, e.nombre, p.fechaInicio, p.fechaFin
    ORDER BY presupuesto_ejecutado DESC LIMIT 10;
END $$
DELIMITER ;

-- Procedimiento para obtener la ejecución del gasto por mes
DELIMITER
$$
CREATE PROCEDURE sp_ejecucion_mensual_por_nivel(
    IN p_nivel_id INT,
    IN p_anio INT
)
BEGIN
    SELECT MONTH (g.fecha) as mes, SUM (g.monto) as monto_ejecutado
    FROM Gasto g
             INNER JOIN Presupuesto p
                        ON g.presupuestoId = p.id
             INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id
    WHERE e.nivelGobiernoId = p_nivel_id
      AND YEAR (g.fecha) = p_anio
    GROUP BY MONTH (g.fecha)
    ORDER BY mes;
END $$
DELIMITER ;

-- Procedimiento para obtener el porcentaje de ejecución presupuestaria
DELIMITER
$$
CREATE PROCEDURE sp_porcentaje_ejecucion(
    IN p_nivel_id INT,
    IN p_anio INT
)
BEGIN
    SELECT SUM(p.montoTotal)                        as presupuesto_total,
           SUM(g.monto)                             as ejecutado_total,
           (SUM(g.monto) / SUM(p.montoTotal)) * 100 as porcentaje_ejecucion
    FROM Presupuesto p
             INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id
             LEFT JOIN Gasto g ON g.presupuestoId = p.id
    WHERE e.nivelGobiernoId = p_nivel_id
      AND p.anio = p_anio;
END $$
DELIMITER ;

-- Procedimiento para obtener datos de ejecución por categoría de gasto
DELIMITER
$$
CREATE PROCEDURE sp_gasto_por_categoria(
    IN p_nivel_id INT,
    IN p_anio INT
)
BEGIN
    SELECT tg.id,
           tg.nombre,
           SUM(g.monto)                                    as monto_total,
           (SUM(g.monto) / (SELECT SUM(g2.monto)
                            FROM Gasto g2
                                     INNER JOIN Presupuesto p2 ON g2.presupuestoId = p2.id
                                     INNER JOIN EntidadPublica e2 ON p2.entidadPublicaId = e2.id
                            WHERE e2.nivelGobiernoId = p_nivel_id
                              AND p2.anio = p_anio)) * 100 as porcentaje
    FROM Gasto g
             INNER JOIN TipoGasto tg ON g.tipoGastoId = tg.id
             INNER JOIN Presupuesto p ON g.presupuestoId = p.id
             INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id
    WHERE e.nivelGobiernoId = p_nivel_id
      AND p.anio = p_anio
    GROUP BY tg.id, tg.nombre
    ORDER BY monto_total DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener información de proyectos destacados
DELIMITER
$$
CREATE PROCEDURE sp_proyectos_destacados()
BEGIN
    SELECT p.id,
           p.nombre,
           p.descripcion,
           p.estado,
           e.nombre      as entidad_nombre,
           SUM(g.monto)  as presupuesto_ejecutado,
           pr.montoTotal as presupuesto_asignado
    FROM Proyecto p
             INNER JOIN Presupuesto pr ON p.presupuestoId = pr.id
             INNER JOIN EntidadPublica e ON pr.entidadPublicaId = e.id
             LEFT JOIN Gasto g ON g.proyectoId = p.id
    WHERE p.estado = 'En ejecución'
    GROUP BY p.id, p.nombre, p.descripcion, p.estado, e.nombre, pr.montoTotal
    ORDER BY presupuesto_ejecutado DESC LIMIT 5;
END $$
DELIMITER ;

-- =========================================
-- FIN DEL SCRIPT
-- =========================================

SELECT 'Script de base de datos ejecutado completamente.' AS Estado;