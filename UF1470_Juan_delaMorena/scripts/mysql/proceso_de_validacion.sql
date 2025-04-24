DELIMITER //

CREATE PROCEDURE insertar_cliente (
    IN p_nombre VARCHAR(50),
    IN p_apellido VARCHAR(50),
    IN p_ciudad VARCHAR(50),
    IN p_fecha DATE
)
BEGIN
    IF p_fecha > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de registro no puede ser futura.';
    ELSE
        INSERT INTO clientes (nombre, apellido, ciudad, fecha_registro)
        VALUES (p_nombre, p_apellido, p_ciudad, p_fecha);
    END IF;
END //

DELIMITER ;
