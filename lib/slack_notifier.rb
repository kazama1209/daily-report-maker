require "bundler/setup"
require "dotenv"
require "slack-ruby-client"

Dotenv.load

SLACK_BOT_TOKEN = ENV["SLACK_BOT_TOKEN"].freeze
SLACK_CHANNEL_NAME = ENV["SLACK_CHANNEL_NAME"].freeze

# Slack通知用クラス
class SlackNotifier
  def initialize
    @client = Slack::Web::Client.new(token: SLACK_BOT_TOKEN)
  end

  # メッセージを送信
  def send(message)
    @client.chat_postMessage(
      channel: SLACK_CHANNEL_NAME, # 送信したいSlackチャンネル
      text: message, 
      as_user: true
    )
  end
end
