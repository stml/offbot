module ProjectsHelper
  def updates_count(person, project)
    # count number of updates per project
    count = 0
    for update in project.updates
      if update.person == person
        count = count + 1
      end
    end
    count
  end
end
