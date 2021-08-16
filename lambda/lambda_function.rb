require "bundler/setup"
require "date"
require "holiday_japan"
require "./lib/google_calendar"
require "./lib/slack_notifer.rb"

# AWS Lambdaで動かす用
def lambda_handler(event:, context:)
  today = Date.today
  # 祝日だった場合は即終了
  return if HolidayJapan.check(today)

  google_calendar = GoogleCalendar.new

  # 今日の予定
  today_events = google_calendar.get_events(today).items.map{ |e| "- #{e.summary}" }
  # 明日の予定
  tommorow_events = google_calendar.get_events(today + 1).items.map{ |e| "- #{e.summary}" }

  message = <<~EOS
    ☆ 日報コピペ用 ☆

    打刻: #{ENV["KOF_URL"]}
    日報: #{ENV["TUNAG_URL"]}

    ```
    【本日の業務】
    #{today_events.map.with_index{ |e, i| i != (today_events.size - 1) ? "#{e} \n" : e }.join}

    【明日の予定】
    #{tommorow_events.map.with_index{ |e, i| i != (tommorow_events.size - 1) ? "#{e} \n" : e }.join}

    【一言】
    お疲れ様でした。
    ```
  EOS

  # Slackにメッセージを送信
  slack_notifer = SlackNotifer.new
  slack_notifer.send(message)
end
