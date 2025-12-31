<?php
require_once __DIR__ . '/../controllers/FilaController.php';

$controller = new FilaController();

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['proximo'])) {
    $controller->proximoPaciente();
}
