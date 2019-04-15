<?php

use Psr\Container\ContainerInterface;
use Respect\Relational\Mapper as RelationalMapper;

$container[RelationalMapper::class] = function (ContainerInterface $container) {
    return new RelationalMapper(new PDO(
        getenv('DATABASE_DSN'),
        getenv('DATABASE_USER'),
        getenv('DATABASE_PASSWORD')
    ));
};

