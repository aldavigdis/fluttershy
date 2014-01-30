class Company < ActiveRecord::Base
  validates :name, presence: { :message => "cannot be blank" }
  validates :kt, format: { with: /\A[0-9]+\z/, message: "Only numbers allowed" }, :allow_blank => true
end
