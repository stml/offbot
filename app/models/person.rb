class Person < ActiveRecord::Base
  attr_accessible :email, :name
  has_many :updates
  belongs_to :project
  validates_presence_of :email, :name
end
