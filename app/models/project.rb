class Project < ActiveRecord::Base
	attr_accessible :name, :people, :person_ids, :created_by, :weekly_digest_day
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
    self.people << creator
  end

  def viewable_by?(person)
    self.people.include?(person) or person.is_superadmin?
  end

  def manageable_by?(person)
    self.created_by == person.id or person.is_superadmin? or person.is_admin?(self)
  end

  def to_slug
    #strip the string
    ret = self.name.downcase.strip

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with hyphen
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'  

    #convert double underscores to single hyphen
    ret.gsub! /_+/,"-"

    #strip off leading/trailing underscore
    ret.gsub! /\A[_\.]+|[_\.]+\z/,""

    #strip off leading/trailing hyphen
    ret.gsub! /\A[-\.]+|[-\.]+\z/,""

    ret
  end
end
