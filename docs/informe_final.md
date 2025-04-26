# 📘 Informe Oficial del Proyecto UF1470

**Módulo:** UF1470 – Administración de Sistemas Gestores de Bases de Datos (SGBD)  
**Alumno:** Juan de la Morena  
**Fecha de entrega:** _(añadir fecha)_  
**Cliente de BD utilizado:** DBeaver  
**Entorno de trabajo:** Windows 10  
**Repositorio público para consulta:**  
🔗 [https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git](https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git)

---

## 📝 Descripción General

Este informe documenta de forma detallada la realización de la prueba práctica integral como DBA en la empresa ficticia **DataSolutions S.A.**. Incluye:

- Código SQL organizado por tareas  
- Explicaciones pedagógicas paso a paso  
- Espacios para capturas de pantalla como evidencia  
- Scripts de automatización  
- Buenas prácticas de seguridad, rendimiento y documentación  

Este documento será la **entrega oficial** en PDF; el repositorio GitHub sirve como referencia complementaria.

---

## 🧩 Parte 1 – MySQL: Configuración y Administración

### 1. Creación de la Base de Datos

```sql
CREATE DATABASE DataSolutionsDB;
```
> *Explicación:* Crea la base de datos vacía donde se alojarán todas las tablas y datos de clientes.

---

### 2. Gestión de Usuarios y Permisos

```sql
-- Usuario consultor (solo lectura)
CREATE USER 'consultor'@'localhost' IDENTIFIED BY 'TuContraseña123';
GRANT SELECT ON DataSolutionsDB.* TO 'consultor'@'localhost';

-- Usuario admin_ventas (lectura, inserción, actualización en tabla clientes)
CREATE USER 'admin_ventas'@'localhost' IDENTIFIED BY 'TuContraseña123';
GRANT SELECT, INSERT, UPDATE
  ON DataSolutionsDB.clientes
  TO 'admin_ventas'@'localhost';
```
> *Explicación:* Se crean dos perfiles de acceso para separar responsabilidades y minimizar riesgos.

---

### 3. Optimización de Consultas

#### Consulta original

```sql
SELECT *
  FROM clientes
 WHERE ciudad = 'Madrid'
   AND fecha_registro > '2024-01-01';
```

#### Problema detectado

Sin índice, MySQL realiza un _full table scan_, revisando fila a fila, lo cual se vuelve muy lento si la tabla crece.

#### Solución propuesta

```sql
CREATE INDEX idx_ciudad_fecha
  ON clientes(ciudad, fecha_registro);
```
> *Detalle:* Un índice compuesto en `(ciudad, fecha_registro)` permite filtrar rápidamente por ambos campos.  
> *Consideraciones:* Si la columna `ciudad` tiene poca selectividad (p. ej. muchos “Madrid”), el beneficio será menor. Agregar índices también impacta ligeramente las inserciones/actualizaciones.

---

### 4. Gestión de Procesos Lentos

```sql
SHOW PROCESSLIST;
-- Identificar ID del proceso pesado:
KILL <ID_DEL_PROCESO>;
```
> *Explicación:* Con `SHOW PROCESSLIST` vemos las consultas activas y podemos abortar las que bloquean recursos.

---

## 🗄️ Parte 2 – SQLite: Creación e Inserción de Datos

### 1. Creación de la Tabla

```sql
CREATE TABLE clientes (
  id INTEGER PRIMARY KEY,
  nombre TEXT,
  apellido TEXT,
  ciudad TEXT,
  fecha_registro DATE
);
```

### 2. Inserción de Registros de Ejemplo

```sql
INSERT INTO clientes (nombre, apellido, ciudad, fecha_registro) VALUES
  ('Juan', 'Pérez', 'Madrid',   '2024-02-15'),
  ('Ana',  'López', 'Barcelona', '2023-11-03'),
  ('Luis', 'Martínez','Sevilla', '2024-01-21'),
  ('Clara','Ramírez','Valencia', '2022-09-12'),
  ('Mario','Gómez',  'Madrid',   '2024-03-01');
```
> *Nota:* SQLite no gestiona usuarios; la seguridad se delega al sistema de archivos.

---

## 🔐 Parte 3 – Automatización y Seguridad

### 1. Copia de Seguridad (MySQL)

```sql
CREATE TABLE clientes_backup AS
  SELECT * FROM clientes;
```
> *Explicación:* Clona los datos en una tabla de respaldo instantánea.

---

### 2. Procedimiento Almacenado de Validación

```sql
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
      SET MESSAGE_TEXT = 'La fecha no puede ser futura.';
  ELSE
    INSERT INTO clientes (nombre, apellido, ciudad, fecha_registro)
      VALUES (p_nombre, p_apellido, p_ciudad, p_fecha);
  END IF;
END //

DELIMITER ;
```
> *Desafíos:* Manejar el cambio de delimitador correctamente y asegurar privilegios para `SIGNAL`.

