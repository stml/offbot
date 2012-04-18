class Project < ActiveRecord::Base
	attr_accessible :name
  has_many :people
  has_many :updates
  validates_presence_of :name
end
