# Ruby App用環境

* Dockerイメージのビルド

```
$ docker build -t katsuya61/rubyapp .
```

* コンテナの起動

```
$ docker run -itd -p 80:80 -p 443:443 --name container001 -h host001 katsuya61/rubyonrails5
```

* コンテナの削除

```
$ docker container rm -f container001
```

* コンテナのログイン

```
$ docker exec -it container001 /bin/sh
```

