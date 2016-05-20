require 'loggers/import_logger'

include Loggers

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

    desc 'Import Invoices from xero for enspiral services'
    task  :get_invoices_from_xero => :environment do |t, args|
      # Company.with_xero_integration.each do |company|
      log "------------------------ #{Time.zone.now} ----------------------------------"
      [Company.enspiral_services].each do |company|
        log "Importing invoices for #{company.name}..."
        begin
          company.import_xero_invoices
        rescue => e
          log "Mailing dev about error #{e.inspect}"
          log e.backtrace
          mail = Notifier.mail_current_developers(e, company)
          mail.deliver
          raise e
        end
      end
    end

    # this does not get run!! switched off in schedule.rb
    desc 'Update xero invoice every 6 hours'
    task  :update_invoices_in_xero => :environment do
      company = Company.enspiral_services
      company.check_invoice_and_update
    end

    desc 'Get single invoice from xero for enspiral services and update'
    task  :get_invoice_from_xero, [:xero_ref] => :environment do |t, args|
      company = Company.enspiral_services
      begin
        puts "Invoice #{args.xero_ref} is being imported. If an existing invoice exists, it will not be overwritten (it will error out instead)."
        company.import_xero_invoice(args.xero_ref)
      rescue => e
        mail = Notifier.mail_current_developers(e, company)
        mail.deliver
        raise e
      end
    end

    desc 'Get single invoice from xero for enspiral services and overwrite it'
    task  :import_invoice_and_overwrite, [:xero_ref] => :environment do |t, args|
      puts "Invoice #{args.xero_ref} is being imported. It will overwrite any existing invoice information."
      company = Company.enspiral_services
      company.import_xero_invoice(args.xero_ref, true)
    end

    desc 'Approved all paid invoices'
    task :approved_all_paid_invoices => :environment do
      company = Company.enspiral_services
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

    desc 'Send Funds Cleard Out Notification'
    task :send_funds_cleared_out_notification do
      Account.send_email_when_funds_cleared
    end

    desc 'Backup production database'
    task  :backup_production => :environment do
      if Rails.env.production?
        # db_config = YAML.load_file('config/database.yml')[Rails.env]
        # password_setting = "PGPASSWORD=""#{db_config["password"]}""" if db_config["password"]
        backup_name = "#{Time.now.year}#{Time.now.month}#{Time.now.day}.sql"
        system "pg_dump my_enspiral_production > ~/backup/#{backup_name}"
      end
    end

    desc 'Get unreconciled external transactions from xero and populate db'
    task  :get_xero_transactions_for_reconciliation => :environment do
      company = Company.find_by_name("Enspiral Services")
      if company.present?
        ReconciliationService.create_external_accounts(company)
        ReconciliationService.get_unreconciled_xero_transactions
      end
    end
  end
end
