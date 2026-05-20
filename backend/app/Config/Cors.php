<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class Cors extends BaseConfig
{
    public array $default = [

        'allowedOrigins' => ['*'],

        'allowedHeaders' => ['*'],

        'allowedMethods' => ['GET', 'POST', 'OPTIONS'],

        'exposedHeaders' => [],

        'maxAge' => 0,

        'supportsCredentials' => false,
    ];
}
