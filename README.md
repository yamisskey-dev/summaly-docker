# summaly-docker

URLのサマリー情報を取得するSummaly APIのDockerイメージです。

## 起動方法

### 1. Docker Composeを使用する場合（推奨）

Nginxリバースプロキシと一緒に起動します。

```bash
git submodule init
git submodule update
cd example/
sudo docker compose up -d
```

起動後、`http://localhost/url?url=<対象URL>` でアクセスできます。

### 2. docker runで直接起動する場合

```bash
docker run -d \
  --name summaly \
  --restart always \
  -p 3030:3030 \
  ghcr.io/yamisskey-dev/summaly-docker:latest
```

起動後、`http://localhost:3030/url?url=<対象URL>` でアクセスできます。

## インターネットへの公開

### Cloudflare Tunnelで公開する場合

Cloudflaredを使用してインターネットに公開できます。

#### ポート指定

- **Docker Composeの場合**: ポート **80** (Nginxのポート)
- **docker runの場合**: ポート **3030** (Summalyのポート)

#### クイックトンネル（一時的な公開）

```bash
# docker runの場合
cloudflared tunnel --url http://localhost:3030

# Docker Composeの場合
cloudflared tunnel --url http://localhost:80
```

#### 永続的なトンネル設定

`~/.cloudflared/config.yml` に以下を設定:

```yaml
tunnel: <your-tunnel-id>
credentials-file: /path/to/credentials.json

ingress:
  - hostname: summaly.example.com
    service: http://localhost:3030  # docker runの場合は3030、Docker Composeの場合は80
  - service: http_status:404
```

トンネルを起動:

```bash
cloudflared tunnel run
```

## APIの使用例

```bash
# URLのサマリーを取得
curl "http://localhost:3030/url?url=https://example.com"
```

## 技術スタック

- Node.js 20 (Alpine)
- [Summaly](https://github.com/yamisskey-dev/summaly) - URL metadata scraper
- ポート: 3030
