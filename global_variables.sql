# Session variable
SET @salary = 10000;


# Global
SET GLOBAL max_connections = 1000;


# Global only! Can not be set in session variable
SET SESSION max_connections = 1000;


# This can be illustrated by trying to lob into another session on workbench. ERROR
SET @@global.max_connections = 1;


# Can be set as session or global
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES, NO_ZERO_DATE, NO_AUTO_CREATE_USER, NO_ENGINE_SUBSTITUTION';

SET SESSION sql_mode = 'STRICT_TRANS_TABLES, NO_ZERO_DATE, NO_AUTO_CREATE_USER, NO_ENGINE_SUBSTITUTION';
