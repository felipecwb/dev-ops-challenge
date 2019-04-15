<?php

(function () {
    require __DIR__ . '/../vendor/autoload.php';

    $app = new Slim\App(require __DIR__ . '/../config/settings.php');
    $container = $app->getContainer();

    require __DIR__ . '/../config/dependencies.php';
    require __DIR__ . '/../config/middlewares.php';
    require __DIR__ . '/../config/routes.php';

    $app->run();
})();

