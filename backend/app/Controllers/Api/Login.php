<?php

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\UserModel;

class Login extends BaseController
{
    public function index()
    {
        $email = $this->request->getPost('email');

        $password = $this->request->getPost('password');

        $userModel = new UserModel();

        $user = $userModel
            ->where('email', $email)
            ->where('password', $password)
            ->first();

        if ($user) {

            return $this->response->setJSON([

                'status' => true,

                'message' => 'Login berhasil'

            ]);
        }

        return $this->response->setJSON([

            'status' => false,

            'message' => 'Login gagal'

        ]);
    }
}
