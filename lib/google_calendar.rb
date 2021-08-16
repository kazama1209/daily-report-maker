require "bundler/setup"
require "google/apis/calendar_v3"
require "googleauth"
require "dotenv"

Dotenv.load

CREDENTIALS_PATH = "./credentials.json".freeze # サービスアカウント作成時にDLしたJSONファイルをリネームしてルートディレクトリに配置。
CALENDER_ID = ENV["CALENDER_ID"].freeze # Googleカレンダー設定ページの「カレンダーの統合」という項目内に記載されている。

# Googleカレンダー用クラス
class GoogleCalendar
  def initialize
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.authorization = authorize
    @calendar_id = CALENDER_ID
  end

  # 認証
  def authorize
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: open(CREDENTIALS_PATH),
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
    )
    authorizer.fetch_access_token!
    authorizer
  end

  # 引数に渡した日付をもとに予定一覧を取得
  def get_events(date)
    @service.list_events(
      @calendar_id,
      max_results: 10,               # 取得する予定の最大数。
      single_events: true,
      order_by: "startTime",
      time_zone: "Asia/Tokyo",
      time_min: "#{date}T00:00:00Z", # 始点
      time_max: "#{date}T23:59:59Z"  # 終点
    )
  end
end
