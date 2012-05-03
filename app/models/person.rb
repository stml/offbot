class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  has_many :updates
  has_many :email_messages
  has_and_belongs_to_many :projects
  belongs_to :project_admins_list
  validates_presence_of :email, :name
  validates_uniqueness_of :email

  after_create :add_to_projects, :set_superadmin_to_false

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
    !(self.projects & person.projects).empty? or self.is_superadmin?
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

  def set_superadmin_to_false
    self.is_superadmin = false
  end
end
