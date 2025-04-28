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
> *Nota:* he utilizado en el ejemplo de la captura de pantalla el comando DROP if exist ya que un nombre genérico puede que se haya creado y queieras pisarlo de esta forma no te daría error y puedes estar seguro de crear tu usuario en el lugar que quieres

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
> *Nota:* SQLite no gestiona usuarios; la seguridad se delega al sistema de archivos. Además se ha de tener en cuenta en el ejercicio que hay que cambiar de nomenclatura para la creación de tabla según la base de datos que se esté usando.

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
#### Automatización de Backup - Programador de Tareas de Windows

Una vez creado el script de copia de seguridad `backup_windows.bat`, se procedió a su automatización mediante el Programador de tareas de Windows.

#### 1. Apertura del Programador de tareas

- Se accede a **Programador de tareas** desde el menú Inicio de Windows.

#### 2. Creación de una nueva tarea básica

- Se selecciona la opción **Crear tarea básica**.
- Se asigna:
  - **Nombre**: `Backup automático base de datos`
  - **Descripción**: `Realiza automáticamente una copia de seguridad de la base de datos MySQL cada día.`

#### 3. Configuración de la frecuencia

- Se elige ejecutar la tarea **Diariamente**.

#### 4. Programación de la hora de ejecución

- Se establece una **hora fija** de ejecución diaria (por ejemplo, 20:00 h).

#### 5. Selección de la acción

- Se configura la tarea para **Iniciar un programa**.
- Se selecciona el archivo `backup_windows.bat` previamente creado.

#### 6. Revisión y finalización

- Se revisa el resumen de la tarea.
- Se pulsa en **Finalizar** para dejar programada la ejecución automática.

---

#### 📋 Observaciones Importantes

