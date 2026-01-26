CREATE TABLE if not exists `acompanhante` (
  `id_acompanhante` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `id_ffa` bigint NOT NULL,
  `tipo` enum('PAI','MAE','RESPONSAVEL_LEGAL','ACOMPANHANTE','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_acompanhante`),
  UNIQUE KEY `uk_acompanhante_por_ffa` (`id_pessoa`,`id_ffa`),
  KEY `id_ffa` (`id_ffa`),
  CONSTRAINT `acompanhante_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
  CONSTRAINT `acompanhante_ibfk_2` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE if not exists  `administracao_medicacao` (
  `id_admin` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao` bigint NOT NULL,
  `id_enfermeiro` bigint NOT NULL,
  `dose` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_admin`),
  KEY `id_prescricao` (`id_prescricao`),
  KEY `id_enfermeiro` (`id_enfermeiro`),
  CONSTRAINT `administracao_medicacao_ibfk_1` FOREIGN KEY (`id_prescricao`) REFERENCES `prescricao_internacao` (`id_prescricao`),
  CONSTRAINT `administracao_medicacao_ibfk_2` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE if not exists `agendamentos` (
  `id_agendamento` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL COMMENT 'Pessoa agendada',
  `id_especialidade` int NOT NULL COMMENT 'Especialidade',
  `data_agendada` datetime NOT NULL COMMENT 'Data agendada',
  `status` enum('AGENDADO','REALIZADO','CANCELADO') COLLATE utf8mb4_general_ci DEFAULT 'AGENDADO' COMMENT 'Status do agendamento',
  `id_usuario` bigint DEFAULT NULL COMMENT 'Usuário que agendou',
  `observacao` text COLLATE utf8mb4_general_ci COMMENT 'Observações do agendamento',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  PRIMARY KEY (`id_agendamento`),
  KEY `id_pessoa` (`id_pessoa`),
  KEY `id_especialidade` (`id_especialidade`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_data_agendada` (`data_agendada`),
  CONSTRAINT `agendamentos_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`) ON DELETE CASCADE,
  CONSTRAINT `agendamentos_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`) ON DELETE RESTRICT,
  CONSTRAINT `agendamentos_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Tabela de agendamentos de consultas';

CREATE TABLE `agendamentos_eventos` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_agendamento` bigint NOT NULL COMMENT 'Agendamento associado',
  `tipo_evento` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Tipo de evento',
  `descricao` text COLLATE utf8mb4_general_ci COMMENT 'Descrição do evento',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Data do evento',
  `id_usuario` bigint DEFAULT NULL COMMENT 'Usuário responsável',
  PRIMARY KEY (`id_evento`),
  KEY `id_agendamento` (`id_agendamento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `agendamentos_eventos_ibfk_1` FOREIGN KEY (`id_agendamento`) REFERENCES `agendamentos` (`id_agendamento`) ON DELETE CASCADE,
  CONSTRAINT `agendamentos_eventos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Eventos relacionados a agendamentos';

CREATE TABLE `almox_entrada` (
  `id_entrada` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque` bigint NOT NULL,
  `quantidade` int NOT NULL,
  `origem` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Compra, doação, transferência',
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_entrada`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `almox_entrada_ibfk_1` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_almoxarifado` (`id_estoque`),
  CONSTRAINT `almox_entrada_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Entradas no almoxarifado';


CREATE TABLE `almox_saida` (
  `id_saida` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque` bigint NOT NULL,
  `quantidade` int NOT NULL,
  `destino` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Setor, sala, manutenção',
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_saida`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `almox_saida_ibfk_1` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_almoxarifado` (`id_estoque`),
  CONSTRAINT `almox_saida_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Saídas do almoxarifado';

CREATE TABLE `anamnese` (
  `id_anamnese` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_anamnese`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `anamnese_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `anamnese_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `anotacao_enfermagem` (
  `id_anotacao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_anotacao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `anotacao_enfermagem_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `anotacao_enfermagem_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `atendimento` (
  `id_atendimento` bigint NOT NULL AUTO_INCREMENT,
  `protocolo` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_pessoa` bigint NOT NULL,
  `id_senha` bigint DEFAULT NULL,
  `status_atendimento` enum('ABERTO','EM_ATENDIMENTO','EM_OBSERVACAO','INTERNADO','FINALIZADO','NAO_ATENDIDO','RETORNO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_local_atual` bigint DEFAULT NULL,
  `id_sala_atual` int DEFAULT NULL,
  `id_especialidade` int DEFAULT NULL,
  `data_abertura` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_fechamento` datetime DEFAULT NULL,
  PRIMARY KEY (`id_atendimento`),
  UNIQUE KEY `protocolo` (`protocolo`),
  KEY `id_pessoa` (`id_pessoa`),
  KEY `id_senha` (`id_senha`),
  KEY `id_local_atual` (`id_local_atual`),
  KEY `id_sala_atual` (`id_sala_atual`),
  KEY `id_especialidade` (`id_especialidade`),
  KEY `idx_status_local` (`status_atendimento`,`id_local_atual`),
  CONSTRAINT `atendimento_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
  CONSTRAINT `atendimento_ibfk_2` FOREIGN KEY (`id_senha`) REFERENCES `senha` (`id_senha`),
  CONSTRAINT `atendimento_ibfk_3` FOREIGN KEY (`id_local_atual`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `atendimento_ibfk_4` FOREIGN KEY (`id_sala_atual`) REFERENCES `sala` (`id_sala`),
  CONSTRAINT `atendimento_ibfk_5` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `atendimento_movimentacao` (
  `id_mov` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `de_local` int DEFAULT NULL,
  `para_local` int DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mov`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `atendimento_movimentacao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `atendimento_movimentacao_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `atendimento_observacao` (
  `id_obs` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo` enum('OBSERVACAO','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_leito` int DEFAULT NULL,
  `data_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `data_fim` datetime DEFAULT NULL,
  `status` enum('ATIVO','ALTA','TRANSFERIDO') COLLATE utf8mb4_general_ci DEFAULT 'ATIVO',
  PRIMARY KEY (`id_obs`),
  UNIQUE KEY `uk_atendimento_obs` (`id_atendimento`),
  KEY `id_leito` (`id_leito`),
  CONSTRAINT `atendimento_observacao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `atendimento_observacao_ibfk_2` FOREIGN KEY (`id_leito`) REFERENCES `leito` (`id_leito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `atendimento_recepcao` (
  `id_atendimento` bigint NOT NULL,
  `tipo_atendimento` enum('CLINICO','PEDIATRICO','EMERGENCIA','EXAME_EXTERNO','MEDICACAO_EXTERNA') COLLATE utf8mb4_general_ci NOT NULL,
  `chegada` enum('MEIOS_PROPRIOS','AMBULANCIA','POLICIA','OUTROS') COLLATE utf8mb4_general_ci NOT NULL,
  `prioridade` enum('AUTISTA','CRIANCA_COLO','GESTANTE','IDOSO','NORMAL') COLLATE utf8mb4_general_ci DEFAULT 'NORMAL',
  `motivo_procura` text COLLATE utf8mb4_general_ci,
  `destino_inicial` enum('TRIAGEM','MEDICO','EMERGENCIA','RX','MEDICACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_recepcionista` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_atendimento`),
  KEY `id_recepcionista` (`id_recepcionista`),
  CONSTRAINT `atendimento_recepcao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `atendimento_recepcao_ibfk_2` FOREIGN KEY (`id_recepcionista`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `auditoria_almoxarifado` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `acao` enum('ENTRADA','SAIDA','AJUSTE') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `quantidade` int NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`),
  KEY `id_produto` (`id_produto`),
  KEY `id_local` (`id_local`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `auditoria_almoxarifado_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos_almoxarifado` (`id_produto`),
  CONSTRAINT `auditoria_almoxarifado_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`),
  CONSTRAINT `auditoria_almoxarifado_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Auditoria do almoxarifado';

CREATE TABLE `auditoria_estoque` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `id_local` int NOT NULL,
  `acao` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` int NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `auditoria_estoque_sanitario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `id_local` int NOT NULL,
  `quantidade` int NOT NULL,
  `nivel_risco` enum('OK','CRITICO','VENCIDO') COLLATE utf8mb4_general_ci NOT NULL,
  `criado_por` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `auditoria_excecoes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_paciente` bigint NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `chamado_por` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `auditoria_ffa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_usuario` bigint NOT NULL,
  `tipo_evento` enum('CRIACAO','STATUS','LAYOUT','CHAMADA_MEDICA','SOLICITACAO_RX','SOLICITACAO_MEDICACAO','ALTA_MEDICA','TRANSFERENCIA','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `acao` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_auditoria_ffa_ffa` (`id_ffa`),
  CONSTRAINT `fk_auditoria_ffa_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `auditoria_fila` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_fila` bigint NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `acao` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_fila` (`id_fila`),
  CONSTRAINT `auditoria_fila_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `chamada_painel` (
  `id_chamada` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_sala` int NOT NULL,
  `status` enum('CHAMANDO','ATENDIDO','NAO_COMPARECEU') COLLATE utf8mb4_general_ci DEFAULT 'CHAMANDO',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_chamada`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_sala` (`id_sala`),
  KEY `idx_painel_status` (`status`,`data_hora`),
  CONSTRAINT `chamada_painel_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `chamada_painel_ibfk_2` FOREIGN KEY (`id_sala`) REFERENCES `sala` (`id_sala`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `chamado_manutencao` (
  `id_chamado` bigint NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL,
  `origem` enum('PA','INTERNACAO','AMBULATORIO','ADMINISTRATIVO') COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_problema` enum('ELETRICO','HIDRAULICO','AR_CONDICIONADO','EQUIPAMENTO','ESTRUTURAL','TI','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `prioridade` enum('BAIXA','MEDIA','ALTA','CRITICA') COLLATE utf8mb4_general_ci DEFAULT 'MEDIA',
  `status` enum('ABERTO','EM_ATENDIMENTO','AGUARDANDO_PECA','RESOLVIDO','CANCELADO') COLLATE utf8mb4_general_ci DEFAULT 'ABERTO',
  `aberto_por` bigint NOT NULL,
  `aberto_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `fechado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_chamado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Chamados de manutenção predial, equipamentos e TI';

CREATE TABLE `cidade` (
  `id_cidade` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `uf` char(2) COLLATE utf8mb4_general_ci NOT NULL,
  `codigo_ibge` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_cidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `classificacao_risco` (
  `id_risco` int NOT NULL AUTO_INCREMENT,
  `cor` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tempo_max` int DEFAULT NULL,
  `descricao` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_risco`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `configuracao` (
  `chave` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `valor` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`chave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `consumo_insumo` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `origem` enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_produto` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `usado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_consumo`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_origem` (`origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Consumo real de insumos no paciente';

CREATE TABLE `consumo_limpeza` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL COMMENT 'Setor onde ocorreu o consumo',
  `id_produto` bigint NOT NULL COMMENT 'Produto de limpeza',
  `quantidade` decimal(10,2) NOT NULL,
  `unidade` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'UN',
  `consumido_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL COMMENT 'Usuário da limpeza',
  `motivo` enum('ROTINA','REPOSICAO','CONTAMINACAO','INTERCORRENCIA','OUTRO') COLLATE utf8mb4_general_ci DEFAULT 'ROTINA',
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_consumo`),
  KEY `idx_setor` (`id_setor`),
  KEY `idx_produto` (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Consumo operacional de produtos de limpeza e higiene';

CREATE TABLE `consumo_manutencao` (
  `id_consumo` bigint NOT NULL AUTO_INCREMENT,
  `id_chamado` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `quantidade` decimal(10,2) NOT NULL,
  `unidade` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `consumido_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` bigint NOT NULL,
  PRIMARY KEY (`id_consumo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Consumo de materiais em manutenção';

CREATE TABLE `contexto_atendimento` (
  `id_contexto` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint NOT NULL,
  `nome` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('PORTA','EMERGENCIA','LEITO','EXECUCAO') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `usa_fila` tinyint(1) DEFAULT NULL,
  `usa_chamada` tinyint(1) DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_contexto`),
  KEY `id_sistema` (`id_sistema`),
  CONSTRAINT `contexto_atendimento_ibfk_1` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `dispensacao_farmacia` (
  `id_dispensacao` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao` bigint NOT NULL,
  `id_prescricao_item` bigint NOT NULL,
  `id_farmaco` bigint NOT NULL,
  `id_estoque` bigint NOT NULL,
  `quantidade_dispensada` decimal(10,2) NOT NULL,
  `id_usuario_farmaceutico` bigint NOT NULL,
  `data_hora_dispensacao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_dispensacao`),
  KEY `id_prescricao` (`id_prescricao`),
  KEY `id_prescricao_item` (`id_prescricao_item`),
  KEY `id_farmaco` (`id_farmaco`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_usuario_farmaceutico` (`id_usuario_farmaceutico`),
  CONSTRAINT `dispensacao_farmacia_ibfk_1` FOREIGN KEY (`id_prescricao`) REFERENCES `prescricao` (`id_prescricao`),
  CONSTRAINT `dispensacao_farmacia_ibfk_2` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_item` (`id_item`),
  CONSTRAINT `dispensacao_farmacia_ibfk_3` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `dispensacao_farmacia_ibfk_4` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_local` (`id_estoque`),
  CONSTRAINT `dispensacao_farmacia_ibfk_5` FOREIGN KEY (`id_usuario_farmaceutico`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `enfermagem` (
  `id_usuario` bigint NOT NULL,
  `coren` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `uf_coren` char(2) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('ENFERMEIRO','TECNICO') COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_coren` (`coren`,`uf_coren`),
  CONSTRAINT `enfermagem_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `entrada_estoque` (
  `id_entrada` bigint NOT NULL AUTO_INCREMENT,
  `id_estoque` bigint NOT NULL,
  `id_produto` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `quantidade` int NOT NULL,
  `lote` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `validade` date DEFAULT NULL,
  `id_usuario_entrada` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_fornecedor` bigint DEFAULT NULL,
  `numero_nota` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor_total` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id_entrada`),
  KEY `id_estoque` (`id_estoque`),
  KEY `id_produto` (`id_produto`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `entrada_estoque_ibfk_1` FOREIGN KEY (`id_estoque`) REFERENCES `estoque_local` (`id_estoque`),
  CONSTRAINT `entrada_estoque_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos_farmacia` (`id_produto`),
  CONSTRAINT `entrada_estoque_ibfk_3` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `especialidade` (
  `id_especialidade` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `ativa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_especialidade`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `estoque_almoxarifado` (
  `id_estoque` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `quantidade_atual` int DEFAULT '0',
  `min_estoque` int DEFAULT '0',
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `uk_produto_local` (`id_produto`,`id_local`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `estoque_almoxarifado_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos_almoxarifado` (`id_produto`),
  CONSTRAINT `estoque_almoxarifado_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Estoque do almoxarifado por local';

CREATE TABLE `estoque_limpeza` (
  `id_estoque` bigint NOT NULL AUTO_INCREMENT,
  `id_produto` bigint NOT NULL COMMENT 'Produto de limpeza',
  `id_local` bigint DEFAULT NULL,
  `quantidade_atual` int DEFAULT '0' COMMENT 'Quantidade atual',
  `min_estoque` int DEFAULT '0' COMMENT 'Mínimo para alerta',
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `uk_produto_local_limpeza` (`id_produto`,`id_local`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `estoque_limpeza_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos_limpeza` (`id_produto`) ON DELETE CASCADE,
  CONSTRAINT `estoque_limpeza_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Estoque para itens de limpeza';

CREATE TABLE `estoque_local` (
  `id_estoque` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_local` bigint DEFAULT NULL,
  `quantidade_atual` int NOT NULL DEFAULT '0',
  `min_estoque` int DEFAULT '0',
  PRIMARY KEY (`id_estoque`),
  UNIQUE KEY `uk_farmaco_local` (`id_farmaco`,`id_local`),
  KEY `id_local` (`id_local`),
  CONSTRAINT `estoque_local_ibfk_1` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `estoque_local_ibfk_2` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `evento_ffa` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_paciente` bigint DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `origem` enum('PAINEL_TOTEM','PAINEL_RECEPCAO','PAINEL_TRIAGEM','PAINEL_MEDICO','PAINEL_PROCEDIMENTO','PAINEL_SATISFACAO','SISTEMA') COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_evento` enum('GERAR_SENHA','IMPRIMIR_SENHA','CHAMAR_SENHA','CONFIRMAR_PRESENCA','CRIAR_FFA','INICIO_TRIAGEM','FINAL_TRIAGEM','CHAMADA_MEDICA','INICIO_ATENDIMENTO_MEDICO','FINAL_ATENDIMENTO_MEDICO','CHAMADA_PROCEDIMENTO','INICIO_PROCEDIMENTO','FINAL_PROCEDIMENTO','STATUS_AUTOMATICO','NAO_COMPARECEU','TIMEOUT','AVALIACAO_ATENDIMENTO') COLLATE utf8mb4_general_ci NOT NULL,
  `status_origem` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status_destino` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','AGUARDANDO_MEDICACAO','MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `payload` json DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_evento_ffa` (`id_ffa`),
  KEY `idx_evento_tipo` (`tipo_evento`),
  KEY `idx_evento_origem` (`origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `evento_limpeza` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL,
  `tipo_evento` enum('LIMPEZA_ROTINA','LIMPEZA_TERMINAL','REPOSICAO_HIGIENE','INTERCORRENCIA','CONTAMINACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `registrado_por` bigint NOT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Eventos operacionais da equipe de limpeza';

CREATE TABLE `eventos_fluxo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entidade` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `entidade_id` bigint DEFAULT NULL,
  `tipo_evento` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `perfil_usuario` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `local` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `evolucao_enfermagem` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_enfermeiro` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evolucao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_enfermeiro` (`id_enfermeiro`),
  CONSTRAINT `evolucao_enfermagem_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `evolucao_enfermagem_ibfk_2` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `evolucao_medica` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evolucao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `evolucao_medica_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `evolucao_medica_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `evolucao_multidisciplinar` (
  `id_evolucao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `area` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evolucao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `evolucao_multidisciplinar_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `evolucao_multidisciplinar_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `exame` (
  `id_exame` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('LAB','RX','OUTROS') COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_exame`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `exame_fisico` (
  `id_exame` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_exame`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `exame_fisico_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `exame_fisico_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `farmaco` (
  `id_farmaco` bigint NOT NULL AUTO_INCREMENT,
  `nome_comercial` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `principio_ativo` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('CONTROLADO','PADRAO','HEMODERIVADO') COLLATE utf8mb4_general_ci NOT NULL,
  `unidade_medida` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `marca` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `generico` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_farmaco`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `farmaco_auditoria` (
  `id_auditoria` bigint NOT NULL AUTO_INCREMENT,
  `tabela` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `acao` enum('INSERT','UPDATE','DELETE') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dados_antes` json DEFAULT NULL,
  `dados_depois` json DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `data_evento` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `farmaco_auditoria_bloqueio` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `quantidade` int NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `usuario` bigint NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_bloq_farmaco` (`id_farmaco`),
  KEY `idx_bloq_lote` (`id_lote`),
  KEY `idx_bloq_cidade` (`id_cidade`),
  KEY `idx_bloq_usuario` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `farmaco_estoque_minimo` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `quantidade_minima` int NOT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT '1',
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_farmaco_cidade` (`id_farmaco`,`id_cidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `farmaco_lote` (
  `id_lote` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `numero_lote` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `data_fabricacao` date NOT NULL,
  `data_validade` date NOT NULL,
  `criado_por` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_lote`),
  KEY `fk_lote_farmaco` (`id_farmaco`),
  CONSTRAINT `fk_lote_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `farmaco_movimentacao` (
  `id_movimentacao` bigint NOT NULL AUTO_INCREMENT,
  `id_farmaco` bigint NOT NULL,
  `id_lote` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `tipo` enum('ENTRADA','SAIDA') COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` int NOT NULL,
  `origem` enum('COMPRA','TRANSFERENCIA','PACIENTE','AJUSTE') COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `realizado_por` bigint NOT NULL,
  `data_mov` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_movimentacao`),
  KEY `fk_mov_farmaco` (`id_farmaco`),
  KEY `fk_mov_lote` (`id_lote`),
  CONSTRAINT `fk_mov_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`),
  CONSTRAINT `fk_mov_lote` FOREIGN KEY (`id_lote`) REFERENCES `farmaco_lote` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `farmaco_unidade` (
  `id_farmaco` bigint NOT NULL,
  `id_cidade` bigint NOT NULL,
  `cota_minima` int NOT NULL DEFAULT '0',
  `cota_maxima` int DEFAULT NULL,
  `atualizado_por` bigint NOT NULL,
  `atualizado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_farmaco`,`id_cidade`),
  CONSTRAINT `fk_fu_farmaco` FOREIGN KEY (`id_farmaco`) REFERENCES `farmaco` (`id_farmaco`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `faturamento_conta` (
  `id_conta` bigint NOT NULL AUTO_INCREMENT,
  `tipo_conta` enum('FFA','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `status` enum('ABERTA','EM_REVISAO','FECHADA') COLLATE utf8mb4_general_ci DEFAULT 'ABERTA',
  `valor_total` decimal(12,2) DEFAULT '0.00',
  `aberta_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `fechada_em` datetime DEFAULT NULL,
  `fechado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id_conta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Conta financeira consolidada por atendimento';

CREATE TABLE `faturamento_conta_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_conta` bigint NOT NULL,
  `id_item` bigint NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Relaciona itens faturáveis à conta';

CREATE TABLE `faturamento_evento` (
  `id_evento` bigint NOT NULL AUTO_INCREMENT,
  `id_conta` bigint NOT NULL,
  `evento` enum('ABERTURA','FECHAMENTO','REABERTURA','CANCELAMENTO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_evento`),
  KEY `idx_conta` (`id_conta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Auditoria humana do faturamento';

CREATE TABLE `faturamento_insumo` (
  `id_fat_insumo` bigint NOT NULL AUTO_INCREMENT,
  `id_item` bigint NOT NULL,
  `origem` enum('FARMACIA','ALMOXARIFADO','MANUTENCAO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_produto` bigint NOT NULL,
  `lote` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `validade` date DEFAULT NULL,
  PRIMARY KEY (`id_fat_insumo`),
  KEY `idx_item` (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Detalhe do insumo faturado';

CREATE TABLE `faturamento_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `origem` enum('PROCEDIMENTO','EXAME','MEDICACAO','MATERIAL','TAXA','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_origem` bigint NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `quantidade` decimal(10,2) DEFAULT '1.00',
  `valor_unitario` decimal(10,2) NOT NULL,
  `valor_total` decimal(10,2) NOT NULL,
  `id_ffa` bigint DEFAULT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `status` enum('ABERTO','CONSOLIDADO','CANCELADO') COLLATE utf8mb4_general_ci DEFAULT 'ABERTO',
  PRIMARY KEY (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Itens faturáveis gerados a partir de eventos assistenciais';

CREATE TABLE `ffa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_paciente` bigint NOT NULL,
  `gpat` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('ABERTO','EM_TRIAGEM','AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','EM_ATENDIMENTO_MEDICO','OBSERVACAO','MEDICACAO','AGUARDANDO_MEDICACAO','AGUARDANDO_RX','EM_RX','AGUARDANDO_COLETA','EM_COLETA','AGUARDANDO_ECG','EM_ECG','ALTA','TRANSFERENCIA','INTERNACAO','FINALIZADO','AGUARDANDO_RETORNO','EMERGENCIA') COLLATE utf8mb4_general_ci NOT NULL,
  `layout` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_criacao` bigint NOT NULL,
  `id_usuario_alteracao` bigint DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT NULL,
  `classificacao_manchester` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `linha_assistencial` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_senha` bigint DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `ffa_prioridade` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `codigo_prioridade` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `ffa_procedimento` (
  `id_procedimento` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `tipo` enum('RX','ECG','LABORATORIO','MEDICACAO','OBSERVACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('SOLICITADO','EM_FILA','EM_EXECUCAO','CONCLUIDO','CRITICO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'SOLICITADO',
  `prioridade` enum('NORMAL','EMERGENCIA') COLLATE utf8mb4_general_ci DEFAULT 'NORMAL',
  `id_usuario_solicitante` bigint DEFAULT NULL,
  `id_usuario_execucao` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `iniciado_em` datetime DEFAULT NULL,
  `finalizado_em` datetime DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_procedimento`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Procedimentos paralelos do PA';

CREATE TABLE `ffa_substatus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `categoria` enum('MEDICACAO','FARMACIA','OBSERVACAO','RX','ECG','COLETA','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `finalizado_em` datetime DEFAULT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_ffa_categoria` (`id_ffa`,`categoria`,`ativo`),
  CONSTRAINT `ffa_substatus_ibfk_1` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ffa_substatus_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Substatus assistenciais da FFA';

CREATE TABLE `fila_evento` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_fila` bigint NOT NULL,
  `evento` enum('GERADA','CHAMADA','NAO_ATENDIDO','REENTRADA','ABERTURA_FFA','ENCAMINHAMENTO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint DEFAULT NULL,
  `id_local` bigint DEFAULT NULL,
  `detalhe` text COLLATE utf8mb4_general_ci,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_fila` (`id_fila`),
  CONSTRAINT `fila_evento_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fila_operacional` (
  `id_fila` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL COMMENT 'Episódio assistencial',
  `tipo` enum('TRIAGEM','MEDICO','MEDICACAO','EXAME','RX','ECG','PROCEDIMENTO','OBSERVACAO') COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Tipo de fila',
  `substatus` enum('AGUARDANDO','EM_EXECUCAO','EM_OBSERVACAO','FINALIZADO','CRITICO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'AGUARDANDO' COMMENT 'Substatus do paciente nesta fila',
  `prioridade` enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') COLLATE utf8mb4_general_ci DEFAULT 'AZUL' COMMENT 'Prioridade de Manchester',
  `data_entrada` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Chegada na fila',
  `data_inicio` datetime DEFAULT NULL COMMENT 'Início do atendimento/exame',
  `data_fim` datetime DEFAULT NULL COMMENT 'Término do atendimento/exame',
  `id_responsavel` bigint DEFAULT NULL COMMENT 'Usuário que está atendendo/executando',
  `observacao` text COLLATE utf8mb4_general_ci COMMENT 'Notas ou observações específicas',
  `id_local` bigint DEFAULT NULL,
  PRIMARY KEY (`id_fila`),
  KEY `id_responsavel` (`id_responsavel`),
  KEY `id_local` (`id_local`),
  KEY `idx_ffa_tipo_substatus` (`id_ffa`,`tipo`,`substatus`),
  KEY `idx_tipo_prioridade` (`tipo`,`prioridade`,`substatus`),
  CONSTRAINT `fila_operacional_ibfk_1` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`),
  CONSTRAINT `fila_operacional_ibfk_2` FOREIGN KEY (`id_responsavel`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `fila_operacional_ibfk_3` FOREIGN KEY (`id_local`) REFERENCES `local_atendimento` (`id_local`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Fila operacional de todos os atendimentos, procedimentos, exames, medicação e observação';

CREATE TABLE `fila_retorno` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_fila` bigint NOT NULL,
  `retorno_em` datetime NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_fila` (`id_fila`),
  CONSTRAINT `fila_retorno_ibfk_1` FOREIGN KEY (`id_fila`) REFERENCES `fila_senha` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fila_senha` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `senha` bigint NOT NULL,
  `id_paciente` bigint NOT NULL,
  `prioridade_recepcao` enum('PADRAO','IDOSO','CRONICO') COLLATE utf8mb4_general_ci DEFAULT 'PADRAO',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `senha` (`senha`),
  CONSTRAINT `fila_senha_ibfk_1` FOREIGN KEY (`senha`) REFERENCES `senhas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fluxo_status` (
  `status_origem` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `status_destino` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `origem_evento` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `permitido` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`status_origem`,`status_destino`,`origem_evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `fornecedor` (
  `id_fornecedor` bigint NOT NULL AUTO_INCREMENT,
  `razao_social` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_fantasia` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cnpj` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `contato` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_fornecedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `hipotese_diagnostica` (
  `id_hipotese` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `cid10` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `principal` tinyint(1) DEFAULT '0',
  `id_medico` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_hipotese`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `hipotese_diagnostica_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `hipotese_diagnostica_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `interconsulta` (
  `id_interconsulta` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `id_especialidade` int NOT NULL,
  `motivo` text COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('SOLICITADA','RESPONDIDA') COLLATE utf8mb4_general_ci DEFAULT 'SOLICITADA',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_interconsulta`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `interconsulta_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `interconsulta_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `intercorrencia` (
  `id_intercorrencia` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_internacao` bigint DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `gravidade` enum('LEVE','MODERADA','GRAVE') COLLATE utf8mb4_general_ci DEFAULT 'LEVE',
  `id_usuario` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_intercorrencia`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_intercorrencia_atendimento` (`id_atendimento`),
  KEY `idx_intercorrencia_internacao` (`id_internacao`),
  CONSTRAINT `intercorrencia_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `intercorrencia_ibfk_2` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `intercorrencia_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `internacao` (
  `id_internacao` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_leito` int DEFAULT NULL,
  `tipo` enum('OBSERVACAO','INTERNACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `motivo` text COLLATE utf8mb4_general_ci,
  `status` enum('ATIVA','ENCERRADA','TRANSFERIDA','OBITO') COLLATE utf8mb4_general_ci DEFAULT 'ATIVA',
  `data_entrada` datetime NOT NULL,
  `id_usuario_entrada` bigint DEFAULT NULL,
  `data_saida` datetime DEFAULT NULL,
  `id_usuario_saida` bigint DEFAULT NULL,
  `motivo_alta` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `encerrado_em` datetime DEFAULT NULL,
  PRIMARY KEY (`id_internacao`),
  KEY `idx_ffa` (`id_ffa`),
  KEY `idx_status` (`status`),
  KEY `idx_leito` (`id_leito`),
  CONSTRAINT `fk_internacao_ffa` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Internação e observação clínica';

CREATE TABLE `internacao_historico` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `evento` enum('ENTRADA','TROCA_LEITO','ALTA','TRANSFERENCIA','OBITO') COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci,
  `id_usuario` bigint DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_internacao` (`id_internacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Histórico imutável da internação';

CREATE TABLE `leito` (
  `id_leito` int NOT NULL AUTO_INCREMENT,
  `id_setor` int NOT NULL,
  `identificacao` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('LIVRE','OCUPADO','BLOQUEADO') COLLATE utf8mb4_general_ci DEFAULT 'LIVRE',
  PRIMARY KEY (`id_leito`),
  UNIQUE KEY `uk_setor_leito` (`id_setor`,`identificacao`),
  CONSTRAINT `leito_ibfk_1` FOREIGN KEY (`id_setor`) REFERENCES `setor` (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `local_atendimento` (
  `id_local` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('RECEPCAO','TRIAGEM','CONSULTORIO','EMERGENCIA','OBSERVACAO','INTERNACAO','MEDICACAO','RX','LABORATORIO','ECG','NOTIFICACAO','FARMACIA','COPA','COLETA','OUTROS') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_unidade` bigint NOT NULL,
  PRIMARY KEY (`id_local`),
  KEY `fk_local_sistema` (`id_unidade`),
  CONSTRAINT `fk_local_sistema` FOREIGN KEY (`id_unidade`) REFERENCES `sistema` (`id_sistema`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `local_usuario` (
  `id_local_usuario` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('RECEPCAO','MEDICO','TRIAGEM','SUPORTE','ADMIN','GESTAO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'RECEPCAO',
  `ativo` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_local_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `log_auditoria` (
  `id_log` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint DEFAULT NULL,
  `acao` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tabela_afetada` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_registro` bigint DEFAULT NULL,
  `antes` text COLLATE utf8mb4_general_ci,
  `depois` text COLLATE utf8mb4_general_ci,
  `justificativa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `logradouro` (
  `id_logradouro` bigint NOT NULL AUTO_INCREMENT,
  `cep` varchar(9) COLLATE utf8mb4_general_ci NOT NULL,
  `logradouro` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `numero` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `complemento` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bairro` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cidade` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uf` char(2) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_logradouro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `manutencao_execucao` (
  `id_execucao` bigint NOT NULL AUTO_INCREMENT,
  `id_chamado` bigint NOT NULL,
  `tecnico` bigint NOT NULL,
  `descricao_servico` text COLLATE utf8mb4_general_ci,
  `inicio_em` datetime DEFAULT NULL,
  `fim_em` datetime DEFAULT NULL,
  `status` enum('INICIADO','PAUSADO','FINALIZADO') COLLATE utf8mb4_general_ci DEFAULT 'INICIADO',
  PRIMARY KEY (`id_execucao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Execução técnica do chamado de manutenção';

CREATE TABLE `medico` (
  `id_usuario` bigint NOT NULL,
  `crm` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `uf_crm` char(2) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uk_crm` (`crm`,`uf_crm`),
  CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `medico_especialidade` (
  `id_usuario` bigint NOT NULL,
  `id_especialidade` int NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_especialidade`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `medico_especialidade_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `medico` (`id_usuario`),
  CONSTRAINT `medico_especialidade_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `medicos` (
  `id_medico` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `crm` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_especialidade` int DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_medico`),
  UNIQUE KEY `crm` (`crm`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `medicos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `medicos_ibfk_2` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `observacoes_eventos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `entidade` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'FILA_SENHA, FFA, PRESCRICAO, AGENDAMENTO',
  `id_entidade` bigint NOT NULL,
  `contexto` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'MEDICO, ENFERMAGEM, TECNICA, ADMIN',
  `tipo` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'OBSERVACAO, ALERTA, EVASAO, ORIENTACAO',
  `texto` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_usuario` (`id_usuario`),
  KEY `idx_entidade` (`entidade`,`id_entidade`),
  CONSTRAINT `observacoes_eventos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Observações e comunicações como eventos';

CREATE TABLE `ordem_assistencial` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `tipo_ordem` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('ATIVA','SUSPENSA','ENCERRADA') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ATIVA',
  `origem` enum('MEDICO','ENFERMAGEM') COLLATE utf8mb4_general_ci NOT NULL,
  `payload_clinico` json NOT NULL,
  `prioridade` int DEFAULT '0',
  `iniciado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `suspenso_em` datetime DEFAULT NULL,
  `encerrado_em` datetime DEFAULT NULL,
  `motivo_suspensao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `motivo_encerramento` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `criado_por` bigint NOT NULL,
  `atualizado_em` datetime DEFAULT NULL,
  `atualizado_por` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_ordem_ffa` (`id_ffa`),
  KEY `idx_ordem_status` (`status`),
  KEY `idx_ordem_tipo` (`tipo_ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `paciente` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `prontuario` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_cadastro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `prontuario` (`prontuario`),
  KEY `id_pessoa` (`id_pessoa`),
  CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `perfil` (
  `id_perfil` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_perfil`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `perfil_permissao` (
  `id_perfil` int NOT NULL,
  `id_permissao` int NOT NULL,
  `permissao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_perfil`,`id_permissao`),
  KEY `id_permissao` (`id_permissao`),
  CONSTRAINT `perfil_permissao_ibfk_1` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`),
  CONSTRAINT `perfil_permissao_ibfk_2` FOREIGN KEY (`id_permissao`) REFERENCES `permissao` (`id_permissao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `permissao` (
  `id_permissao` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_permissao`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `permissao_procedure` (
  `id_perfil` int NOT NULL,
  `procedure_nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_perfil`,`procedure_nome`),
  CONSTRAINT `permissao_procedure_ibfk_1` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pessoa` (
  `id_pessoa` bigint NOT NULL AUTO_INCREMENT,
  `nome_completo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `nome_social` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pessoa_contato` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `tipo` enum('EMAIL','TELEFONE','WHATSAPP') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `valor` varchar(150) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `principal` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_pessoa` (`id_pessoa`),
  CONSTRAINT `pessoa_contato_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pessoa_logradouro` (
  `id_pessoa` bigint NOT NULL,
  `id_logradouro` bigint NOT NULL,
  `principal` tinyint(1) DEFAULT '1',
  `data_inicio` date NOT NULL,
  `data_fim` date DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_pessoa`,`id_logradouro`,`data_inicio`),
  KEY `id_logradouro` (`id_logradouro`),
  KEY `idx_pessoa_logradouro_ativo` (`id_pessoa`,`ativo`),
  KEY `idx_pessoa_logradouro_principal` (`id_pessoa`,`principal`),
  CONSTRAINT `pessoa_logradouro_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`),
  CONSTRAINT `pessoa_logradouro_ibfk_2` FOREIGN KEY (`id_logradouro`) REFERENCES `logradouro` (`id_logradouro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `plantao` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_medico` bigint NOT NULL,
  `nome_medico` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_plantao` enum('CLINICO','PEDIATRIA','EMERGENCIA') COLLATE utf8mb4_general_ci NOT NULL,
  `inicio_plantao` datetime NOT NULL,
  `fim_plantao` datetime NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `plantoes` (
  `id_plantao` bigint NOT NULL AUTO_INCREMENT,
  `id_medico` bigint NOT NULL,
  `data` date NOT NULL,
  `turno` enum('DIA','NOITE','24H','CUSTOM') COLLATE utf8mb4_general_ci NOT NULL,
  `hora_inicio` time DEFAULT NULL,
  `hora_fim` time DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_plantao`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `plantoes_ibfk_1` FOREIGN KEY (`id_medico`) REFERENCES `medicos` (`id_medico`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `prescricao` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `tipo` enum('INTERNA','CONTROLADA','CASA') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint DEFAULT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `bloqueada` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_prescricao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `prescricao_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `prescricao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `prescricao_continua` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `tipo` enum('MEDICAMENTOS','CUIDADOS_GERAIS') COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `ativa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_prescricao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `prescricao_continua_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `prescricao_continua_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `prescricao_internacao` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_internacao` bigint NOT NULL,
  `tipo` enum('MEDICAMENTO','CUIDADO','DIETA','OUTROS') COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint NOT NULL,
  `ativa` tinyint(1) DEFAULT '1',
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_prescricao`),
  KEY `id_internacao` (`id_internacao`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `prescricao_internacao_ibfk_1` FOREIGN KEY (`id_internacao`) REFERENCES `internacao` (`id_internacao`),
  CONSTRAINT `prescricao_internacao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `prescricao_item` (
  `id_item` bigint NOT NULL AUTO_INCREMENT,
  `id_prescricao` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL,
  `dose` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `via` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `posologia` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id_item`),
  KEY `id_prescricao` (`id_prescricao`),
  CONSTRAINT `prescricao_item_ibfk_1` FOREIGN KEY (`id_prescricao`) REFERENCES `prescricao_continua` (`id_prescricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `prescricao_medicacao` (
  `id_prescricao` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `id_medico` bigint NOT NULL,
  `descricao` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Descrição livre da prescrição',
  `controlada` tinyint(1) DEFAULT '0' COMMENT 'Se exige liberação da farmácia',
  `criada_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `ativa` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_prescricao`),
  KEY `id_medico` (`id_medico`),
  KEY `idx_ffa` (`id_ffa`),
  CONSTRAINT `prescricao_medicacao_ibfk_1` FOREIGN KEY (`id_ffa`) REFERENCES `ffa` (`id`) ON DELETE CASCADE,
  CONSTRAINT `prescricao_medicacao_ibfk_2` FOREIGN KEY (`id_medico`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Prescrições de medicação do PA';

CREATE TABLE `prioridade_social` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `peso` int NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `produtos_almoxarifado` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `categoria` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Ex: escritório, manutenção, EPI, TI',
  `unidade_medida` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Produtos do almoxarifado';

CREATE TABLE `produtos_farmacia` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `principio_ativo` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `unidade_medida` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipo` enum('MEDICAMENTO','INSUMO','OUTRO') COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `produtos_limpeza` (
  `id_produto` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(200) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Nome do produto',
  `tipo` enum('LIMPEZA','MANUTENCAO','OUTRO') COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Tipo de produto',
  PRIMARY KEY (`id_produto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Produtos para limpeza e manutenção';

CREATE TABLE `protocolo_sequencia` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `reabertura_atendimento` (
  `id_reabertura` bigint NOT NULL AUTO_INCREMENT,
  `id_ffa` bigint NOT NULL,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `id_usuario` bigint NOT NULL,
  `criado_em` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reabertura`),
  KEY `idx_ffa` (`id_ffa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Reabertura de episódio/atendimento';

CREATE TABLE `regra_timeout` (
  `status` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `minutos` int DEFAULT NULL,
  `evento_timeout` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `retorno_atendimento` (
  `id_retorno` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento_origem` bigint DEFAULT NULL,
  `id_atendimento_retorno` bigint DEFAULT NULL,
  `motivo` text COLLATE utf8mb4_general_ci,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_retorno`),
  KEY `id_atendimento_origem` (`id_atendimento_origem`),
  KEY `id_atendimento_retorno` (`id_atendimento_retorno`),
  CONSTRAINT `retorno_atendimento_ibfk_1` FOREIGN KEY (`id_atendimento_origem`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `retorno_atendimento_ibfk_2` FOREIGN KEY (`id_atendimento_retorno`) REFERENCES `atendimento` (`id_atendimento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `sala` (
  `id_sala` int NOT NULL AUTO_INCREMENT,
  `nome_exibicao` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `id_local` int NOT NULL,
  `id_especialidade` int DEFAULT NULL,
  `ativa` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sala`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Sala física de atendimento (exibição em painel e uso assistencial)';

CREATE TABLE `senhas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `numero` int NOT NULL,
  `prefixo` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo_atendimento` enum('CLINICO','PEDIATRICO','PRIORITARIO','EMERGENCIA','VISITA','EXAME') COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('GERADA','EM_FILA','CHAMADA','EM_ATENDIMENTO_RECEPCAO','ATENDIDA','NAO_COMPARECEU','CANCELADA','EXPIRADA') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'GERADA',
  `origem` enum('TOTEM','RECEPCAO','ADMIN') COLLATE utf8mb4_general_ci NOT NULL,
  `guiche_chamada` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `id_usuario_chamada` bigint DEFAULT NULL,
  `prioridade` tinyint(1) DEFAULT '0',
  `criada_em` datetime NOT NULL,
  `chamada_em` datetime DEFAULT NULL,
  `atendida_em` datetime DEFAULT NULL,
  `cancelada_em` datetime DEFAULT NULL,
  `observacao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_tipo` (`tipo_atendimento`),
  KEY `idx_criada_em` (`criada_em`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `sessao` (
  `id_sessao` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `token` char(64) COLLATE utf8mb4_general_ci NOT NULL,
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  `expira_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_sessao`),
  UNIQUE KEY `token` (`token`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `sessao_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `setor` (
  `id_setor` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('OBSERVACAO','INTERNACAO','UTI') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `sigpat_procedimento` (
  `id_sigpat` bigint NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('EXAME','PROCEDIMENTO','CONSULTA','OUTRO') COLLATE utf8mb4_general_ci NOT NULL,
  `grupo` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subgrupo` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `setor_execucao` enum('RX','LABORATORIO','ECG','MEDICACAO','AMBULATORIO','OUTRO') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'OUTRO',
  `gera_faturamento` tinyint(1) DEFAULT '1',
  `exige_coleta` tinyint(1) DEFAULT '0',
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `atualizado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sigpat`),
  UNIQUE KEY `uk_sigpat_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `sistema` (
  `id_sistema` bigint NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `descricao` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sistema`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `solicitacao_exame` (
  `id_solicitacao` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint DEFAULT NULL,
  `id_exame` int DEFAULT NULL,
  `id_sigpat` bigint DEFAULT NULL,
  `status` enum('SOLICITADO','COLETADO','EM_ANALISE','RESULTADO','CANCELADO') COLLATE utf8mb4_general_ci NOT NULL,
  `id_medico` bigint DEFAULT NULL,
  `solicitado_em` datetime NOT NULL,
  PRIMARY KEY (`id_solicitacao`),
  KEY `id_atendimento` (`id_atendimento`),
  KEY `id_exame` (`id_exame`),
  KEY `id_medico` (`id_medico`),
  CONSTRAINT `solicitacao_exame_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `solicitacao_exame_ibfk_2` FOREIGN KEY (`id_exame`) REFERENCES `exame` (`id_exame`),
  CONSTRAINT `solicitacao_exame_ibfk_3` FOREIGN KEY (`id_medico`) REFERENCES `medico` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `status_timeout` (
  `status` enum('AGUARDANDO_CHAMADA_MEDICO','CHAMANDO_MEDICO','AGUARDANDO_RX','CHAMANDO_RX','AGUARDANDO_MEDICACAO','EM_MEDICACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `tempo_max_segundos` int NOT NULL,
  `status_fallback` enum('AGUARDANDO_CHAMADA_MEDICO','AGUARDANDO_RX','AGUARDANDO_MEDICACAO') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `totem_feedback` (
  `id_feedback` bigint NOT NULL AUTO_INCREMENT,
  `id_senha` bigint DEFAULT NULL,
  `origem` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nota` int DEFAULT NULL,
  `comentario` text COLLATE utf8mb4_general_ci,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_feedback`),
  KEY `id_senha` (`id_senha`),
  CONSTRAINT `totem_feedback_ibfk_1` FOREIGN KEY (`id_senha`) REFERENCES `senha` (`id_senha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `triagem` (
  `id_triagem` bigint NOT NULL AUTO_INCREMENT,
  `id_atendimento` bigint NOT NULL,
  `id_risco` int NOT NULL,
  `queixa` text COLLATE utf8mb4_general_ci,
  `sinais_vitais` json DEFAULT NULL,
  `observacao` text COLLATE utf8mb4_general_ci,
  `id_enfermeiro` bigint NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_triagem`),
  UNIQUE KEY `uk_triagem_atendimento` (`id_atendimento`),
  KEY `id_risco` (`id_risco`),
  KEY `id_enfermeiro` (`id_enfermeiro`),
  CONSTRAINT `triagem_ibfk_1` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`),
  CONSTRAINT `triagem_ibfk_2` FOREIGN KEY (`id_risco`) REFERENCES `classificacao_risco` (`id_risco`),
  CONSTRAINT `triagem_ibfk_3` FOREIGN KEY (`id_enfermeiro`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `unidade` (
  `id_unidade` bigint NOT NULL AUTO_INCREMENT,
  `id_sistema` bigint DEFAULT NULL,
  `id_cidade` bigint NOT NULL,
  `nome` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('UPA','HOSPITAL','PA','CLINICA') COLLATE utf8mb4_general_ci NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_unidade`),
  KEY `id_cidade` (`id_cidade`),
  KEY `id_sistema` (`id_sistema`),
  CONSTRAINT `unidade_ibfk_1` FOREIGN KEY (`id_cidade`) REFERENCES `cidade` (`id_cidade`),
  CONSTRAINT `unidade_ibfk_2` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuario` (
  `id_usuario` bigint NOT NULL AUTO_INCREMENT,
  `id_pessoa` bigint NOT NULL,
  `login` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `senha_hash` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `seed_password` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `primeiro_login` tinyint(1) DEFAULT '1',
  `senha_expira_em` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `login` (`login`),
  KEY `id_pessoa` (`id_pessoa`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuario_alocacao` (
  `id_alocacao` bigint NOT NULL AUTO_INCREMENT,
  `id_usuario` bigint NOT NULL,
  `id_sala` int NOT NULL,
  `id_especialidade` int DEFAULT NULL,
  `inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `fim` datetime DEFAULT NULL,
  PRIMARY KEY (`id_alocacao`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_sala` (`id_sala`),
  KEY `id_especialidade` (`id_especialidade`),
  CONSTRAINT `usuario_alocacao_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `usuario_alocacao_ibfk_2` FOREIGN KEY (`id_sala`) REFERENCES `sala` (`id_sala`),
  CONSTRAINT `usuario_alocacao_ibfk_3` FOREIGN KEY (`id_especialidade`) REFERENCES `especialidade` (`id_especialidade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuario_perfil` (
  `id_usuario` bigint NOT NULL,
  `id_perfil` int NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_perfil`),
  KEY `id_perfil` (`id_perfil`),
  CONSTRAINT `usuario_perfil_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
  CONSTRAINT `usuario_perfil_ibfk_2` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `usuario_refresh` (
  `id_refresh` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID do refresh token',
  `id_usuario` bigint NOT NULL COMMENT 'Usuário dono do token',
  `token_hash` char(64) NOT NULL COMMENT 'Hash do refresh token',
  `expires_at` datetime NOT NULL COMMENT 'Expiração do token',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
  `revoked` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Token revogado',
  `user_agent` varchar(255) DEFAULT NULL COMMENT 'User agent do dispositivo',
  `ip` varchar(45) DEFAULT NULL COMMENT 'IP de origem',
  PRIMARY KEY (`id_refresh`),
  UNIQUE KEY `uk_token_hash` (`token_hash`),
  KEY `idx_usuario` (`id_usuario`),
  CONSTRAINT `fk_usuario_refresh_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Refresh tokens de autenticação com rotação e revogação';

CREATE TABLE `usuario_sistema` (
  `id_usuario` bigint NOT NULL,
  `id_sistema` bigint NOT NULL,
  `id_perfil` int NOT NULL,
  `ativo` tinyint(1) DEFAULT '1',
  `criado_em` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_usuario`,`id_sistema`,`id_perfil`),
  KEY `fk_us_sistema` (`id_sistema`),
  KEY `fk_us_perfil` (`id_perfil`),
  CONSTRAINT `fk_us_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`),
  CONSTRAINT `fk_us_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
  CONSTRAINT `fk_us_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci