# INFORME FINAL DE PROYECTO

## UF1470 – Administración de Sistemas Gestores de Bases de Datos (SGBD)

---

### Alumno:

**Juan de la Morena Marzalo**

### Curso:

**IFCT0310 - Administración de Bases de Datos**

### Proyecto:

**Implantación y gestión de bases de datos MySQL y SQLite**
**Automatización de backups y auditoría de datos**
**Monitorización del sistema y optimización de consultas**

### Repositorio GitHub:

🔗 [https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git](https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git)

---

> **Resumen:**
> Este documento detalla el proceso completo de creación, gestión, automatización y monitorización de bases de datos relacionales utilizando MySQL y SQLite, siguiendo buenas prácticas de administración de sistemas de bases de datos. Incluye capturas de evidencia, scripts SQL, automatizaciones programadas y optimizaciones de rendimiento.

---

<div style="page-break-after: always;"></div>

# Índice

### [Parte 1 – MySQL: Configuración y Administración](#parte-1---mysql-configuracion-y-administracion)

- [1. Tipos de bases de datos en DBeaver](#1-vista-general-de-tipos-de-bases-de-datos-en-dbeaver)
- [2. Usuarios DROP IF EXISTS](#2-usuarios-drop-if-exists)
- [3. Crear base de datos MySQL](#3-crear-base-de-datos-mysql)
- [4. Crear tabla clientes (MySQL)](#4-crear-tabla-clientes-mysql)
- [5. Crear índice para optimizar consultas](#5-crear-índice-para-optimizar-consultas)

### [Parte 2 – SQLite: Creación e Inserción de Datos](#parte-2---sqlite-creacion-e-insercion-de-datos)

- [6. Crear base de datos SQLite (nombre)](#6-crear-base-de-datos-sqlite-nombre)
- [7. Definir ruta del archivo SQLite](#7-definir-ruta-del-archivo-sqlite)
- [8. Crear base de datos SQLite](#8-crear-base-de-datos-sqlite)
- [9. Crear tabla clientes SQLite (con DROP IF EXISTS)](#9-crear-tabla-clientes-sqlite-con-drop-if-exists)
- [10. Insertar registros de prueba](#10-insertar-registros-de-prueba)

### [Parte 3 – Automatización y Seguridad](#parte-3---automatizacion-y-seguridad)

- [11. Backup manual de MySQL](#11-backup-manual-de-mysql)
- [12. Crear procedimiento almacenado (MySQL)](#12-crear-procedimiento-almacenado-mysql)
- [13. Ejecutar procedimiento almacenado - correcto](#13-ejecutar-procedimiento-almacenado---correcto)
- [14. Ejecutar procedimiento almacenado - error](#14-ejecutar-procedimiento-almacenado---error)
- [15. Mostrar procesos en ejecución](#15-mostrar-procesos-en-ejecución)
- [16. Kill de procesos bloqueados o pesados](#16-kill-de-procesos-bloqueados-o-pesados)
- [17. Crear Trigger de auditoría](#17-crear-trigger-de-auditoría)
- [18. Ejecutar UPDATE para probar Trigger](#18-ejecutar-update-para-probar-trigger)
- [19. Visualizar registros en log_clientes](#19-visualizar-registros-en-log_clientes)

### [Parte 4 – Planificación de Tareas y Backup](#parte-4---planificacion-de-tareas)

- [20. Script .bat de backup Windows](#20-script-bat-de-backup-windows)
- [21. Crear tarea programada en Windows](#21-crear-tarea-programada-en-windows)
- [22. Nombre y descripción de la tarea](#22-nombre-y-descripción-de-la-tarea)
- [23. Asignación de periodicidad diaria](#23-asignación-de-periodicidad-diaria)
- [24. Seleccionar el script .bat](#24-seleccionar-el-script-bat)
- [25. Opciones avanzadas: ejecutar con privilegios](#25-opciones-avanzadas-ejecutar-con-privilegios)
- [26. Resultado de la tarea programada](#26-resultado-de-la-tarea-programada)
- [27. Backup generado automáticamente](#27-backup-generado-automáticamente)

### [Parte 5 – Monitorización del Rendimiento](#parte-5---monitoreo-de-rendimiento)

- [28. Acceso al Dashboard de DBeaver](#28-acceso-al-dashboard-de-dbeaver)
- [29. Vista general del Dashboard de Monitorización](#29-vista-general-del-dashboard-de-monitorización)
- [30. Estado general del servidor (Server Status)](#30-estado-general-del-servidor-server-status)
- [31. Monitorizar procesos activos (SHOW PROCESSLIST)](#31-monitorizar-procesos-activos-show-processlist)
- [32. EXPLAIN de consultas para optimización](#32-explain-de-consultas-para-optimización)

8. [Anexo: Conversión de Markdown a PDF](#anexo-conversión-de-markdown-a-pdf)

---

<div style="page-break-after: always;"></div>

## Descripción General

Este informe técnico constituye la entrega oficial del módulo **UF1470 – Administración de Sistemas Gestores de Bases de Datos (SGBD)**, correspondiente al certificado de profesionalidad **IFCT0310 – Administración de Bases de Datos**. El trabajo se desarrolla en un entorno simulado que representa una empresa ficticia llamada **DataSolutions S.A.**, especializada en servicios de gestión y análisis de información empresarial.

El objetivo de esta práctica ha sido poner en funcionamiento una infraestructura básica de base de datos relacional, que pueda soportar operaciones habituales de consulta, inserción y mantenimiento de datos, así como implementar medidas de auditoría, seguridad y automatización que forman parte de las responsabilidades habituales de un administrador de bases de datos (DBA).

Durante el desarrollo del informe se han abordado varias tareas técnicas distribuidas en cinco grandes bloques:

### 🧱 Diseño y configuración inicial

Se realizaron operaciones de creación y configuración de bases de datos utilizando **MariaDB** **MySQL** y **SQLite**, incluyendo la definición de esquemas, creación de tablas, e inserción de registros de prueba. Se utilizó el cliente visual **DBeaver** como interfaz de administración para facilitar la conexión y gestión de ambos sistemas.

### 🔒 Seguridad y gestión de usuarios

Se definieron usuarios con distintos niveles de permisos, incluyendo perfiles con acceso restringido a determinadas operaciones o tablas. Esta separación de roles permite garantizar la integridad de los datos y limitar posibles errores o accesos indebidos por parte de los distintos actores del sistema.

### ⚙️ Optimización, procedimientos y auditoría

Se diseñaron e implementaron índices para mejorar el rendimiento de consultas complejas. Asimismo, se desarrolló un **procedimiento almacenado** en MySQL con validación lógica para la inserción de registros, y se configuró un **trigger de auditoría en SQLite** para llevar un control sobre las actualizaciones realizadas en las tablas principales.

### 🔁 Automatización de tareas críticas

Se creó un script de copia de seguridad para exportar los datos de forma periódica y se configuró el **Programador de Tareas de Windows** para su ejecución automática. Esta tarea es fundamental en cualquier sistema productivo para minimizar el riesgo de pérdida de información ante fallos.

### 📊 Monitorización y supervisión del sistema

Se utilizaron las herramientas de monitorización de **DBeaver** y comandos SQL de diagnóstico para identificar cuellos de botella, procesos bloqueantes y rendimiento de las consultas. Además, se exploraron comandos de gestión de procesos y análisis de planes de ejecución mediante `EXPLAIN`.

---

Este informe ha sido documentado paso a paso y contiene:

- Código SQL comentado para cada sección.
- Capturas de pantalla que demuestran la correcta ejecución de cada acción.
- Scripts reales listos para ser usados o adaptados.
- Un enfoque pedagógico pensado para que cualquier lector —incluso sin experiencia previa— pueda seguir el flujo de trabajo, entender las decisiones técnicas y replicar el proceso.

El informe ha sido redactado en **formato Markdown**, y exportado a PDF mediante el editor **Typora**, con estructura paginada, índice automático e imágenes embebidas. Todo el código y material utilizado está disponible también en el siguiente repositorio público de GitHub para su consulta técnica:

🔗 [https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git](https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git)

---

Esta documentación representa, además de una prueba de competencias técnicas, un modelo realista de cómo se debe estructurar un proyecto de administración de bases de datos desde cero, considerando criterios de **seguridad**, **rendimiento**, **documentación** y **automatización**.

---

<div style="page-break-after: always;"></div>

## Parte 1 - MySQL: Configuración y Administración

### 1. Creación de la Base de Datos

```sql
CREATE DATABASE DataSolutionsDB;
```

> _Explicación:_ Crea la base de datos vacía donde se alojarán todas las tablas y datos de clientes.

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

> _Explicación:_ Se crean dos perfiles de acceso para separar responsabilidades y minimizar riesgos.

> _Nota:_ he utilizado en el ejemplo de la captura de pantalla el comando DROP if exist ya que un nombre genérico puede que se haya creado de antemano y quieras pisarlo, de esta forma no te daría error y puedes estar seguro de crear tu usuario en el lugar que quieres.

> _Consideraciones:_ Se ha de tener en cuenta que durante todo el ejercicio que la nomenclatura cambia según la base de datos que se utilice Mqlite, MariaDB o MySQL.

---

<div style="page-break-after: always;"></div>

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

> _Detalle:_ Un índice compuesto en `(ciudad, fecha_registro)` permite filtrar rápidamente por ambos campos.
> _Consideraciones:_ Si la columna `ciudad` tiene poca selectividad (p. ej. muchos “Madrid”), el beneficio será menor. Agregar índices también impacta ligeramente las inserciones/actualizaciones.

---

### 4. Gestión de Procesos Lentos

```sql
SHOW PROCESSLIST;
-- Identificar ID del proceso pesado:
KILL <ID_DEL_PROCESO>;
```

> _Explicación:_ Con `SHOW PROCESSLIST` vemos las consultas activas y podemos abortar las que bloquean recursos.

---

<div style="page-break-after: always;"></div>

## Parte 2 - SQLite: Creación e Inserción de Datos

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

> _Nota:_ SQLite no gestiona usuarios; la seguridad se delega al sistema de archivos. Además se ha de tener en cuenta en el ejercicio que hay que cambiar de nomenclatura para la creación de tabla según la base de datos que se esté usando.

---

<div style="page-break-after: always;"></div>

## Parte 3 - Automatización y Seguridad

### 1. Copia de Seguridad (MySQL)

```sql
CREATE TABLE clientes_backup AS
  SELECT * FROM clientes;
```

> _Explicación:_ Clona los datos en una tabla de respaldo instantánea.

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

> _Desafíos:_ Manejar el cambio de delimitador correctamente y asegurar privilegios para `SIGNAL`.

---

<div style="page-break-after: always;"></div>

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

> _Detalle:_ SQLite 3.38+ requerido para funciones JSON; los triggers no admiten múltiples sentencias sin envolver.

---

<div style="page-break-after: always;"></div>

## Parte 4 - Planificación de Tareas

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

#### Observaciones Importantes

- El archivo `backup_windows.bat` debe tener permisos de ejecución adecuados.
- La contraseña de MySQL debe estar escrita en el script si se desea ejecución sin intervención manual.
- La tarea se ejecutará siempre que el equipo esté encendido a la hora programada.
- La copia de seguridad se almacenará en la ruta especificada en el `.bat` (`C:\backups\`).

---

---

<div style="page-break-after: always;"></div>

## Parte 5 - Monitoreo de Rendimiento

- **MySQL Workbench**: Performance Dashboard y Query Analyzer
- **DBeaver**: Monitorización en vivo
- Comandos clave:
  ```sql
  SHOW STATUS LIKE '%slow_queries%';
  SHOW PROCESSLIST;
  EXPLAIN ANALYZE SELECT …;
  ```

---

<div style="page-break-after: always;"></div>

## Capturas de Pantalla Organizadas

### Parte 1 – MySQL: Configuración y Administración

#### 1. Vista general de tipos de bases de datos en DBeaver

![Tipos de bases de datos en DBeaver](capturas_dbeaver/creacion_bd.png)

> [Ver imagen a tamaño real](capturas_dbeaver/creacion_bd.png)

<div style="page-break-after: always;"></div>

#### 2. Usuarios DROP IF EXISTS

![Eliminar usuarios si existen](capturas_dbeaver/UsersDropIf.png)

> [Ver imagen a tamaño real](capturas_dbeaver/UsersDropIf.png)

<div style="page-break-after: always;"></div>

#### 3. Crear base de datos MySQL

![Crear base de datos MySQL](capturas_dbeaver/CreateDBMySql.png)

> [Ver imagen a tamaño real](capturas_dbeaver/CreateDBMySql.png)

<div style="page-break-after: always;"></div>

#### 4. Crear tabla clientes (MySQL)

![Crear tabla en MySQL](capturas_dbeaver/create_table.png)

> [Ver imagen a tamaño real](capturas_dbeaver/create_table.png)

<div style="page-break-after: always;"></div>

#### 5. Crear índice para optimizar consultas

![Crear índice en clientes](capturas_dbeaver/createIndexMejoradeconsultas.png)

> [Ver imagen a tamaño real](capturas_dbeaver/createIndexMejoradeconsultas.png)

---

<div style="page-break-after: always;"></div>

### Parte 2 – SQLite: Creación e Inserción de Datos

#### 6. Crear base de datos SQLite (nombre)

![Nombre BD SQLite](capturas_dbeaver/nombreSqliteDB.png)

> [Ver imagen a tamaño real](capturas_dbeaver/nombreSqliteDB.png)

<div style="page-break-after: always;"></div>

#### 7. Definir ruta del archivo SQLite

![Ruta archivo SQLite](capturas_dbeaver/pathsqliteDB.png)

> [Ver imagen a tamaño real](capturas_dbeaver/pathsqliteDB.png)

<div style="page-break-after: always;"></div>

#### 8. Crear base de datos SQLite

![Crear BD SQLite](capturas_dbeaver/CreateDBSqlite.png)

> [Ver imagen a tamaño real](capturas_dbeaver/CreateDBSqlite.png)

<div style="page-break-after: always;"></div>

#### 9. Crear tabla clientes SQLite (con DROP IF EXISTS)

![Crear tabla SQLite](capturas_dbeaver/create_tableSQLite_conDrop.png)

> [Ver imagen a tamaño real](capturas_dbeaver/create_tableSQLite_conDrop.png)

<div style="page-break-after: always;"></div>

#### 10. Insertar registros de prueba

![Insertar registros](capturas_dbeaver/insertandoData.png)

> [Ver imagen a tamaño real](capturas_dbeaver/insertandoData.png)

---

<div style="page-break-after: always;"></div>

### Parte 3 – Automatización y Seguridad

#### 11. Backup manual de MySQL

![Backup manual SQL](capturas_dbeaver/backupSQL.png)

> [Ver imagen a tamaño real](capturas_dbeaver/backupSQL.png)

<div style="page-break-after: always;"></div>

#### 12. Crear procedimiento almacenado (MySQL)

![Crear procedimiento](capturas_dbeaver/procedure.png)

> [Ver imagen a tamaño real](capturas_dbeaver/procedure.png)

<div style="page-break-after: always;"></div>

#### 13. Ejecutar procedimiento almacenado - correcto

![CALL procedimiento correcto](capturas_dbeaver/CALLcomprobaciónProcedure.png)

> [Ver imagen a tamaño real](capturas_dbeaver/CALLcomprobaciónProcedure.png)

<div style="page-break-after: always;"></div>

#### 14. Ejecutar procedimiento almacenado - error

![CALL procedimiento error](capturas_dbeaver/CALcomprobaciónProcedure2.png)

> [Ver imagen a tamaño real](capturas_dbeaver/CALcomprobaciónProcedure2.png)

<div style="page-break-after: always;"></div>

#### 15. Mostrar procesos en ejecución

![Mostrar procesos activos](capturas_dbeaver/ShowProcess.png)

> [Ver imagen a tamaño real](capturas_dbeaver/ShowProcess.png)

<div style="page-break-after: always;"></div>

#### 16. Kill de procesos bloqueados o pesados (slow_process)

![Kill procesos](capturas_dbeaver/killprocess.png)

> [Ver imagen a tamaño real](capturas_dbeaver/killprocess.png)

<div style="page-break-after: always;"></div>

#### 17. Crear Trigger de auditoría

![Crear Trigger Audit](capturas_dbeaver/creadoTriggerAudit.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/creadoTriggerAudit.PNG)

<div style="page-break-after: always;"></div>

#### 18. Ejecutar UPDATE para probar Trigger

![Prueba UPDATE Trigger](capturas_dbeaver/pruebaUPDATE_trigger.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/pruebaUPDATE_trigger.PNG)

<div style="page-break-after: always;"></div>

#### 19. Visualizar registros en log_clientes

![Log clientes actualizado](capturas_dbeaver/log_clientescreado.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/log_clientescreado.PNG)

---

<div style="page-break-after: always;"></div>

### Parte 4 – Planificación de Tareas y Backup

#### 20. Script .bat de backup Windows

![Script de backup Windows](capturas_dbeaver/ScriptbatWin.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/ScriptbatWin.PNG)

<div style="page-break-after: always;"></div>

#### 21. Crear tarea programada en Windows

![Programador de tareas crear](capturas_dbeaver/programador_de_tareas_crear.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/programador_de_tareas_crear.PNG)

<div style="page-break-after: always;"></div>

#### 22. Nombre y descripción de la tarea

![Nombre y descripción tarea](capturas_dbeaver\nombre_y_descipcion_tarea.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver\nombre_y_descipcion_tarea.PNG)

<div style="page-break-after: always;"></div>

#### 23. Asignación de periodicidad diaria

![Asignación de temporalidad](capturas_dbeaver\asignación_de_temporalidad_tarea.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver\asignación_de_temporalidad_tarea.PNG)

<div style="page-break-after: always;"></div>

#### 24. Seleccionar el script .bat

![Path de script](capturas_dbeaver/PathDeScript.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/PathDeScript.PNG)

<div style="page-break-after: always;"></div>

#### 25. Opciones avanzadas: ejecutar con privilegios

![Uso del inicio de programa](capturas_dbeaver\usoDeInicioProgramatareas.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver\usoDeInicioProgramatareas.PNG)

<div style="page-break-after: always;"></div>

#### 26. Resultado de la tarea progr

![Resultado ejecución de tarea](capturas_dbeaver/resultado_tarea_programada.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/resultado_tarea_programada.PNG)

<div style="page-break-after: always;"></div>

#### 27. Backup generado automáticamente

![Backup realizado automáticamente](capturas_dbeaver/backupAutoRealizado.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/backupAutoRealizado.PNG)

---

<div style="page-break-after: always;"></div>

### Parte 5 – Monitorización del Rendimiento

#### 28. Acceso al Dashboard de DBeaver

![Localización Dashboard](capturas_dbeaver/MonitorinDondeDashboard.png)

> [Ver imagen a tamaño real](capturas_dbeaver/MonitorinDondeDashboard.png)

<div style="page-break-after: always;"></div>

#### 29. Vista general del Dashboard de Monitorización

![Vista Dashboard Monitor](capturas_dbeaver\monitorigDashboard.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver\monitorigDashboard.PNG)

<div style="page-break-after: always;"></div>

#### 30. Estado general del servidor (Server Status)

![Server Status DBeaver](capturas_dbeaver/monitoreoStatus.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/monitoreoStatus.PNG)

<div style="page-break-after: always;"></div>

#### 31. Monitorizar procesos activos (SHOW PROCESSLIST)

![Monitor procesos](capturas_dbeaver/MonitoringShowProcess.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/MonitoringShowProcess.PNG)

<div style="page-break-after: always;"></div>

#### 32. EXPLAIN de consultas para optimización

![EXPLAIN consultas](capturas_dbeaver/MonitoringExplain.PNG)

> [Ver imagen a tamaño real](capturas_dbeaver/MonitoringExplain.PNG)

---

<div style="page-break-after: always;"></div>

## Conclusiones

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

> 🔗 **Repositorio de consulta:** > https://github.com/JuanHoob/Trabajo_IFCT0310_1470.git
