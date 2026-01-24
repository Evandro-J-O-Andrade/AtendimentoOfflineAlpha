
	DELIMITER $$
 DROP TRIGGER IF EXISTS `trg_auditoria_atendimento_update`$$
 CREATE TRIGGER `trg_auditoria_atendimento_update` AFTER UPDATE ON `atendimento` FOR EACH ROW
 BEGIN
     INSERT INTO log_auditoria(
         id_usuario, acao, tabela_afetada, id_regist
	DELIMITER $$
 DROP TRIGGER IF EXISTS `trg_auditoria_ffa_insert`$$
 CREATE TRIGGER `trg_auditoria_ffa_insert` AFTER INSERT ON `ffa` FOR EACH ROW
 BEGIN
     INSERT INTO log_auditoria(
         id_usuario, acao, tabela_afetada, id_registro, antes, depois, data_hora
     )
     VALUES (
         NEW.id_usuario_criacao,
         'INSERT',
         'ffa',
         NEW.id,
         NULL,
         CONCAT('status: ', NEW.status, ', paciente: ', NEW.id_paciente),
         NOW()
     );
 END$$
 DELIMITER ;
 
	DELIMITER $$
 DROP TRIGGER IF EXISTS `trg_bloqueia_ffa_finalizada`$$
 CREATE TRIGGER `trg_bloqueia_ffa_finalizada` BEFORE UPDATE ON `ffa` FOR EACH ROW
 BEGIN
     IF OLD.status IN ('ALTA','TRANSFERENCIA') THEN
         SIGNAL SQLSTATE '45000' 
         SET MES
	DELIMITER $$
 DROP TRIGGER IF EXISTS `trg_libera_leito`$$
 CREATE TRIGGER `trg_libera_leito` AFTER UPDATE ON `internacao` FOR EACH ROW
 BEGIN
     IF OLD.status = 'ATIVA'
        AND NEW.status = 'ENCERRADA' THEN
 
         UPDATE leito
            SET status = 
	DELIMITER $$
 DROP TRIGGER IF EXISTS `trg_ocupa_leito`$$
 CREATE TRIGGER `trg_ocupa_leito` BEFORE INSERT ON `internacao` FOR EACH ROW
 BEGIN
     IF NEW.status = 'ATIVA' THEN
 
         IF NOT EXISTS (
             SELECT 1
             FROM leito
             WH
	DELIMITER $$
 DROP TRIGGER IF EXISTS `trg_unica_internacao_ativa`$$
 CREATE TRIGGER `trg_unica_internacao_ativa` BEFORE INSERT ON `internacao` FOR EACH ROW
 BEGIN
     IF EXISTS (
         SELECT 1
         FROM internacao
         WHERE id_ffa = NEW.id_ffa
    