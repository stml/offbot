require 'spec_helper'

describe ScheduledRequestsMethods do

  describe 'a single person on a single active project' do
    let!(:person) {
      Person.create! \
        email: 'hello@example.com',
        password: 'example',
        name: 'ntlk'
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
  end
end
