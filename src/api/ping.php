<?php
require 'config.php';
echo json_encode([
    'status' => 'ok',
    'mysql' => 'conectado',
    'porta' => 3306
]);
