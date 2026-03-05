/**
 * ================================================================
 * Worker Runner - Async Execution Engine
 * ================================================================
 * 
 * Poll da fila de execução e processa workers em background.
 * Configuração: 500ms → 2s (edge runtime)
 * 
 * Fluxo:
 * runtime Worker Procedure_execution_queue → → Ledger → Status Update
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const pool = require("../config/database");

// Configurações do worker
const WORKER_CONFIG = {
    pollInterval: 1000,        // 1 segundo entre polls
    maxRetries: 3,              // Máximo de tentativas
    batchSize: 10,              // Quantidade por batch
    timeout: 30000,             // Timeout de 30s por tarefa
    ledgerEnabled: true          // Habilitar ledger
};

/**
 * Worker Runner principal
 * Executa em loop, processando a fila de execução
 */
class WorkerRunner {
    constructor(config = {}) {
        this.config = { ...WORKER_CONFIG, ...config };
        this.running = false;
        this.intervalId = null;
        this.stats = {
            processed: 0,
            failed: 0,
            lastRun: null
        };
    }

    /**
     * Inicia o worker
     */
    start() {
        if (this.running) {
            console.log("[worker_runner] Worker já está em execução");
            return;
        }

        this.running = true;
        console.log(`[worker_runner] Worker iniciado (interval: ${this.config.pollInterval}ms)`);

        this.intervalId = setInterval(() => {
            this.processQueue();
        }, this.config.pollInterval);

        // Executar imediatamente
        this.processQueue();
    }

    /**
     * Para o worker
     */
    stop() {
        if (!this.running) return;

        this.running = false;
        if (this.intervalId) {
            clearInterval(this.intervalId);
            this.intervalId = null;
        }
        console.log("[worker_runner] Worker parado");
    }

    /**
     * Processa a fila de execução
     */
    async processQueue() {
        const connection = await pool.getConnection();

        try {
            // Buscar tarefas pendentes
            const [tasks] = await connection.execute(
                `SELECT * FROM runtime_execution_queue 
                 WHERE status = 'PENDENTE' 
                 AND (retry_count IS NULL OR retry_count < ?)
                 ORDER BY prioridade DESC, criado_em ASC
                 LIMIT ?`,
                [this.config.maxRetries, this.config.batchSize]
            );

            if (tasks.length === 0) {
                this.stats.lastRun = new Date();
                return;
            }

            console.log(`[worker_runner] Processando ${tasks.length} tarefas`);

            // Processar cada tarefa
            for (const task of tasks) {
                await this.processTask(task, connection);
            }

            this.stats.lastRun = new Date();

        } catch (error) {
            console.error("[worker_runner] Erro ao processar fila:", error.message);
        } finally {
            connection.release();
        }
    }

    /**
     * Processa uma tarefa individual
     */
    async processTask(task, connection) {
        const startTime = Date.now();
        
        try {
            // Atualizar status para processando
            await connection.execute(
                `UPDATE runtime_execution_queue 
                 SET status = 'PROCESSANDO', atualizado_em = NOW() 
                 WHERE id = ?`,
                [task.id]
            );

            // Log no ledger se habilitado
            if (this.config.ledgerEnabled) {
                await this.logToLedger(task, connection, "PROCESSANDO");
            }

            // Chamar worker procedure
            const [results] = await connection.query(
                `CALL sp_worker_execute(?, ?, ?, ?, ?, ?, @resultado, @sucesso, @mensagem)`,
                [task.id, task.id_usuario, task.id_perfil, task.acao, task.contexto, task.payload]
            );

            // Obter resultado
            const [[output]] = await connection.query(
                `SELECT @resultado as resultado, @sucesso as sucesso, @mensagem as mensagem`
            );

            const duration = Date.now() - startTime;
            const sucesso = output.sucesso === 1 || output.sucesso === true;

            // Atualizar status final
            await connection.execute(
                `UPDATE runtime_execution_queue 
                 SET status = ?, 
                     atualizado_em = NOW(),
                     duracao_ms = ?,
                     resultado = ?
                 WHERE id = ?`,
                [sucesso ? "CONCLUIDO" : "ERRO", duration, output.mensagem || null, task.id]
            );

            // Log no ledger
            if (this.config.ledgerEnabled) {
                await this.logToLedger(task, connection, sucesso ? "CONCLUIDO" : "ERRO", output.mensagem);
            }

            if (sucesso) {
                this.stats.processed++;
            } else {
                this.stats.failed++;
            }

            console.log(`[worker_runner] Tarefa ${task.id} ${sucesso ? 'concluída' : 'falhou'} em ${duration}ms`);

        } catch (error) {
            // Incrementar retry count
            await connection.execute(
                `UPDATE runtime_execution_queue 
                 SET retry_count = COALESCE(retry_count, 0) + 1,
                     ultimo_erro = ?,
                     atualizado_em = NOW()
                 WHERE id = ?`,
                [error.message, task.id]
            );

            this.stats.failed++;
            console.error(`[worker_runner] Erro na tarefa ${task.id}:`, error.message);
        }
    }

    /**
     * Registra no ledger
     */
    async logToLedger(task, connection, status, mensagem = null) {
        try {
            await connection.execute(
                `INSERT INTO kernel_ledger (id_transacao, id_sessao, id_usuario, acao, contexto, payload, status, duracao_ms, mensagem, registrado_em)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())`,
                [task.id, task.id_sessao, task.id_usuario, task.acao, task.contexto, task.payload, status, null, mensagem]
            );
        } catch (error) {
            console.warn("[worker_runner] Erro ao logar no ledger:", error.message);
        }
    }

    /**
     * Retorna estatísticas do worker
     */
    getStats() {
        return {
            ...this.stats,
            running: this.running,
            config: this.config
        };
    }
}

// Instância singleton
let workerInstance = null;

/**
 * Inicia o worker global
 */
function startWorker(config) {
    if (!workerInstance) {
        workerInstance = new WorkerRunner(config);
    }
    workerInstance.start();
    return workerInstance;
}

/**
 * Para o worker global
 */
function stopWorker() {
    if (workerInstance) {
        workerInstance.stop();
    }
}

/**
 * Retorna estatísticas
 */
function getWorkerStats() {
    return workerInstance ? workerInstance.getStats() : null;
}

module.exports = {
    WorkerRunner,
    startWorker,
    stopWorker,
    getWorkerStats
};
