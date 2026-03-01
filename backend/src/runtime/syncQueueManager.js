class SyncQueueManager {

    constructor() {
        this.queue = [];
    }

    enqueue(evento) {
        this.queue.push(evento);
    }

    dequeue() {
        return this.queue.shift();
    }

    tamanho() {
        return this.queue.length;
    }

}

module.exports = SyncQueueManager;