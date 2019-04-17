<?php

namespace Felipecwb\Todo\Middlewares;

use Psr\Http\Message\RequestInterface;
use Psr\Http\Message\ResponseInterface;

class CrossOriginResourceSharing
{
    private $origin      = '*';
    private $headers     = 'User-Agent, Content-Type, Accept, Origin, Authorization';
    private $methods     = 'GET, POST, PUT, DELETE, PATCH, OPTIONS';
    private $credentials = false;

    public function __construct(array $options = [])
    {
        $this->origin      = $options['origin']      ?? $this->origin;
        $this->headers     = $options['headers']     ?? $this->headers;
        $this->methods     = $options['methods']     ?? $this->methods;
        $this->credentials = $options['credentials'] ?? $this->credentials;
    }

    public function __invoke(
        RequestInterface $request,
        ResponseInterface $response,
        callable $next
    ) {
        $response = $next($request, $response)
            ->withHeader('Access-Control-Allow-Origin',  $this->origin)
            ->withHeader('Access-Control-Allow-Headers', $this->headers)
            ->withHeader('Access-Control-Allow-Methods', $this->methods);

        if ($this->credentials) {
            $response = $response->withHeader('Access-Control-Allow-Credentials', 'true');
        }

        return $response;
    }
}


