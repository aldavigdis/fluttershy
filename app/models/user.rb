class User < ActiveRecord::Base
  
  belongs_to :company
  has_many :logins, :dependent => :destroy
  
  validates :fullname, presence: { :message => "cannot be blank" }
  validates :email, format: { with: /@/, message: "must be a valid email address" }
  
end
