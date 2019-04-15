<?php

namespace Felipecwb\Todo\Controllers;

use DateTime;
use Slim\Http\Request;
use Slim\Http\Response;
use Respect\Relational\Mapper;
use Psr\Container\ContainerInterface;

class ListController
{
    /** @var Mapper **/
    private $mapper;

    public function __construct(ContainerInterface $container)
    {
        $this->mapper = $container->get(Mapper::class);
    }

    public function getList(Request $request, Response $response)
    {
        $status = $request->getQueryParam('status', null);
        $filter = $status ? ['status' => $status] : [];

        $list = $this->mapper->list($filter)->fetchAll();

        return $response->withJson($list);
    }

    public function create(Request $request, Response $response)
    {
        $body = $request->getParsedBody();
        if (! isset($body['title'])) {
            return $response->withJson(['error' => 'attribute title is missing.'], 428);
        }

        $todo = (object) [
            'id'          => null,
            'title'       => $body['title'],
            'description' => $body['description'] ?? null,
            'status'      => 'pending'
        ];

        $this->mapper->list->persist($todo);
        $this->mapper->flush();

        $date = new DateTime();
        $todo->created_at = $date->format(DateTime::W3C);
        $todo->updated_at = $date->format(DateTime::W3C);

        return $response->withJson($todo, 201);
    }

    public function getOne(Request $request, Response $response, array $params)
    {
        $todo = $this->mapper->list[$params['id']]->fetch();
        if (! $todo) {
            return $response->withJson(['error' => 'Item Not Found'], 404);
        }

        return $response->withJson($todo);
    }

    public function update(Request $request, Response $response, array $params)
    {
        $todo = $this->mapper->list[$params['id']]->fetch();
        if (! $todo) {
            return $response->withJson(['error' => 'Item Not Found'], 404);
        }

        $body = $request->getParsedBody();
        if (! isset($body['title'])) {
            return $response->withJson(['error' => 'attribute title is missing.'], 428);
        }

        $todo->title       = $body['title'];
        $todo->description = $body['description'] ?? $todo->description;
        if (isset($body['status']) && in_array($body['status'], ['pending', 'done'])) {
            $todo->status = $body['status'];
        }

        $this->mapper->list->persist($todo);
        $this->mapper->flush();

        return $response->withJson($todo);
    }

    public function delete(Request $request, Response $response, array $params)
    {
        $todo = $this->mapper->list[$params['id']]->fetch();
        if (! $todo) {
            return $response->withJson(['error' => 'Item Not Found'], 404);
        }

        $this->mapper->list->remove($todo);
        $this->mapper->flush();

        return $response->withJson($todo);
    }

    public function setDone(Request $request, Response $response, array $params)
    {
        [$data, $status] = $this->setNewStatus($params['id'], 'done');
        return $response->withJson($data, $status);
    }

    public function setPending(Request $request, Response $response, array $params)
    {
        [$data, $status] = $this->setNewStatus($params['id'], 'pending');
        return $response->withJson($data, $status);
    }

    protected function setNewStatus(int $id, string $status)
    {
        $todo = $this->mapper->list[$id]->fetch();
        if (! $todo) {
            return [['error' => 'Item Not Found'], 404];
        }

        $todo->status = $status;

        $this->mapper->list->persist($todo);
        $this->mapper->flush();

        return [$todo, 200];
    }
}

