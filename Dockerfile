FROM node:20-alpine

WORKDIR /app

# 必要なビルドツールをインストール
RUN apk add --no-cache git python3 make g++

# サブモジュールのファイルをコピー
COPY ./app /app/

# 依存関係をインストールしてビルド
RUN yarn install && \
    yarn build && \
    yarn cache clean

# サンプル設定をコピー
RUN cp server_config.example.yml server_config.yml || true

# ポートを公開
EXPOSE 3030

# アプリケーション実行
CMD ["yarn", "server"]
