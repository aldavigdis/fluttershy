class Company < ActiveRecord::Base
  
  has_many :users, :dependent => :destroy
    
  validates :name, presence: { :message => "cannot be blank" }
  validates :kt, format: { with: /\A[0-9]+\z/, message: "Only numbers allowed" }, :allow_blank => true
  
end
