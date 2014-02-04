class User < ActiveRecord::Base
  belongs_to :company
  has_many :logins
end
