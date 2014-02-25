module TimedTaskHelpers
  def scheduled_emails_sent_between(start_time, end_time)
    already_sent_emails = ActionMailer::Base.deliveries.dup
    run_tasks_between(start_time, end_time)
    ActionMailer::Base.deliveries - already_sent_emails
  end

  def run_tasks_between(start_time, end_time)
    timed_tasks = []

    times_for_schedule_update_requests(start_time, end_time).each do |time|
      timed_tasks << [time, -> {
        begin
          ScheduledRequestsMethods.schedule_update_requests
        rescue RuntimeError
          # it's not Sunday
        end
      }]
    end

    times_for_send_update_requests(start_time, end_time).each do |time|
      timed_tasks << [time, -> { ScheduledRequestsMethods.send_update_requests }]
    end

    run_timed_tasks(timed_tasks)
  end

  # in Heroku scheduler, runs daily at 1500
  def times_for_schedule_update_requests(start_time, end_time)
    times = []

    task_time = start_time.beginning_of_day + 15.hours
    task_time += 1.day if task_time < start_time

    while task_time < end_time
      times << task_time
      task_time += 1.day
    end

    times
  end

  # in Heroku scheduler, runs hourly at half past the hour
  def times_for_send_update_requests(start_time, end_time)
    times = []

    task_time = start_time.beginning_of_hour + 30.minutes
    task_time += 1.hour if task_time < start_time

    while task_time < end_time
      times << task_time
      task_time += 1.hour
    end

    times
  end

  def run_timed_tasks(timed_tasks)
    timed_tasks.sort_by(&:first).each do |time, task|
      Timecop.freeze(time) do
        task.call
      end
    end
  end
end
