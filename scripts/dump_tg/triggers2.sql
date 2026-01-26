SET FOREIGN_KEY_CHECKS = 0;

DROP TRIGGER IF EXISTS trg_unica_internacao_ativa;
DELIMITER $$

CREATE TRIGGER trg_unica_internacao_ativa
BEFORE INSERT ON internacao
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM internacao
        WHERE id_ffa = NEW.id_ffa
          AND status = 'ATIVA'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Já existe uma internação ativa para este FFA';
    END IF;
END$$

DELIMITER ;
SET FOREIGN_KEY_CHECKS = 1;


SET FOREIGN_KEY_CHECKS = 0;

DROP TRIGGER IF EXISTS trg_ocupa_leito;
DELIMITER $$

CREATE TRIGGER trg_ocupa_leito
BEFORE INSERT ON internacao
FOR EACH ROW
BEGIN
    IF NEW.status = 'ATIVA' THEN

        IF NOT EXISTS (
            SELECT 1
            FROM leito
            WHERE id_leito = NEW.id_leito
              AND status = 'LIVRE'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Leito não está disponível';
        END IF;

        UPDATE leito
           SET status = 'OCUPADO'
         WHERE id_leito = NEW.id_leito;
    END IF;
END$$

DELIMITER ;


DROP TRIGGER IF EXISTS trg_libera_leito;
DELIMITER $$

CREATE TRIGGER trg_libera_leito
AFTER UPDATE ON internacao
FOR EACH ROW
BEGIN
    IF OLD.status = 'ATIVA'
       AND NEW.status = 'ENCERRADA' THEN

        UPDATE leito
           SET status = 'LIVRE'
         WHERE id_leito = OLD.id_leito;
    END IF;
END$$

DELIMITER ;
SET FOREIGN_KEY_CHECKS = 1;

