class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :project_ids, :email_key
  has_many :updates
  has_many :email_messages
  has_many :scheduled_request_dates
  has_and_belongs_to_many :projects,
                          :after_add => :generate_schedule,
                          :after_remove => :remove_scheduled_dates
  belongs_to :project_admins_list
  validates_presence_of :email, :name
  validates_uniqueness_of :email

  after_create :generate_email_key

  scope :active, -> { where(active: true) }

  def is_admin?(project)
    project.project_admins_list.people.include?(self)
  end

  def can_view?(project)
    project.people.include?(self)
  end

  def is_superadmin?
    self.is_superadmin
  end

  def viewable_by?(person)
    !(self.projects & person.projects).empty? or person.is_superadmin?
  end

  def editable_by?(person)
    person.is_superadmin? or person == self
  end

  def generate_email_key
    uuid = UUID.new
    self.email_key = uuid.generate.to_s
    self.save
  end

  def generate_schedule(project)
    # remove old dates first
    ScheduledRequestDate.where(:person_id => self.id, :project_id => project.id).map {|date| date.destroy}
    # make new ones
    dates = ScheduledRequestsMethods.generate_scheduled_dates(project.frequency)
    if dates
      dates.each do |date|
        ScheduledRequestsMethods.create_scheduled_date(self, project, date)
      end
    end
  end

  def remove_scheduled_dates(project)
    all_dates = ScheduledRequestDate.find_by_person(self)
    if all_dates
      all_dates.each do |date|
        if date.project == project
          date.destroy
        end
      end
    end
  end

  private

  def add_to_projects
    invitation = Invitation.find_by_email(self.email)
    if invitation
      invitation.projects.each do |project|
        unless self.projects.include?(project)
          self.projects << project
        end
      end
    end
  end
end
