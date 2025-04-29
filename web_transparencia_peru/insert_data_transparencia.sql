-- Script para poblar la base de datos con información real sobre transparencia en Perú
USE
db_transparencia_peru;

-- Insertar más departamentos para cubrir las principales regiones del Perú
INSERT INTO Departamento (nombre, codigo)
VALUES ('Amazonas', 'AMA'),
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

-- Insertar más entidades públicas relevantes en el contexto peruano
INSERT INTO EntidadPublica (nombre, tipo, region, direccion, telefono, email, sitioWeb, departamentoId)
VALUES ('Ministerio de Vivienda, Construcción y Saneamiento', 'Ministerio', 'Nacional',
        'Av. Paseo de la República 3361, San Isidro', '01-2117930', 'contacto@vivienda.gob.pe', 'www.gob.pe/vivienda',
        1),
       ('Ministerio del Interior', 'Ministerio', 'Nacional', 'Plaza 30 de Agosto s/n Urb. Corpac, San Isidro',
        '01-5182800', 'contacto@mininter.gob.pe', 'www.gob.pe/mininter', 1),
       ('Ministerio de Transportes y Comunicaciones', 'Ministerio', 'Nacional', 'Jr. Zorritos 1203, Lima', '01-6157800',
        'atencionalciudadano@mtc.gob.pe', 'www.gob.pe/mtc', 1),
       ('Ministerio de Desarrollo Agrario y Riego', 'Ministerio', 'Nacional', 'Av. La Universidad 200, La Molina',
        '01-2098800', 'contacto@midagri.gob.pe', 'www.gob.pe/midagri', 1),
       ('Ministerio del Ambiente', 'Ministerio', 'Nacional', 'Av. Antonio Miroquesada 425, Magdalena del Mar',
        '01-6116000', 'webmaster@minam.gob.pe', 'www.gob.pe/minam', 1),
       ('OSINERGMIN', 'Organismo Supervisor', 'Nacional', 'Calle Bernardo Monteagudo 222, Magdalena del Mar',
        '01-2193400', 'atencionalcliente@osinergmin.gob.pe', 'www.gob.pe/osinergmin', 1),
       ('SUNASS', 'Organismo Supervisor', 'Nacional', 'Av. Bernardo Monteagudo 210, Magdalena del Mar', '01-6143180',
        'contacto@sunass.gob.pe', 'www.gob.pe/sunass', 1),
       ('Gobierno Regional de Cusco', 'Gobierno Regional', 'Regional', 'Av. Tomasa Tito Condemayta s/n, Cusco',
        '084-221131', 'contacto@regioncusco.gob.pe', 'www.regioncusco.gob.pe', 3),
       ('Gobierno Regional de La Libertad', 'Gobierno Regional', 'Regional',
        'Jr. Los Brillantes 650, Urb. Santa Inés, Trujillo', '044-604000', 'contacto@regionlalibertad.gob.pe',
        'www.regionlalibertad.gob.pe', 4),
       ('Gobierno Regional de Piura', 'Gobierno Regional', 'Regional', 'Av. San Ramón s/n, Urb. San Eduardo, Piura',
        '073-284600', 'contacto@regionpiura.gob.pe', 'www.regionpiura.gob.pe', 5),
       ('Municipalidad Provincial de Lima', 'Municipalidad', 'Local', 'Jr. de la Unión 300, Lima', '01-6321300',
        'contacto@munlima.gob.pe', 'www.munlima.gob.pe', 1),
       ('Municipalidad Provincial de Arequipa', 'Municipalidad', 'Local', 'Plaza de Armas s/n, Arequipa', '054-380050',
        'contacto@muniarequipa.gob.pe', 'www.muniarequipa.gob.pe', 2),
       ('Contraloría General de la República', 'Organismo Constitucional Autónomo', 'Nacional',
        'Jr. Camilo Carrillo 114, Jesús María', '01-3303000', 'contraloria@contraloria.gob.pe',
        'www.contraloria.gob.pe', 1),
       ('SUNAT', 'Organismo Público Descentralizado', 'Nacional', 'Av. Garcilaso de la Vega 1472, Lima', '01-6343400',
        'contacto@sunat.gob.pe', 'www.gob.pe/sunat', 1),
       ('ESSALUD', 'Seguridad Social', 'Nacional', 'Jr. Domingo Cueto 120, Jesús María', '01-2656000',
        'contacto@essalud.gob.pe', 'www.gob.pe/essalud', 1);

