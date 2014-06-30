module Flutter
  
  # Class to manage user access levels.
  class Access
    
    # The standard access levels
    #
    # * 0 - User: A normal user with mostly read-only access to data assigned
    #   to him/her and basic info on the company he/she is assigned to. Can
    #   change own password, but an *Admin* can only change or assign or modify
    #   other info.
    # * 1 - Kiosk: Reserved for self-service kiosks.
    # * 2 - Admin: Can read/write access to own company. Can add and edit info
    #   for users assigned to the same company.
    # * 3 - Superuser: Aimed at level 1 support employees. Has read-only access
    #   to data on every company and to every user in every company.
    # * 4 - Superadmin: Has read and write access to every user in every company.
    @@levels = { User: 0, Kiosk: 1, Admin: 2, Superuser: 3, Superadmin: 4 }
    
    # Get the values of the levels constant
    # @see @@levels
    # @return [Hash]
    def self.levels
      return @@levels
    end
    
    # Get the user access levels of new users the current user can create
    #
    # @param my_access [Integer] The access level of the current user
    # @return [Hash, Boolean] Hash with access levels of users the current user
    #   is able to create, or false if the current user cannot create new users.
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
        return false
      end
    end
    
  end
  
  # Class to get and manage the current user.
  class CurrentUser
    
    @@user_data = false
    
    # Initiate user data
    #
    # @example
    #   Flutter::CurrentUser.init_data({
    #     access: session[:user_access],
    #     company: session[:company_id]
    #   })
    def self.init_data(data_input)
      @@user_data = data_input
    end
    
    # Get the user's company ID (Primary Key)
    #
    # @example
    #   Flutter::CurrentUser.company
    #   => 1
    #
    # @return [boolean, integer] The company ID (Primary Key), false on faliure
    def self.company
      if defined?(@@user_data)
        return @@user_data[:company]
      else
        return false
      end
    end
    
    # Check if the user is at least a _superuser_
    #
    # @example
    #   Flutter::CurrentUser.is_least_superuser => true
    #
    # @return [boolean]
    def self.is_least_superuser
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] >= 3
      else
        return false
      end
    end
    
    # Check if the user is at least an _admin_ user
    #
    # @example
    #   Flutter::CurrentUser.is_least_admin => true
    #
    # @return [boolean]
    def self.is_least_admin
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] >= 2
      else
        return false
      end
    end
    
    # Check if the user is at least a _kiosk_ user
    #
    # @example
    #   Flutter::CurrentUser.is_least_kiosk => true
    #
    # @return [boolean]
    def self.is_least_kiosk
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] >= 1
      else
        return false
      end
    end
    
    # Check if the user is at least a normal _user_.
    #
    # @example
    #   Flutter::CurrentUser.is_least_user => true
    #
    # @return [boolean]
    def self.is_least_user
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] >= 0
      else
        return false
      end
    end
    
    # Check if the user is a _superadmin_.
    #
    # @example
    #   Flutter::CurrentUser.is_superadmin => true
    #
    # @return [boolean]
    def self.is_superadmin
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] === 4
      else
        return false
      end
    end
  
    # Check if the user is a _superuser_.
    #
    # @example
    #   Flutter::CurrentUser.is_superuser => true
    #
    # @return [boolean]
    def self.is_superuser
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] === 3
      else
        return false
      end
    end
    
    # Check if the user is an _admin_.
    #
    # @example
    #   Flutter::CurrentUser.is_admin => true
    #
    # @return [boolean]
    def self.is_admin
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] === 2
      else
        return false
      end
    end
    
    # Check if the user is a _kiosk_ user.
    #
    # @example
    #   Flutter::CurrentUser.is_kiosk => true
    #
    # @return [boolean]
    def self.is_kiosk
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] === 1
      else
        return false
      end
    end
    
    # Check if the user is a normal _user_.
    #
    # @example
    #   Flutter::CurrentUser.is_user => true
    #
    # @return [boolean]
    def self.is_user
      if defined?(@@user_data[:access]) && @@user_data[:access] != nil
        return @@user_data[:access] === 0
      else
        return false
      end
    end
    
  end
end
