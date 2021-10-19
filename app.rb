require "bundler/setup"
require "date"
require "holiday_japan"
require "./lib/google_calendar.rb"
require "./lib/slack_notifer.rb"

today = Date.today
# 祝日だった場合は即終了
return if HolidayJapan.check(today)

google_calendar = GoogleCalendar.new

# 今日の予定
today_events = google_calendar.get_events(today).items.map{ |e| "- #{e.summary}" }
# 明日の予定
tommorow_events = google_calendar.get_events(today + 1).items.map{ |e| "- #{e.summary}" }

# 「休暇」という予定が含まれていた場合は終了
if tommorow_events.any? { |tommorow_event| tommorow_event.include?("休暇") }
  return
end

message = <<~EOS
  ☆ 日報コピペ用 ☆

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
