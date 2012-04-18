class Invitation < ActiveRecord::Base
  attr_accessible :email
  has_and_belongs_to_many :projects
  validates_presence_of :email
end
