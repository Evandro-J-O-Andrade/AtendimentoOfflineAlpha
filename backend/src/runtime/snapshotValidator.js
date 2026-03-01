class SnapshotValidator {

    static validar(snapshot_hash_runtime, snapshot_hash_central) {

        if (!snapshot_hash_runtime || !snapshot_hash_central) {
            return false;
        }

        return snapshot_hash_runtime === snapshot_hash_central;
    }

}

module.exports = SnapshotValidator;