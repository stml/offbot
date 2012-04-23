class Project < ActiveRecord::Base
	attr_accessible :name, :people, :person_ids, :created_by
  has_and_belongs_to_many :people
  has_many :updates
  has_many :email_messages
  has_one :project_admins_list
  has_and_belongs_to_many :invitations
  validates_presence_of :name

  after_create :add_project_admins_list, :add_creator_to_admins

  def add_project_admins_list
  	admins_list = ProjectAdminsList.new
  	self.project_admins_list = admins_list
  end

  def add_creator_to_admins
  	creator = Person.find(self.created_by)
  	self.project_admins_list.people << creator
  end
end
