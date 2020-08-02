class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
   
    # wdayで今日の曜日のインデックス番号を取得
    wdays_first_index = @todays_date.wday

    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日
    @week_days = []

    @plans = Plan.where(date: @todays_date..@todays_date + 7)
    wday_index = wdays_first_index
    7.times do |x|
  
      plans = []
      plan = @plans.map do |plan|
        plans.push(plan.plan) if plan.date == @todays_date + x
      end
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: plans, wday: (wdays[wday_index])}
      @week_days.push(days)
      # 曜日のインデックス番号が6まできたら0に戻す処理を実施
      if wday_index == 6
        wday_index = 0
      else
        wday_index += 1
      end
    end

  end
end
