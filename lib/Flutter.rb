module Flutter
  
  class Access
    
    @@levels = { User: 0, Kiosk: 1, Admin: 2, Superuser: 3, Superadmin: 4 }
    
    def self.levels
      return @@levels
    end
    
    def self.new_user_access_levels(my_access)
      if my_access >= 2
        output_hash = {}
        @@levels.each do |key,value|
          if value <= my_access
            output_hash[key] = value
          end
        end
        return output_hash
      else
        return {}
      end
    end
    
  end
  
  class CurrentUser
    
    @@user_data = false
    
    def self.init_data(data_input)
      @@user_data = data_input
    end
    
    def self.company
      if @@user_data
        return @@user_data[:company]
      else
        return false
      end
    end
    
    def self.is_least_superuser
      if @@user_data
        return @@user_data[:access] >= 3
      else
        return false
      end
    end
    
    def self.is_least_admin
      if @@user_data
        return @@user_data[:access] >= 2
      else
        return false
      end
    end
    
    def self.is_least_kiosk
      if @@user_data
        return @@user_data[:access] >= 1
      else
        return false
      end
    end
    
    def self.is_least_user
      if @@user_data
        return @@user_data[:access] >= 0
      else
        return false
      end
    end
    
    def self.is_superadmin
      if @@user_data
        return @@user_data[:access] === 4
      else
        return false
      end
    end
  
    def self.is_superuser
      if @@user_data
        return @@user_data[:access] === 3
      else
        return false
      end
    end
  
    def self.is_admin
      if @@user_data
        return @@user_data[:access] === 2
      else
        return false
      end
    end
  
    def self.is_kiosk
      if @@user_data
        return @@user_data[:access] === 1
      else
        return false
      end
    end
  
    def self.is_user
      if @@user_data
        return @@user_data[:access] === 0
      else
        return false
      end
    end
    
  end
end
