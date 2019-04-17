<?php

use Psr\Container\ContainerInterface;
use Respect\Relational\Db as RelationalDb;
use Respect\Relational\Mapper as RelationalMapper;

// databases
$container[PDO::class] = function (ContainerInterface $container) {
    return new PDO(
        getenv('DATABASE_DSN'),
        getenv('DATABASE_USER'),
        getenv('DATABASE_PASSWORD')
    );
};

$container[RelationalDb::class] = function (ContainerInterface $container) {
    return new RelationalDb($container->get(PDO::class));
};

$container[RelationalMapper::class] = function (ContainerInterface $container) {
    return new RelationalMapper($container->get(RelationalDb::class));
};

