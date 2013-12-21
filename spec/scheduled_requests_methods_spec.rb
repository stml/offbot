require 'spec_helper'

describe ScheduledRequestsMethods do

  describe 'a single person on a single active project' do
    let!(:person) {
      person = Person.create! \
        email: 'hello@example.com',
        password: 'example',
        name: 'ntlk'
      person.update_attribute(:active, true)
      person
    }

    let!(:project) {
      Project.create! \
        name: 'example',
        created_by: person.id,
        frequency: 0,
        archived: false
    }

    specify 'there should be one person' do
      Person.all.should have(1).person
    end

    specify 'there should be one project' do
      Project.all.should have(1).project
    end

    specify 'the person is on the project' do
      project.people.should include(person)
    end

    specify 'the project belongs to the person' do
      person.projects.should include(project)
    end

    context 'after a week has elapsed' do
      before(:each) do
        start_time = Time.local(2013, 12, 22).beginning_of_day
        timed_tasks = []

        timed_tasks << [start_time, -> { ScheduledRequestsMethods.schedule_update_requests }]

        task_time = start_time
        finish_time = start_time + 1.week
        while task_time < finish_time
          timed_tasks << [task_time, -> { ScheduledRequestsMethods.send_update_requests }]
          task_time += 1.hour
        end

        run_timed_tasks(timed_tasks)

        @emails = ActionMailer::Base.deliveries.select { |email| email.subject == "[#{project.name}] Hello, it's Offbott again" and email.to.include?(person.email)}
      end

      specify 'six emails have been sent' do # because it currently delivers on a Saturday too
        @emails.should have(6).messages
      end

      specify 'each email was sent on a different day' do
        @emails.map(&:date).map(&:to_date).uniq.should have(6).days
      end
    end
  end

  def run_timed_tasks(timed_tasks)
    timed_tasks.sort_by(&:first).each do |time, task|
      Timecop.freeze(time) do
        task.call
      end
    end
  end
end
