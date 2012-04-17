class Project < ActiveRecord::Base
  has_many :people
  has_many :updates
  validates_presence_of :name
end
