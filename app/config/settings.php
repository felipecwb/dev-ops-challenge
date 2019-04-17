<?php

return ['settings' => [
    'project' => 'todo-api',

    'environment'         => getenv('ENVIRONMENT'),
    'displayErrorDetails' => getenv('ENVIRONMENT') === 'development',
    'debug'               => getenv('ENVIRONMENT') === 'development',
]];