- El archivo `backup_windows.bat` debe tener permisos de ejecución adecuados.
- La contraseña de MySQL debe estar escrita en el script si se desea ejecución sin intervención manual.
- La tarea se ejecutará siempre que el equipo esté encendido a la hora programada.
- La copia de seguridad se almacenará en la ruta especificada en el `.bat` (`C:\backups\`).

---

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

## 🖼️ Capturas de Pantalla Organizadas

### Parte 1 – MySQL: Configuración y Administración

#### 1. Vista general de tipos de bases de datos en DBeaver
![Tipos de bases de datos en DBeaver](docs/capturas_dbeaver/creacion_bd.png)
> [Ver imagen a tamaño real](docs/capturas_dbeaver/creacion_bd.png)

#### 2. Usuarios DROP IF EXISTS
![Eliminar usuarios si existen](capturas_dbeaver/UsersDropIf.png)
> [Ver imagen a tamaño real](capturas_dbeaver/UsersDropIf.png)

#### 3. Crear base de datos MySQL
![Crear base de datos MySQL](docs/capturas_dbeaver/CreateDBMySql.png)
> [Ver imagen a tamaño real](docs/capturas_dbeaver/CreateDBMySql.png)

#### 4. Crear tabla clientes (MySQL)
![Crear tabla en MySQL](docs/capturas_dbeaver/create_table.png)
> [Ver imagen a tamaño real](docs/capturas_dbeaver/create_table.png)

#### 5. Crear índice para optimizar consultas
![Crear índice en clientes](docs/capturas_dbeaver/createIndexMejoradeconsultas.png)
> [Ver imagen a tamaño real](docs/capturas_dbeaver/createIndexMejoradeconsultas.png)

---

### Parte 2 – SQLite: Creación e Inserción de Datos

#### 6. Crear base de datos SQLite (nombre)
![Nombre BD SQLite](capturas_dbeaver/nombreSqliteDB.png)
> [Ver imagen a tamaño real](capturas_dbeaver/nombreSqliteDB.png)

#### 7. Definir ruta del archivo SQLite
![Ruta archivo SQLite](capturas_dbeaver/pathsqliteDB.png)
> [Ver imagen a tamaño real](capturas_dbeaver/pathsqliteDB.png)

#### 8. Crear base de datos SQLite
![Crear BD SQLite](capturas_dbeaver/CreateDBSqlite.png)
> [Ver imagen a tamaño real](capturas_dbeaver/CreateDBSqlite.png)

#### 9. Crear tabla clientes SQLite (con DROP IF EXISTS)
![Crear tabla SQLite](capturas_dbeaver/create_tableSQLite_conDrop.png)
> [Ver imagen a tamaño real](capturas_dbeaver/create_tableSQLite_conDrop.png)

#### 10. Insertar registros de prueba
![Insertar registros](capturas_dbeaver/insertandoData.png)
> [Ver imagen a tamaño real](capturas_dbeaver/insertandoData.png)

---

### Parte 3 – Automatización y Seguridad

#### 11. Backup manual de MySQL
![Backup manual SQL](capturas_dbeaver/backupSQL.png)
> [Ver imagen a tamaño real](capturas_dbeaver/backupSQL.png)

#### 12. Crear procedimiento almacenado (MySQL)
![Crear procedimiento](capturas_dbeaver/procedure.png)
> [Ver imagen a tamaño real](capturas_dbeaver/procedure.png)

#### 13. Ejecutar procedimiento almacenado - correcto
![CALL procedimiento correcto](capturas_dbeaver/CALLcomprobaciónProcedure.png)
> [Ver imagen a tamaño real](capturas_dbeaver/CALLcomprobaciónProcedure.png)

#### 14. Ejecutar procedimiento almacenado - error
![CALL procedimiento error](capturas_dbeaver/CALcomprobaciónProcedure2.png)
> [Ver imagen a tamaño real](capturas_dbeaver/CALcomprobaciónProcedure2.png)

#### 15. Mostrar procesos en ejecución
![Mostrar procesos activos](capturas_dbeaver/ShowProcess.png)
> [Ver imagen a tamaño real](capturas_dbeaver/ShowProcess.png)

#### 16. Kill de procesos bloqueados o pesados (slow_process)
![Kill procesos](capturas_dbeaver/killprocess.png)
> [Ver imagen a tamaño real](docs/capturas_dbeaver/killprocess.png)

#### 17. Crear Trigger de auditoría
![Crear Trigger Audit](capturas_dbeaver/creadoTriggerAudit.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/creadoTriggerAudit.PNG)

#### 18. Ejecutar UPDATE para probar Trigger
![Prueba UPDATE Trigger](capturas_dbeaver/pruebaUPDATE_trigger.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/pruebaUPDATE_trigger.PNG)

#### 19. Visualizar registros en log_clientes
![Log clientes actualizado](capturas_dbeaver/log_clientescreado.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/log_clientescreado.PNG)

---

### Parte 4 – Planificación de Tareas y Backup

#### 20. Script .bat de backup Windows
![Script de backup Windows](capturas_dbeaver/ScriptbatWin.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/ScriptbatWin.PNG)

#### 21. Crear tarea programada en Windows
![Programador de tareas crear](capturas_dbeaver/programador_de_tareas_crear.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/programador_de_tareas_crear.PNG)

#### 22. Nombre y descripción de la tarea
![Nombre y descripción tarea](capturas_dbeaver/nombre_y_descripcion_tarea.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/nombre_y_descripcion_tarea.PNG)

#### 23. Asignación de periodicidad diaria
![Asignación de temporalidad](capturas_dbeaver/asignacion_de_temporalidad_tarea.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/asignacion_de_temporalidad_tarea.PNG)

#### 24. Seleccionar el script .bat
![Path de script](capturas_dbeaver/PathDeScript.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/PathDeScript.PNG)

#### 25. Opciones avanzadas: ejecutar con privilegios
![Uso del inicio de programa](capturas_dbeaver/usoDelinicioPrograma.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/usoDelinicioPrograma.PNG)

#### 26. Resultado de la tarea progr
![Resultado ejecución de tarea](capturas_dbeaver/resultado_tarea_programada.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/resultado_tarea_programada.PNG)

#### 27. Backup generado automáticamente
![Backup realizado automáticamente](capturas_dbeaver/backupAutoRealizado.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/backupAutoRealizado.PNG)

---

### Parte 5 – Monitorización del Rendimiento

#### 28. Acceso al Dashboard de DBeaver
![Localización Dashboard](capturas_dbeaver/MonitorinDondeDashboard.png)
> [Ver imagen a tamaño real](capturas_dbeaver/MonitorinDondeDashboard.png)

#### 29. Vista general del Dashboard de Monitorización
![Vista Dashboard Monitor](capturas_dbeaver/monitoringDashboard.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/monitoringDashboard.PNG)

#### 30. Estado general del servidor (Server Status)
![Server Status DBeaver](capturas_dbeaver/monitoreoStatus.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/monitoreoStatus.PNG)

#### 31. Monitorizar procesos activos (SHOW PROCESSLIST)
![Monitor procesos](capturas_dbeaver/MonitoringShowProcess.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/MonitoringShowProcess.PNG)

#### 32. EXPLAIN de consultas para optimización
![EXPLAIN consultas](capturas_dbeaver/MonitoringExplain.PNG)
> [Ver imagen a tamaño real](capturas_dbeaver/MonitoringExplain.PNG)

---

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