-- Insertar registros de ciudadanos representativos (con datos ficticios)
INSERT INTO Ciudadano (nombres, apellidos, dni, correo, telefono, direccion, fechaRegistro, password)
VALUES ('Roberto', 'Sánchez Mendoza', '45673829', 'roberto.sanchez@gmail.com', '987123456',
        'Av. La Paz 452, Miraflores, Lima', '2024-01-15', 'password123'),
       ('María Luisa', 'Paredes Torres', '09876543', 'mluisa.paredes@hotmail.com', '941236547',
        'Jr. Amazonas 1234, Trujillo', '2024-01-20', 'pass2024'),
       ('Jorge Luis', 'Vargas Mendoza', '72145639', 'jvargas@gmail.com', '932568741', 'Calle Los Pinos 328, Arequipa',
        '2024-02-05', 'jorge2024'),
       ('Carmen Rosa', 'Huamán Quispe', '43215678', 'chuaman@gmail.com', '912345678', 'Av. Sol 340, Cusco',
        '2024-02-10', 'carmen123'),
       ('Miguel Ángel', 'Rodríguez Pérez', '25631478', 'marodriguez@outlook.com', '963258741',
        'Av. José Pardo 450, Chimbote', '2024-02-15', 'miguel2024'),
       ('Lucía', 'Mendoza Castro', '10293847', 'lmendoza@gmail.com', '951357846', 'Calle Real 123, Huancayo',
        '2024-02-20', 'lucia123'),
       ('Juan Carlos', 'Flores Ríos', '40506070', 'jcflores@hotmail.com', '974125836',
        'Av. Pardo 780, Miraflores, Lima', '2024-03-01', 'floresj21'),
       ('Rosa María', 'Chávez Luna', '30405060', 'rmchavez@gmail.com', '985213674', 'Jr. Arequipa 578, Piura',
        '2024-03-05', 'rosach24'),
       ('Fernando', 'Díaz Sánchez', '20304050', 'fdiaz@outlook.com', '964738291', 'Av. Grau 857, Tacna', '2024-03-10',
        'ferdiaz21'),
       ('Patricia', 'Gonzales Torres', '10203040', 'pgonzales@gmail.com', '937418529', 'Calle Lima 324, Ayacucho',
        '2024-03-15', 'patty2024');

-- Insertar nuevos períodos fiscales para años relevantes
INSERT INTO PeriodoFiscal (anio, fechaInicio, fechaFin, estado)
VALUES (2022, '2022-01-01', '2022-12-31', 'Cerrado'),
       (2021, '2021-01-01', '2021-12-31', 'Cerrado'),
       (2020, '2020-01-01', '2020-12-31', 'Cerrado'),
       (2023, '2023-01-01', '2023-12-31', 'Cerrado'),
       (2024, '2024-01-01', '2024-12-31', 'Abierto');

-- Insertar presupuestos adicionales con datos realistas (en millones de soles)
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion)
VALUES
-- Presupuestos del año 2023
(2023, 7350000000.00, 6, 1, '2022-12-19', 'Presupuesto anual del Ministerio de Vivienda, Construcción y Saneamiento'),
       (2023, 9250000000.00, 7, 1, '2022-12-18', 'Presupuesto anual del Ministerio del Interior'),
       (2023, 8150000000.00, 8, 1, '2022-12-17', 'Presupuesto anual del Ministerio de Transportes y Comunicaciones'),
       (2023, 3850000000.00, 9, 1, '2022-12-15', 'Presupuesto anual del Ministerio de Desarrollo Agrario y Riego'),
       (2023, 1250000000.00, 10, 1, '2022-12-16', 'Presupuesto anual del Ministerio del Ambiente'),
       (2023, 750000000.00, 11, 1, '2022-12-20', 'Presupuesto anual de OSINERGMIN'),
       (2023, 350000000.00, 12, 1, '2022-12-19', 'Presupuesto anual de SUNASS'),
