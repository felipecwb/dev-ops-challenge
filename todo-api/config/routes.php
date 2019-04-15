<?php

use Felipecwb\Todo\Controllers\ListController;

$app->get('/', function ($resquest, $response) {
    return $response->withJson(['message' => 'Welcome!']);
});

$app->group('/v1', function () {
    $this->get('', function ($resquest, $response) {
        return $response->withJson(['todo' => 'API v1']);
    });

    $this->get('/list',         ListController::class . ':getList');
    $this->get('/list/{id}',    ListController::class . ':getOne');
    $this->post('/list',        ListController::class . ':create');
    $this->put('/list/{id}',    ListController::class . ':update');
    $this->delete('/list/{id}', ListController::class . ':delete');
    $this->post('/list/{id}/done',    ListController::class . ':setDone');
    $this->post('/list/{id}/pending', ListController::class . ':setPending');
});

