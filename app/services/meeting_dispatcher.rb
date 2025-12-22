class MeetingDispatcher
  def initialize(meeting)
    @meeting = meeting
  end

  def call
    return false unless valid_to_dispatch?

    ApplicationRecord.transaction do
      @meeting.update!(status: :dispatched, dispatched_at: Time.current)

      @meeting.missions.each do |mission|
        MissionDispatchJob.perform_later(mission)
      end
    end

    true
  rescue StandardError => e
    @meeting.errors.add(:base, e.message)
    false
  end

  private

  def valid_to_dispatch?
    if @meeting.missions.empty?
      @meeting.errors.add(:base, "Cannot dispatch empty briefing. Add at least one mission.")
      return false
    end

    if @meeting.dispatched? || @meeting.closed?
      @meeting.errors.add(:base, "Meeting is already dispatched.")
      return false
    end

    true
  end
end
