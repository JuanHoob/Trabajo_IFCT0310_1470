@echo off
set FECHA=%DATE:~6,4%-%DATE:~3,2%-%DATE:~0,2%
mysqldump -u root -pTuContrase�a DataSolutionsDB > "C:\backups\DataSolutionsDB_%FECHA%.sql"
