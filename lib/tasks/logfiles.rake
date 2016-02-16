begin
  namespace :logs do

    desc 'Grab latest import log'
    task :get_import_log => :environment do
      system 'scp "enspiral@173.255.206.188:/home/enspiral/production/shared/log/xero_import.log" .'
    end

    desc 'Grab latest import log'
    task :get_production_log => :environment do
      system 'scp "enspiral@173.255.206.188:/home/enspiral/production/shared/log/production.log" .'
    end

  end
end
