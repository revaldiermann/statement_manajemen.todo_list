<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
// Halaman Utama bawaan CI4
$routes->get('/', 'Home::index');

// 🟢 AKTIFKAN KEMBALI RUTE POST LOGIN (Hapus tanda //)
$routes->post('login', 'Api\Login::index');
$routes->post('register', 'Api\Register::index'); 

// Rute uji coba (opsional, boleh dihapus atau dibiarkan)
$routes->get('test-login', 'Api\Login::index');

$routes->get('test', function() {
    return 'API CONNECTED';
});
