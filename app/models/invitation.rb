class Invitation < ActiveRecord::Base
  attr_accessible :email
  has_and_belongs_to_many :projects
  validates :email, presence: true
  validates :token, presence: true
  before_validation :generate_token

  after_create :send_out_invite
  after_update :send_out_invite

  def generate_token
    self.token = SecureRandom.hex(4)
  end

  def send_out_invite
    SendInvitation.send_out_invite(self).deliver
  end
end
