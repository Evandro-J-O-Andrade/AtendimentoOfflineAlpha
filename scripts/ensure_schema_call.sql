-- scripts/ensure_schema_call.sql
USE pronto_atendimento;
CALL sp_ensure_schema();
SELECT 'sp_ensure_schema() executed';