-- Presupuestos de Gobiernos Regionales 2023
(2023, 1250000000.00, 3, 1, '2022-12-18', 'Presupuesto anual del Gobierno Regional de Arequipa'),
(2023, 1450000000.00, 13, 1, '2022-12-17', 'Presupuesto anual del Gobierno Regional de Cusco'),
(2023, 1350000000.00, 14, 1, '2022-12-16', 'Presupuesto anual del Gobierno Regional de La Libertad'),
(2023, 1150000000.00, 15, 1, '2022-12-15', 'Presupuesto anual del Gobierno Regional de Piura'),
-- Presupuestos de Municipalidades 2023
(2023, 950000000.00, 4, 1, '2022-12-20', 'Presupuesto anual de la Municipalidad Provincial de Cusco'),
(2023, 1850000000.00, 16, 1, '2022-12-19', 'Presupuesto anual de la Municipalidad Provincial de Lima'),
(2023, 750000000.00, 17, 1, '2022-12-18', 'Presupuesto anual de la Municipalidad Provincial de Arequipa'),

-- Presupuestos del año 2024
(2024, 8150000000.00, 6, 2, '2023-12-20', 'Presupuesto anual del Ministerio de Vivienda, Construcción y Saneamiento'),
       (2024, 10150000000.00, 7, 2, '2023-12-19', 'Presupuesto anual del Ministerio del Interior'),
(2024, 9250000000.00, 8, 2, '2023-12-18', 'Presupuesto anual del Ministerio de Transportes y Comunicaciones'),
(2024, 4250000000.00, 9, 2, '2023-12-17', 'Presupuesto anual del Ministerio de Desarrollo Agrario y Riego'),
(2024, 1450000000.00, 10, 2, '2023-12-16', 'Presupuesto anual del Ministerio del Ambiente'),
-- Presupuestos de Gobiernos Regionales 2024
(2024, 1450000000.00, 3, 2, '2023-12-15', 'Presupuesto anual del Gobierno Regional de Arequipa'),
(2024, 1650000000.00, 13, 2, '2023-12-14', 'Presupuesto anual del Gobierno Regional de Cusco'),
(2024, 1550000000.00, 14, 2, '2023-12-13', 'Presupuesto anual del Gobierno Regional de La Libertad'),
(2024, 1350000000.00, 15, 2, '2023-12-12', 'Presupuesto anual del Gobierno Regional de Piura'),
-- Presupuestos de Municipalidades 2024
(2024, 1050000000.00, 4, 2, '2023-12-11', 'Presupuesto anual de la Municipalidad Provincial de Cusco'),
(2024, 2050000000.00, 16, 2, '2023-12-10', 'Presupuesto anual de la Municipalidad Provincial de Lima'),
(2024, 850000000.00, 17, 2, '2023-12-09', 'Presupuesto anual de la Municipalidad Provincial de Arequipa');

-- Presupuestos para años anteriores (2022)
INSERT INTO Presupuesto (anio, montoTotal, entidadPublicaId, periodoFiscalId, fechaAprobacion, descripcion)
VALUES (2022, 7000000000.00, 6, 4, '2021-12-19',
        'Presupuesto anual del Ministerio de Vivienda, Construcción y Saneamiento'),
       (2022, 8500000000.00, 7, 4, '2021-12-18', 'Presupuesto anual del Ministerio del Interior'),
       (2022, 7800000000.00, 8, 4, '2021-12-17', 'Presupuesto anual del Ministerio de Transportes y Comunicaciones'),
       (2022, 1200000000.00, 3, 4, '2021-12-16', 'Presupuesto anual del Gobierno Regional de Arequipa'),
       (2022, 1350000000.00, 13, 4, '2021-12-15', 'Presupuesto anual del Gobierno Regional de Cusco'),
       (2022, 1250000000.00, 14, 4, '2021-12-14', 'Presupuesto anual del Gobierno Regional de La Libertad'),
       (2022, 1050000000.00, 15, 4, '2021-12-13', 'Presupuesto anual del Gobierno Regional de Piura');

