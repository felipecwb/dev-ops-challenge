<?php

namespace Felipecwb\Todo\Controllers;

use Throwable;
use Slim\Http\Request;
use Slim\Http\Response;
use Respect\Relational\Db;
use Psr\Container\ContainerInterface;

class HealthCheckController
{
    /** @var ContainerInterface **/
    private $container;

    public function __construct(ContainerInterface $container)
    {
        $this->container = $container;
    }

    public function __invoke(Request $request, Response $response)
    {
        $status = 200;
        $message = 'Ok';

        try {
            $db = $this->container->get(Db::class);
            $result = $db->select('1 AS alive')->fetch();

            if (! isset($result->alive)) {
                throw new \Exception('database is unavailable');
            }
        } catch (Throwable $e) {
            $status = 500;
            $message = $e->getMessage();
        }

        return $response->withJson([
            'code'    => $status,
            'message' => $message,
            'date'    => date('Y-m-d H:i:s')
        ], $status);
    }
}
