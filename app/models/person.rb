class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :name
  has_many :updates
  has_and_belongs_to_many :projects
  validates_presence_of :email, :name

  after_create :add_to_projects

  private

  def add_to_projects
    invitation = Invitation.find_by_email(self.email)
    if invitation
      invitation.projects.each do |project|
        self.projects << project
      end
    end
  end
end