-- Proyectos con casos típicos de la realidad peruana
INSERT INTO Proyecto (nombre, descripcion, presupuestoId, categoriaGastoId, fuenteFinanciamientoId, fechaInicio,
                      fechaFin, estado)
VALUES ('Ampliación del sistema de agua potable en San Juan de Lurigancho',
        'Proyecto para mejorar el acceso al agua potable para más de 50,000 familias en SJL', 6, 5, 1, '2023-02-15',
        '2024-08-30', 'En ejecución'),
       ('Reconstrucción de colegios afectados por el Fenómeno del Niño en Piura',
        'Reconstrucción de 25 instituciones educativas dañadas por las lluvias e inundaciones', 7, 5, 1, '2023-03-20',
        '2023-12-15', 'Finalizado'),
       ('Mejoramiento de la carretera Cusco - Quillabamba', 'Proyecto de mantenimiento y ampliación de 180 km de vía',
        8, 5, 3, '2023-04-10', '2024-10-30', 'En ejecución'),
       ('Programa de titulación de tierras en zonas rurales',
        'Entrega de títulos de propiedad a comunidades campesinas en 10 regiones del país', 9, 3, 2, '2023-05-15',
        '2024-05-15', 'En ejecución'),
       ('Construcción del Hospital Regional de Loreto',
        'Construcción de hospital de nivel III-1 con capacidad para 250 camas', 6, 5, 3, '2023-06-01', '2025-01-30',
        'En ejecución'),
       ('Ampliación de la Línea 1 del Metro de Lima', 'Extensión de la Línea 1 hacia San Juan de Lurigancho', 8, 5, 3,
        '2023-07-15', '2025-12-30', 'En ejecución'),
       ('Mejoramiento del sistema de alcantarillado en Chiclayo',
        'Renovación del sistema de alcantarillado en zonas críticas de la ciudad', 6, 5, 1, '2023-08-10', '2024-04-30',
        'En ejecución'),
       ('Programa Nacional de Tambos', 'Construcción de plataformas de servicios en zonas rurales altoandinas', 9, 5, 1,
        '2023-02-15', '2025-02-15', 'En ejecución'),
       ('Rehabilitación de la carretera Central tramo Matucana - La Oroya',
        'Mejoramiento y ampliación de 120 km de la vía', 8, 5, 3, '2023-03-10', '2024-06-30', 'En ejecución'),
       ('Electrificación rural en la región Amazonas',
        'Proyecto para llevar energía eléctrica a 200 comunidades aisladas', 10, 5, 2, '2023-04-20', '2024-10-15',
        'En ejecución');

-- Tipos de solicitud adicionales relacionados con transparencia
INSERT INTO TipoSolicitud (nombre, descripcion)
VALUES ('Información de Gestión Administrativa',
        'Solicitud relacionada con procesos administrativos, normativa interna, y gestión institucional'),
       ('Información de Recursos Humanos', 'Solicitud sobre contrataciones, remuneraciones, y gestión de personal'),
       ('Información Presupuestal y Financiera', 'Solicitud sobre ejecución presupuestal, gastos e inversiones'),
       ('Información de Obras Públicas', 'Solicitud sobre proyectos de infraestructura y obras públicas'),
       ('Información Ambiental', 'Solicitud sobre estudios, permisos e información de impacto ambiental');

-- Estados de solicitud
INSERT INTO EstadoSolicitud (nombre, descripcion)
VALUES ('Pendiente', 'La solicitud ha sido recibida pero aún no ha sido procesada'),
       ('En Proceso', 'La solicitud está siendo procesada'),
       ('Atendida', 'La solicitud ha sido atendida y respondida'),
       ('Observada', 'La solicitud tiene observaciones que deben ser subsanadas'),
       ('Rechazada', 'La solicitud ha sido rechazada');

