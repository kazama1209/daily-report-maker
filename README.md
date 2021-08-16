# daily-report-maker

![スクリーンショット 2021-08-17 3 54 42_censored (1)](https://user-images.githubusercontent.com/51913879/129616235-0b3d4b5d-43ea-41d2-9fc1-8a4031f6108c.jpg)

日報メーカー。毎回わざわざGoogleカレンダーの予定を確認しに行って一個一個書き込むみたいなのが面倒だったので作った。毎日終業時にSlackへ通知してくれるので、後はコピペすればOK。

## セットアップ

Rubyのバージョン設定。

```
$ rbenv local 2.7.1
```

gemをインストール。

```
$ bundle install --path vendor/bundle
```

環境変数をセット。

```
$ cp .env.example .env

CALENDER_ID=<GoogleカレンダーID>
SLACK_BOT_TOKEN=<SlackBotのトークン>
SLACK_CHANNEL_NAME=<送信したいSlackチャンネル>
KOF_URL=<勤怠管理のURL（今回はKING_OF_TIMEを想定）>
TUNAG_URL=<日報ページのURL（今回はTUNAGを想定）>
```

動作確認。

```
$ bundle exec ruby app.rb
```

## デプロイ 

各自お好みで。LambdaとCloudWatch Eventsの組み合わせが簡単でお財布に優しいと思う。

参照記事: [https://qiita.com/kazama1209/items/a9be845f80a5d7dc59ba](https://qiita.com/kazama1209/items/a9be845f80a5d7dc59ba#%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4)
