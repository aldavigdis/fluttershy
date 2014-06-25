namespace :delete do
  # This should be set up as a Cron job and run every day to comply vith EU
  # privacy regulations.
  desc 'Delete login records older than 6 months'
  task :old_logins => :environment do
    Login.destroy_all(['updated_at < ?', 6.months.ago])
  end
end
