CREATE TABLE log_clientes (
    fecha_modificacion TEXT,
    usuario TEXT,
    operacion TEXT,
    datos_antiguos TEXT,
    datos_nuevos TEXT
);

CREATE TRIGGER trigger_log_update
AFTER UPDATE ON clientes
BEGIN
    INSERT INTO log_clientes (
        fecha_modificacion,
        usuario,
        operacion,
        datos_antiguos,
        datos_nuevos
    )
    VALUES (
        datetime('now'),
        'usuario_windows',
        'UPDATE',
        json_object('id', OLD.id, 'nombre', OLD.nombre, 'apellido', OLD.apellido, 'ciudad', OLD.ciudad, 'fecha_registro', OLD.fecha_registro),
        json_object('id', NEW.id, NEW.nombre, NEW.apellido, NEW.ciudad, NEW.fecha_registro)
    );
END;