-- Solicitudes de acceso a la información con casos típicos de la realidad peruana
INSERT INTO SolicitudAcceso (fechaSolicitud, descripcion, ciudadanoId, tipoSolicitudId, estadoSolicitudId,
                             entidadPublicaId, fechaRespuesta, observaciones)
VALUES ('2024-01-10',
        'Solicitud de información sobre el gasto detallado en la construcción del Hospital Regional de Loreto y estado actual de la obra',
        6, 2, 3, 6, '2024-01-25', 'Se proporcionó la información completa dentro del plazo'),
       ('2024-01-15',
        'Solicito información sobre los contratos adjudicados para la Reconstrucción con Cambios en Piura durante el periodo 2023',
        7, 3, 3, 10, '2024-01-30', 'Se entregó la información dentro del plazo establecido'),
       ('2024-01-20',
        'Requiero información sobre el proceso de selección y contratos de la empresa encargada de la supervisión técnica del proyecto de la Línea 2 del Metro de Lima',
        8, 3, 2, 8, NULL, 'En proceso de recopilación por su complejidad'),
       ('2024-01-25',
        'Solicito información sobre el presupuesto asignado y ejecutado en 2023 para programas de lucha contra la anemia infantil',
        9, 1, 3, 5, '2024-02-08', 'Información proporcionada con estadísticas adicionales'),
       ('2024-02-01',
        'Solicito acceso a los expedientes técnicos del proyecto de agua y saneamiento en San Juan de Lurigancho', 10,
        2, 4, 6, NULL, 'Se requiere precisar qué componentes específicos del expediente técnico necesita'),
       ('2024-02-05',
        'Solicito información sobre las contrataciones directas realizadas por el Ministerio de Salud durante la emergencia sanitaria 2020-2022',
        1, 3, 1, 5, NULL, 'Pendiente de asignación'),
       ('2024-02-10',
        'Requiero datos sobre la ejecución presupuestal de los fondos asignados a la reconstrucción post Niño Costero en los departamentos del norte',
        2, 1, 3, 6, '2024-03-01', 'Se proporcionó la información con un día de retraso por la complejidad'),
       ('2024-02-15',
        'Solicito la relación de funcionarios sancionados por casos de corrupción en los últimos 3 años en el Ministerio de Transportes',
        3, 7, 5, 8, '2024-03-01', 'Solicitud rechazada por contener datos personales protegidos'),
       ('2024-02-20', 'Requiero información sobre los estudios de impacto ambiental del proyecto minero Tía María', 4,
        10, 2, 10, NULL, 'En proceso de consolidación de la información'),
       ('2024-02-25',
        'Solicito información sobre los gastos de publicidad estatal realizados por el Ministerio del Interior en el 2023',
        5, 1, 1, 7, NULL, 'Recientemente ingresada');

-- Fuente de financiamiento
INSERT INTO FuenteFinanciamiento (nombre, descripcion)
VALUES ('Recursos Ordinarios', 'Ingresos provenientes de la recaudación tributaria'),
       ('Recursos Directamente Recaudados', 'Ingresos generados por las propias entidades públicas'),
       ('Recursos por Operaciones Oficiales de Crédito',
        'Fondos de fuentes externas e internas provenientes de operaciones de crédito'),
       ('Donaciones y Transferencias', 'Fondos financieros no reembolsables recibidos por el gobierno'),
       ('Recursos Determinados', 'Contribuciones a fondos, canon, regalías, etc.');

-- Categorías de gasto
INSERT INTO CategoriaGasto (nombre, descripcion)
VALUES ('Personal y Obligaciones Sociales', 'Gastos por el pago del personal activo del sector público'),
       ('Pensiones y Prestaciones Sociales', 'Gastos por el pago de pensiones'),
       ('Bienes y Servicios', 'Gastos por adquisición de bienes y contratación de servicios'),
       ('Donaciones y Transferencias', 'Gastos por donaciones y transferencias a instituciones'),
       ('Inversión Pública', 'Gastos destinados a proyectos de inversión pública');

