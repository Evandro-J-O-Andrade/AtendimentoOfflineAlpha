CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_fix_columns_entidade`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_table VARCHAR(255);

    DECLARE cur CURSOR FOR
        SELECT TABLE_NAME
        FROM information_schema.COLUMNS
        WHERE COLUMN_NAME = 'id_entidade'
          AND TABLE_SCHEMA = DATABASE();

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_table;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @sql = CONCAT(
            'ALTER TABLE `', v_table,
            '` MODIFY `id_entidade` BIGINT UNSIGNED NOT NULL;'
        );

        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

    END LOOP;

    CLOSE cur;
END ;;