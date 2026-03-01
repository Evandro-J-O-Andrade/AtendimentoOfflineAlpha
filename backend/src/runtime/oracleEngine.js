class OracleEngine {

    static async decidir({ runtime_session, protocolo_valido, snapshot_valido }) {

        if (!runtime_session) {
            return "BLOQUEAR";
        }

        if (!protocolo_valido) {
            return "DEGRADAR_MODE";
        }

        if (!snapshot_valido) {
            return "DEGRADAR_MODE";
        }

        return "PERMITIR";
    }

}

module.exports = OracleEngine;