<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/response.php';
require_once __DIR__ . '/../config.php'; // mantém getPDO()
require_once __DIR__ . '/../jwt.php';
require_once __DIR__ . '/../middleware.php'; // validarToken()

handle_cors();

$pdo = getPDO();
