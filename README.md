# A container to build RPM packges

Docker Composeファイルを配置します。ユーザ名やユーザIDなどの設定値は自分の環境に合わせて書き換えてください。

```
$ cp {,$HOME/.}docker-compose.yml
$ export COMPOSE_FILE=$HOME/.docker-compose.yml
```

MockコンテナでRPMビルドするには

```
$ docker-compose run --rm mockbuild --rebuild SRPMS/foobar-0.0.1-1.el7.src.rpm
```

コンテナ内でシェルを起動して作業するには

```
$ docker-compose run --rm --entrypoint=bash mockbuild
```

## License
See the LICENSE file for license rights and limitations (MIT).