---

### 3. Trigger de Auditoría (SQLite)

```sql
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
    fecha_modificacion, usuario, operacion,
    datos_antiguos, datos_nuevos
  ) VALUES (
    datetime('now'),
    'usuario_windows',
    'UPDATE',
    json_object(
      'id', OLD.id,
      'nombre', OLD.nombre,
      'apellido', OLD.apellido,
      'ciudad', OLD.ciudad,
      'fecha_registro', OLD.fecha_registro
    ),
    json_object(
      'id', NEW.id,
      'nombre', NEW.nombre,
      'apellido', NEW.apellido,
      'ciudad', NEW.ciudad,
      'fecha_registro', NEW.fecha_registro
    )
  );
END;
```
> *Detalle:* SQLite 3.38+ requerido para funciones JSON; los triggers no admiten múltiples sentencias sin envolver.

---

## 🚀 Parte 4 – Planificación de Tareas

### Script de Backup Automático (Windows)

Guárdalo como `tareas_programadas/backup_windows.bat`:

```bat
@echo off
set FECHA=%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%
mysqldump -u root -pTuContraseña DataSolutionsDB ^
  > "C:\backups\DataSolutionsDB_%FECHA%.sql"
```

### Programador de Tareas de Windows

1. Abrir “Programador de Tareas”  
2. Crear tarea básica diaria  
3. Señalar el script `.bat` y configurar hora de ejecución  

---

## 📊 Parte 5 – Monitoreo de Rendimiento

- **MySQL Workbench**: Performance Dashboard y Query Analyzer  
- **DBeaver**: Monitorización en vivo  
- Comandos clave:
   ```sql
   SHOW STATUS LIKE '%slow_queries%';
   SHOW PROCESSLIST;
   EXPLAIN ANALYZE SELECT …;
   ```

---

## 🖼️ Capturas de Pantalla

### 1. Creación de base de datos en MySQL
![Creación de base de datos](capturas_dbeaver/creacion_bd.png)

### 2. Creación de tabla en MySQL
![Creación de tabla](capturas_dbeaver/create_table.png)

### 3. Creación de tabla en SQLite con Drop
![Crear tabla SQLite con DROP](capturas_dbeaver/create_tableSQLite_conDrop.png)

### 4. Crear base de datos MySQL
![Create DB MySQL](capturas_dbeaver/CreateDBMySql.png)

### 5. Crear base de datos SQLite
![Create DB SQLite](capturas_dbeaver/CreateDBSqlite.png)

### 6. Nombre de base de datos en SQLite
![Nombre DB SQLite](capturas_dbeaver/nombreSqliteDB.png)

### 7. Ruta del fichero SQLite
![Ruta DB SQLite](capturas_dbeaver/pathsqliteDB.png)

### 8. Crear índice para mejorar consultas
![Crear índice](capturas_dbeaver/createIndexMejoradeconsultas.png)

### 9. Insertar datos en la tabla
![Insertar datos](capturas_dbeaver/insertandoData.png)

### 10. Usuarios: DROP IF EXISTS
![Usuarios DROP IF](capturas_dbeaver/UsersDropIf.png)

### 11. Procedimiento almacenado creado
![Procedimiento almacenado](capturas_dbeaver/procedure.png)

### 12. Ejecución del procedimiento (caso correcto)
![CALL comprobación procedimiento](capturas_dbeaver/CALLcomprobaciónProcedure.png)

### 13. Ejecución del procedimiento (caso con error)
![CALL comprobación procedimiento 2](capturas_dbeaver/CALLcomprobaciónProcedure2.png)

### 14. Kill de procesos pesados
![Kill procesos](capturas_dbeaver/killprocess.png)

### 15. Mostrar procesos activos
![Mostrar procesos](capturas_dbeaver/ShowProcess.png)

### 16. Backup realizado en MySQL
![Backup SQL](capturas_dbeaver/backupSQL.png)


## 🎓 Conclusiones

Este proyecto ha permitido:

- Aplicar de forma práctica los conceptos de diseño y administración de SGBD  
- Automatizar tareas críticas de respaldo y validación  
- Implementar auditoría y control de acceso  
- Documentar profesionalmente un proyecto técnico en GitHub  

> **Mejoras futuras:** Uso de Docker para entornos reproducibles y Percona PMM para monitorización avanzada.

---

## ⚙️ Herramientas Utilizadas

- **DBeaver**  
- **MySQL Server**  
- **SQLite3**  
- **Visual Studio Code** + Markdown PDF  
- **PowerShell / Programador de Tareas (Windows)**  
- **Git & GitHub**  

---

> 🔗 **Repositorio de consulta:**  
> https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git