-- Respuestas detalladas a solicitudes
INSERT INTO RespuestaSolicitud (solicitudAccesoId, fechaRespuesta, descripcion, archivoAdjunto, usuarioResponsable)
VALUES (6, '2024-01-25',
        'Se adjunta informe detallado del avance físico y financiero del proyecto Hospital Regional de Loreto, así como las actas de supervisión de obra de los últimos 6 meses. El proyecto presenta un avance físico del 65% y un avance financiero del 58%.',
        'informe_hospital_loreto_2023.pdf', 'Carlos Morales - Director de Transparencia MVCS'),
       (7, '2024-01-30',
        'Se remite la relación de contratos adjudicados para la Reconstrucción con Cambios en Piura durante 2023, detallando montos, empresas ganadoras, plazos de ejecución y estado actual de cada obra. Se han ejecutado 35 proyectos por un total de S/ 450 millones.',
        'contratos_rcc_piura_2023.xlsx', 'Sandra Pacheco - Oficina de Acceso a la Información ARCC'),
       (9, '2024-02-08',
        'Se adjunta informe de la Dirección de Intervenciones Estratégicas con el presupuesto asignado y ejecutado en 2023 para programas de lucha contra anemia infantil. Se destinaron S/ 350 millones logrando reducir la prevalencia de anemia en 3.5 puntos porcentuales a nivel nacional.',
        'presupuesto_anemia_2023.pdf', 'Dr. Eduardo Sánchez - Director de Transparencia MINSA'),
       (12, '2024-03-01',
        'Se remite información consolidada sobre la ejecución presupuestal de los fondos de reconstrucción en Piura, Lambayeque, La Libertad y Tumbes. El informe incluye los proyectos priorizados, montos transferidos y porcentajes de avance por región.',
        'ejecucion_reconstruccion_2023.pdf', 'Ing. Luis Velásquez - Autoridad para la Reconstrucción con Cambios');

-- Gastos representativos de la realidad peruana
INSERT INTO Gasto (concepto, monto, fecha, presupuestoId, proyectoId, categoriaGastoId)
VALUES ('Adquisición de equipamiento médico para el Hospital Regional de Loreto', 15000000.00, '2023-09-15', 6, 6, 3),
       ('Materiales de construcción para el sistema de agua potable en SJL', 8500000.00, '2023-05-20', 6, 6, 5),
       ('Pago a contratista por avance de obra - Hospital Regional Loreto', 25000000.00, '2023-10-10', 6, 6, 5),
       ('Adquisición de tuberías y accesorios para sistema de agua SJL', 4800000.00, '2023-06-30', 6, 6, 3),
       ('Pago por servicios de consultoría y supervisión - SJL', 1200000.00, '2023-07-15', 6, 6, 3),
       ('Adquisición de materiales para reconstrucción de colegios en Piura', 6500000.00, '2023-05-10', 7, 7, 5),
       ('Pago a contratista por avance de obra - Colegios Piura', 12000000.00, '2023-08-25', 7, 7, 5),
       ('Equipamiento educativo para colegios reconstruidos', 3800000.00, '2023-11-05', 7, 7, 3),
       ('Servicios de supervisión técnica - Colegios Piura', 950000.00, '2023-07-20', 7, 7, 3),
       ('Asfalto y materiales para carretera Cusco-Quillabamba', 18500000.00, '2023-06-15', 8, 8, 5),
       ('Maquinaria pesada para obra vial Cusco-Quillabamba', 7800000.00, '2023-07-05', 8, 8, 3),
       ('Servicios de consultoría ambiental - Carretera Cusco-Quillabamba', 1500000.00, '2023-05-15', 8, 8, 3),
       ('Elaboración de estudios de ingeniería - Metro de Lima extensión', 5200000.00, '2023-08-15', 8, 11, 3);