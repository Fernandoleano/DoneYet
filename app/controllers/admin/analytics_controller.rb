class Admin::AnalyticsController < AdminController
  def index
    @total_visits = Ahoy::Visit.count
    @total_events = Ahoy::Event.count
    @recent_visits = Ahoy::Visit.includes(:user).order(started_at: :desc).limit(10)

    # Events by name for chart
    @events_by_name = Ahoy::Event.group(:name).count.sort_by { |_name, count| -count }.to_h

    # Visits by day (last 7 days)
    @visits_by_day = Ahoy::Visit.where("started_at > ?", 7.days.ago)
                                .group_by_day(:started_at)
                                .count

    # Reformat for Chart.js
    @visit_chart_data = {
      labels: @visits_by_day.keys.map { |d| d.strftime("%b %d") },
      values: @visits_by_day.values
    }

    # Top active users
    @top_users = User.joins(:ahoy_visits)
                     .group("users.id", "users.name")
                     .order("count(ahoy_visits.id) DESC")
                     .limit(5)
                     .count
  end

  def events
    @events = Ahoy::Event.order(time: :desc).limit(100)
  end

  def visits
    @visits = Ahoy::Visit.order(started_at: :desc).limit(100)
  end
end
