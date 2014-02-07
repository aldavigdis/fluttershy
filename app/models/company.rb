class Company < ActiveRecord::Base
  
  def self.search(search)
    if search and search[:name].present?
      bind = '%' + search[:name] + '%'
      find(:all, :conditions => ["name LIKE ? OR kt LIKE ? OR email LIKE ? OR tel LIKE ? OR mobile LIKE ? OR fax LIKE ? OR contact_name LIKE ? OR address1 LIKE ? OR address2 LIKE ? OR postcode LIKE ? OR city LIKE ? OR shipping_address1 LIKE ? OR shipping_address2 LIKE ? OR shipping_postcode LIKE ? OR shipping_city LIKE ?", bind, bind, bind, bind, bind, bind, bind, bind, bind, bind, bind, bind, bind, bind, bind])
    else
      find(:all)
    end
  end
  
  has_many :users, :dependent => :destroy
    
  validates :name, presence: { :message => "cannot be blank" }
  validates :kt, format: { with: /\A[0-9]+\z/, message: "Only numbers allowed" }, :allow_blank => true
  
end
