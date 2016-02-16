module Services
  module Loggers
    class ImportLogger

      def self.import_logger
        @@import_logger ||= Logger.new("#{Rails.root}/log/xero_import.log", 10, 100.megabytes)
      end

    end
  end
end