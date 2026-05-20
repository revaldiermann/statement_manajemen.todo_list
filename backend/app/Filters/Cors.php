<?php

namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class Cors implements FilterInterface
{
    public function before(
        RequestInterface $request,
        $arguments = null
    ) {

        header('Access-Control-Allow-Origin: *');

        header(
            'Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token'
        );

        header(
            'Access-Control-Allow-Methods: GET, POST, OPTIONS'
        );

        if ($request->getMethod() === 'options') {

            response()->setStatusCode(200);

            exit();
        }
    }

    public function after(
        RequestInterface $request,
        ResponseInterface $response,
        $arguments = null
    ) {
    }
}
