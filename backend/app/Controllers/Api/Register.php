<?php

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\UserModel;

class Register extends BaseController
{
    public function index()
    {
        // 1. Ambil data input (Mendukung format x-www-form-urlencoded dari Post ATAU JSON dari Flutter)
        $json = $this->request->getJSON();
        
        $email    = $json->username ?? $json->email ?? $this->request->getPost('email');
        $password = $json->password ?? $this->request->getPost('password');

        // 2. Validasi jika inputan kosong
        if (empty($email) || empty($password)) {
            return $this->response->setJSON([
                'status'  => false,
                'message' => 'Email dan password tidak boleh kosong'
            ])->setStatusCode(400);
        }

        $userModel = new UserModel();

        // 3. Cek apakah email sudah terdaftar sebelumnya di database
        $cekUser = $userModel->where('email', $email)->first();
        if ($cekUser) {
            return $this->response->setJSON([
                'status'  => false,
                'message' => 'Email sudah terdaftar'
            ])->setStatusCode(400);
        }

        // 4. Siapkan data baru untuk dimasukkan ke database
        // 🟢 PASSWORD DISIMPAN SECARA MURNI TEKS BIASA (Tanpa fungsi password_hash)
        $data = [
            'email'    => $email,
            'password' => $password 
        ];

        // 5. Proses insert data ke tabel users
        if ($userModel->insert($data)) {
            return $this->response->setJSON([
                'status'  => true,
                'message' => 'Registrasi berhasil, silakan login!'
            ])->setStatusCode(201);
        }

        return $this->response->setJSON([
            'status'  => false,
            'message' => 'Gagal menyimpan data ke database'
        ])->setStatusCode(500);
    }
}
