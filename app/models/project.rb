class Project < ActiveRecord::Base
	attr_accessible :name, :people, :person_ids
  has_and_belongs_to_many :people
  has_many :updates
  has_and_belongs_to_many :invitations
  validates_presence_of :name
end
