Gazosure - 2ch画像スレ風画像ビューア
============================================

config/deployment.plに画像ディレクトリのパスと書いて適当なPSGIサーバで動かすと、ディレクトリを再帰的にリンクとして羅列します。
リンク先で２ちゃんの画像スレっぽい感じで表示します。

    # よくある立ち上げ例
    $ PLACK_ENV=deployment plackup --port=9090 app.psgi
