FROM ruby:3.2.4
# ベースにするイメージを指定

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs default-mysql-client vim
# RailsのインストールやMySQLへの接続に必要なパッケージをインストール

RUN mkdir /myapp2
# コンテナ内にmyappディレクトリを作成

WORKDIR /myapp2
# 作成したmyappディレクトリを作業用ディレクトリとして設定

COPY Gemfile /myapp2/Gemfile
COPY Gemfile.lock /myapp2/Gemfile.lock
# ローカルの Gemfile と Gemfile.lock をコンテナ内のmyapp配下にコピー

RUN bundle install
# コンテナ内にコピーした Gemfile の bundle install

COPY . /myapp2
# ローカルのmyapp配下のファイルをコンテナ内のmyapp配下にコピー