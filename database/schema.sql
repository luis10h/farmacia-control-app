-- ============================================
-- FARMACIA CONTROL APP - Database Schema
-- ============================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS farmacia_db;
USE farmacia_db;

-- ============================================
-- TABLA: USUARIOS
-- ============================================
CREATE TABLE usuarios (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  usuario VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  rol ENUM('admin', 'vendedor', 'gerente') DEFAULT 'vendedor',
  activo BOOLEAN DEFAULT TRUE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: CATEGORIAS MEDICAMENTOS
-- ============================================
CREATE TABLE categorias (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  descripcion TEXT,
  activa BOOLEAN DEFAULT TRUE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: MEDICAMENTOS
-- ============================================
CREATE TABLE medicamentos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  codigo VARCHAR(50) UNIQUE NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  categoria_id INT NOT NULL,
  precio_compra DECIMAL(10, 2) NOT NULL,
  precio_venta DECIMAL(10, 2) NOT NULL,
  stock_minimo INT DEFAULT 10,
  activo BOOLEAN DEFAULT TRUE,
  fecha_vencimiento DATE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índices para medicamentos
CREATE INDEX idx_medicamentos_codigo ON medicamentos(codigo);
CREATE INDEX idx_medicamentos_nombre ON medicamentos(nombre);
CREATE INDEX idx_medicamentos_categoria ON medicamentos(categoria_id);

-- ============================================
-- TABLA: INVENTARIO
-- ============================================
CREATE TABLE inventario (
  id INT PRIMARY KEY AUTO_INCREMENT,
  medicamento_id INT NOT NULL UNIQUE,
  cantidad_actual INT DEFAULT 0,
  cantidad_reservada INT DEFAULT 0,
  lote VARCHAR(50),
  fecha_vencimiento DATE,
  fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: PROVEEDORES
-- ============================================
CREATE TABLE proveedores (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(150) NOT NULL,
  contacto VARCHAR(100),
  email VARCHAR(100),
  telefono VARCHAR(20),
  direccion TEXT,
  ciudad VARCHAR(100),
  activo BOOLEAN DEFAULT TRUE,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: COMPRAS
-- ============================================
CREATE TABLE compras (
  id INT PRIMARY KEY AUTO_INCREMENT,
  numero_compra VARCHAR(50) UNIQUE NOT NULL,
  proveedor_id INT NOT NULL,
  fecha_compra DATE NOT NULL,
  fecha_entrega DATE,
  total DECIMAL(12, 2) NOT NULL,
  estado ENUM('pendiente', 'recibida', 'cancelada') DEFAULT 'pendiente',
  observaciones TEXT,
  usuario_id INT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (proveedor_id) REFERENCES proveedores(id) ON DELETE RESTRICT,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: DETALLES COMPRAS
-- ============================================
CREATE TABLE detalles_compras (
  id INT PRIMARY KEY AUTO_INCREMENT,
  compra_id INT NOT NULL,
  medicamento_id INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10, 2) NOT NULL,
  subtotal DECIMAL(12, 2) NOT NULL,
  FOREIGN KEY (compra_id) REFERENCES compras(id) ON DELETE CASCADE,
  FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: VENTAS
-- ============================================
CREATE TABLE ventas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  numero_venta VARCHAR(50) UNIQUE NOT NULL,
  fecha_venta DATE NOT NULL,
  hora_venta TIME NOT NULL,
  usuario_id INT NOT NULL,
  cliente_nombre VARCHAR(150),
  subtotal DECIMAL(12, 2) NOT NULL,
  descuento DECIMAL(12, 2) DEFAULT 0,
  iva DECIMAL(12, 2) DEFAULT 0,
  total DECIMAL(12, 2) NOT NULL,
  metodo_pago ENUM('efectivo', 'tarjeta', 'cheque', 'transferencia') DEFAULT 'efectivo',
  observaciones TEXT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índices para ventas
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_ventas_usuario ON ventas(usuario_id);
CREATE INDEX idx_ventas_numero ON ventas(numero_venta);

-- ============================================
-- TABLA: DETALLES VENTAS
-- ============================================
CREATE TABLE detalles_ventas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  venta_id INT NOT NULL,
  medicamento_id INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10, 2) NOT NULL,
  subtotal DECIMAL(12, 2) NOT NULL,
  FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
  FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: MOVIMIENTOS INVENTARIO
-- ============================================
CREATE TABLE movimientos_inventario (
  id INT PRIMARY KEY AUTO_INCREMENT,
  medicamento_id INT NOT NULL,
  tipo_movimiento ENUM('entrada', 'salida', 'ajuste', 'vencimiento') NOT NULL,
  cantidad INT NOT NULL,
  referencia VARCHAR(100),
  descripcion TEXT,
  usuario_id INT,
  fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id) ON DELETE CASCADE,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índices para movimientos
CREATE INDEX idx_movimientos_medicamento ON movimientos_inventario(medicamento_id);
CREATE INDEX idx_movimientos_fecha ON movimientos_inventario(fecha_movimiento);
CREATE INDEX idx_movimientos_tipo ON movimientos_inventario(tipo_movimiento);

-- ============================================
-- INSERT DE DATOS INICIALES
-- ============================================

-- Usuarios por defecto
INSERT INTO usuarios (nombre, email, usuario, password, rol) VALUES
('Administrador', 'admin@farmacia.com', 'admin', '$2y$10$n9e3Gqe3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3', 'admin'),
('Vendedor', 'vendedor@farmacia.com', 'vendedor', '$2y$10$n9e3Gqe3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3e3', 'vendedor');

-- Categorías
INSERT INTO categorias (nombre, descripcion) VALUES
('Analgésicos', 'Medicamentos para el dolor'),
('Antibióticos', 'Medicamentos antibacterianos'),
('Antiinflamatorios', 'Medicamentos antiinflamatorios'),
('Vitaminas', 'Suplementos vitamínicos'),
('Antigripales', 'Medicamentos para la gripe y resfriado');

-- Medicamentos de ejemplo
INSERT INTO medicamentos (codigo, nombre, descripcion, categoria_id, precio_compra, precio_venta, stock_minimo) VALUES
('MED001', 'Paracetamol 500mg', 'Analgésico y antipirético', 1, 1.50, 3.00, 50),
('MED002', 'Ibuprofeno 400mg', 'Antiinflamatorio y analgésico', 3, 2.00, 4.50, 40),
('MED003', 'Amoxicilina 500mg', 'Antibiótico de amplio espectro', 2, 5.00, 10.00, 30),
('MED004', 'Vitamina C 1000mg', 'Suplemento vitamínico', 4, 3.00, 6.50, 25),
('MED005', 'Loratadina 10mg', 'Antihistamínico', 5, 2.50, 5.00, 20);

-- Inventario inicial
INSERT INTO inventario (medicamento_id, cantidad_actual) 
SELECT id, 100 FROM medicamentos;

-- Proveedores
INSERT INTO proveedores (nombre, contacto, email, telefono, ciudad) VALUES
('Farmacéutica ABC', 'Juan Pérez', 'contacto@farmabc.com', '+34 900 123 456', 'Madrid'),
('Distribuidora XYZ', 'María García', 'info@distxyz.com', '+34 900 789 012', 'Barcelona');

-- ============================================
-- VISTAS (REPORTS)
-- ============================================

-- Vista: Resumen de ventas diarias
CREATE VIEW venta_diaria_resumen AS
SELECT 
  DATE(v.fecha_venta) as fecha,
  COUNT(*) as total_ventas,
  SUM(v.total) as total_monto,
  u.usuario as vendedor
FROM ventas v
JOIN usuarios u ON v.usuario_id = u.id
GROUP BY DATE(v.fecha_venta), v.usuario_id;

-- Vista: Medicamentos con bajo stock
CREATE VIEW medicamentos_bajo_stock AS
SELECT 
  m.id,
  m.codigo,
  m.nombre,
  m.stock_minimo,
  i.cantidad_actual,
  c.nombre as categoria
FROM medicamentos m
JOIN inventario i ON m.id = i.medicamento_id
JOIN categorias c ON m.categoria_id = c.id
WHERE i.cantidad_actual <= m.stock_minimo AND m.activo = TRUE;

-- Vista: Top 10 medicamentos más vendidos
CREATE VIEW top_medicamentos_vendidos AS
SELECT 
  m.codigo,
  m.nombre,
  SUM(dv.cantidad) as cantidad_vendida,
  SUM(dv.subtotal) as monto_total,
  COUNT(DISTINCT v.id) as numero_transacciones
FROM medicamentos m
JOIN detalles_ventas dv ON m.id = dv.medicamento_id
JOIN ventas v ON dv.venta_id = v.id
GROUP BY m.id
ORDER BY cantidad_vendida DESC
LIMIT 10;

-- ============================================
-- Fin del script
-- ============================================
