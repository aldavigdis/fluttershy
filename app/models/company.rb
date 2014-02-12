class Company < ActiveRecord::Base
  
  def self.search(search)
    if search and search[:name].present?
      bind = '%' + search[:name] + '%'
      find(:all, :conditions => ["name LIKE :term OR kt LIKE :term OR email LIKE :term OR tel LIKE :term OR mobile LIKE :term OR fax LIKE :term OR contact_name LIKE :term OR address1 LIKE :term OR address2 LIKE :term OR postcode LIKE :term OR city LIKE :term OR shipping_address1 LIKE :term OR shipping_address2 LIKE :term OR shipping_postcode LIKE :term OR shipping_city LIKE :term", {term: bind}])
    else
      find(:all)
    end
  end
  
  has_many :users, :dependent => :destroy
    
  validates :name, presence: { :message => "cannot be blank" }
  validates :kt, format: { with: /\A[0-9]+\z/, message: "Only numbers allowed" }, :allow_blank => true
  
end
