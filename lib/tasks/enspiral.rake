begin
  namespace :enspiral do

    desc 'Update blog posts for all blogs'
    task :get_updated_blog_posts => :environment do
      Blog.all.each do |b|
        b.get_updated_posts
      end
    end

    desc 'Mail all users their capacity for the next 5 weeks'
    task :mail_users_capacity_info => :environment do
#      Person.active.each do |person|
#        if person.projects.size > 0
#          Notifier.capacity_notification(person).deliver
#        end
#      end
    end

    #legacy DELETE WHEN REMOVING OLD MARKETING.
    desc 'Get updated feeds from enspiral blog'
    task :get_updated_feeds => :environment do
      FeedEntry.get_updated_feeds
    end

    desc 'Get Invoice from xero for enspiral services and update'
    task  :get_invoices_from_xero => :environment do
      company = Company.find_by_name("Enspiral Services")
      company.get_invoice_from_xero_and_update if company
    end

    desc 'Update xero invoice every 6 hours'
    task  :update_invoices_in_xero => :environment do
      company = Company.find_by_name("Enspiral Services")
      company.check_invoice_and_update if company
    end

    desc 'Get single invoice from xero for enspiral services and update'
    task  :get_invoice_from_xero, [:xero_ref] => :environment do |t, args|
      puts "Invoice #{args.xero_ref} is being import ..."
      company = Company.find_by_name("Enspiral Services")
      company.get_single_invoice_from_xero(args.xero_ref) if company
    end

    desc 'Approved all paid invoices'
    task :approved_all_paid_invoices => :environment do
      company = Company.find_by_name("Enspiral Services")
      company.approved_all_paid_invoices if company
    end

    desc 'Aprroved invoice older than 2013'
    task :approved_older_than_2013 => :environment do
      invoices = Invoice.where("date <= ?", "2013-01-01".to_date)
      invoices.each do |inv|
        inv.approved = true
        inv.save
      end
    end

    desc 'Backup production database'
    task  :backup_production => :environment do
      if Rails.env.production?
        db_config = YAML.load_file('config/database.yml')[Rails.env]
        password_setting = "PGPASSWORD=""#{db_config["password"]}"" " if db_config["password"]
        backup_name = "#{Time.now.year}#{Time.now.month}#{Time.now.day}.sql"
        system "PGPASSWORD=#{password_setting} pg_dump enspiral_production > /home/enspiral/backups/#{backup_name}"
      end
    end
  end
end
