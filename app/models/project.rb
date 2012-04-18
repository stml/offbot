class Project < ActiveRecord::Base
	attr_accessible :name
  has_and_belongs_to_many :people
  has_many :updates
  validates_presence_of :name
end
