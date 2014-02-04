namespace :delete do
  desc 'Delete login records older than 6 months'
  task :old_logins => :environment do
    Login.destroy_all(['updated_at < ?', 6.months.ago])
  end
end
