module ApplicationHelper
  def greeting_for_time_of_day
    hour = Time.current.hour

    case hour
    when 5..11
      "Good morning"
    when 12..17
      "Good afternoon"
    when 18..21
      "Good evening"
    else
      "Good evening" # Late night/early morning
    end
  end
end
