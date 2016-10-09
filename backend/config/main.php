<?php
$params = array_merge(
    require(__DIR__ . '/../../common/config/params.php'),
    require(__DIR__ . '/../../common/config/params-local.php'),
    require(__DIR__ . '/params.php'),
    require(__DIR__ . '/params-local.php')
);

return [
    'id' => 'app-backend',
    'basePath' => dirname(__DIR__),
    'controllerNamespace' => 'backend\controllers',
    'bootstrap' => ['log'],
    'modules' => [],
    'components' => [
        'user' => [
            'identityClass' => 'common\models\User',
            'enableAutoLogin' => true,
        ],
        'log' => [
            'traceLevel' => YII_DEBUG ? 3 : 0,
            'targets' => [
                [
                    'class' => 'yii\log\FileTarget',
                    'levels' => ['error', 'warning'],
                ],
            ],
        ],
        'errorHandler' => [
            'errorAction' => 'site/error',
        ],
        //'assetManager' => [  
//            'bundles' => [
//                'yii\bootstrap\BootstrapPluginAsset' => ['js'=>[]], 
//                'yii\bootstrap\BootstrapAsset' => ['css' => []]   
//            ]
//        ],

        'assetManager' => [
            'bundles' => [
                // you can override AssetBundle configs here       
                 'yii\web\JqueryAsset' => [
                    'sourcePath' => 'js/',
                    'js' => ['jquery-3.1.0.js']
                ],
            ],
        ],
    ],
    'params' => $params,
];
