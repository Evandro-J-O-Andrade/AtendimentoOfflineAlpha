/**
 * ================================================================
 * Runtime Worker Processor
 * ================================================================
 * 
 * Processador de workers para o kernel.
 * Executa tarefas em background da fila de execução.
 * 
 * @version 1.0.0
 * @author Kernel Team
 * ================================================================
 */

const pool = require("../../config/database");

/**
 * Processador de workers
 */
class RuntimeWorkerProcessor {
    constructor(options = {}) {
        this.interval = options.interval || 1000; // 1 segundo
        this.batchSize = options.batchSize || 10;
        this.running = false;
        this.timer = null;
    }

    /**
     * Inicia o processador
     */
    start() {
        if (this.running) return;
        
        this.running = true;
        console.log("[runtime_worker_processor] Iniciando processador...");
        
        this.timer = setInterval(() => this.process(), this.interval);
        this.process(); // Executar imediatamente
    }

    /**
     * Para o processador
     */
    stop() {
        this.running = false;
        if (this.timer) {
            clearInterval(this.timer);
            this.timer = null;
        }
        console.log("[runtime_worker_processor] Processador parado");
    }

    /**
     * Processa a fila
     */
    async process() {
        const connection = await pool.getConnection();

        try {
            // Buscar tarefas pendentes
            const [tasks] = await connection.execute(
                `SELECT * FROM runtime_execution_queue 
                 WHERE status = 'PENDENTE'
                 ORDER BY prioridade DESC, criado_em ASC
                 LIMIT ?`,
                [this.batchSize]
            );

            if (tasks.length === 0) return;

            console.log(`[runtime_worker_processor] Processando ${tasks.length} tarefas`);

            for (const task of tasks) {
                await this.executeTask(task, connection);
            }

        } catch (error) {
            console.error("[runtime_worker_processor] Erro:", error.message);
        } finally {
            connection.release();
        }
    }

    /**
     * Executa uma tarefa
     */
    async executeTask(task, connection) {
        const startTime = Date.now();

        try {
            // Atualizar status
            await connection.execute(
                `UPDATE runtime_execution_queue SET status = 'PROCESSANDO' WHERE id = ?`,
                [task.id]
            );

            // Executar worker procedure
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
                 SET status = ?, duracao_ms = ?, atualizado_em = NOW() 
                 WHERE id = ?`,
                [sucesso ? 'CONCLUIDO' : 'ERRO', duration, task.id]
            );

            console.log(`[runtime_worker_processor] Tarefa ${task.id} concluída em ${duration}ms`);

        } catch (error) {
            // Marcar como erro
            await connection.execute(
                `UPDATE runtime_execution_queue 
                 SET status = 'ERRO', ultimo_erro = ?, atualizado_em = NOW() 
                 WHERE id = ?`,
                [error.message, task.id]
            );

            console.error(`[runtime_worker_processor] Erro na tarefa ${task.id}:`, error.message);
        }
    }
}

// Instância singleton
let processor = null;

/**
 * Inicia o processador global
 */
function startWorkerProcessor(options) {
    if (!processor) {
        processor = new RuntimeWorkerProcessor(options);
    }
    processor.start();
    return processor;
}

/**
 * Para o processador
 */
function stopWorkerProcessor() {
    if (processor) {
        processor.stop();
    }
}

module.exports = {
    RuntimeWorkerProcessor,
    startWorkerProcessor,
    stopWorkerProcessor
};
