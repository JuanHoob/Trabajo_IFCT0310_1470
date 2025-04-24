CREATE USER 'consultor'@'localhost' IDENTIFIED BY 'TuContraseña123';
GRANT SELECT ON DataSolutionsDB.* TO 'consultor'@'localhost';

CREATE USER 'admin_ventas'@'localhost' IDENTIFIED BY 'TuContraseña123';
GRANT SELECT, INSERT, UPDATE ON DataSolutionsDB.clientes TO 'admin_ventas'@'localhost';
