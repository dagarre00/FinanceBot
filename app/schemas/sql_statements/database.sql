-- 1. Tablas maestras (Lookups)
CREATE TABLE tipos_gasto (
    tipo_gasto_id SERIAL PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL,
    rubro VARCHAR(50) NOT NULL
);

CREATE TABLE formas_pago (
    forma_id SERIAL PRIMARY KEY,
    tipo_forma VARCHAR(50) NOT NULL,
    descripcion TEXT
);

CREATE TABLE fuentes_ingreso (
    fuente_id SERIAL PRIMARY KEY,
    tipo_fuente VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- 2. Entidad principal: Usuarios
CREATE TABLE usuarios (
    usuario_id SERIAL PRIMARY KEY,
    nombre_de_usuario VARCHAR(100) NOT NULL,
    edad INTEGER,
    descripcion_perfil TEXT,
    escolaridad VARCHAR(100),
    tipo_de_inversor VARCHAR(50), -- Perfil de riesgo
    actividad_economica VARCHAR(100),
    sector VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Transacciones y Operaciones
CREATE TABLE ingresos (
    ingreso_id BIGSERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(usuario_id),
    fuente_id INTEGER REFERENCES fuentes_ingreso(fuente_id),
    valor_ingreso DECIMAL(20, 5) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE gastos (
    gasto_id BIGSERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(usuario_id),
    tipo_gasto_id INTEGER REFERENCES tipos_gasto(tipo_gasto_id),
    forma_id INTEGER REFERENCES formas_pago(forma_id),
    valor DECIMAL(20, 5) NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE presupuestos (
    presupuesto_id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(usuario_id),
    tipo_gasto_id INTEGER REFERENCES tipos_gasto(tipo_gasto_id),
    valor_presupuesto DECIMAL(20, 5) NOT NULL,
    periodo_mes_ano DATE NOT NULL -- Para control mensual
);

CREATE TABLE deudas (
    deuda_id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(usuario_id),
    entidad VARCHAR(100) NOT NULL,
    valor_total_deuda DECIMAL(20, 5) NOT NULL,
    valor_pendiente DECIMAL(20, 5) NOT NULL,
    fecha_de_corte DATE,
    tasa_de_interes DECIMAL(10, 5),
    tipo_de_tasa VARCHAR(20), -- Fija, Variable
    plazo_meses INTEGER
);

-- Tabla adicional para el Flujo de Usuario: Plan de Pagos
CREATE TABLE plan_pagos_deuda (
    plan_id SERIAL PRIMARY KEY,
    deuda_id INTEGER REFERENCES deudas(deuda_id),
    cuota_sugerida DECIMAL(20, 5),
    fecha_estimada_pago DATE,
    estado_pago BOOLEAN DEFAULT FALSE
);

CREATE TABLE inversiones (
    inversion_id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(usuario_id),
    entidad VARCHAR(100) NOT NULL,
    monto_actual DECIMAL(20, 5) NOT NULL,
    tasa_interes_esperada DECIMAL(10, 5),
    tipo_de_rentabilidad VARCHAR(50) -- Variable, Fija
);