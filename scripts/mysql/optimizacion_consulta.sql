-- Consulta original
SELECT * FROM clientes WHERE ciudad = 'Madrid' AND fecha_registro > '2024-01-01';

-- Solución propuesta
CREATE INDEX idx_ciudad_fecha ON clientes(ciudad, fecha_registro);
