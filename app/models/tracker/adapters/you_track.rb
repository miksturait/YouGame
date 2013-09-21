class Tracker::Adapters::YouTrack

  attr_accessor :tracker, :conn, :options

  DEFAULTS = {
      issue_difficulty_field: 'Difficulty',
      issue_accepted_state: 'Fixed',
      issue_in_progress_state: 'In Progress',
      issue_backlog_state: 'Submitted',
      role_name: 'youGame observers',
      username: 'youGameObserver'
  }.freeze

  PERMISSIONS = %w(ADMIN_APP READ_ISSUE PRIVATE_READ_ISSUE READ_COMMENT READ_PROFILE
                   READ_PROJECT READ_NOT_OWN_PROFILE READ_USER READ_USERGROUP READ_ROLE).freeze

  DIFFICULTY_LEVELS = [
      {id: 'Easy', colorIndex: '3'},
      {id: 'Medium', colorIndex: '11'},
      {id: 'Hard', colorIndex: '1'}
  ].freeze

  def initialize(tracker, options = {})
    begin
      self.tracker = tracker
      self.options = options
      tracker.init_conn
      self.conn = tracker.conn
      process
    rescue Exception => e
      AppMailer.update_exception(e).deliver unless [SocketError, Errno::ETIMEDOUT, Net::ReadTimeout].include? e.class
      tracker.move_to_idle
    end
  end

end