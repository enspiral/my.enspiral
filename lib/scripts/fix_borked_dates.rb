
module Scripts

  class CheckForBorkedDates

    # this script is to fix a couple of type-1 errors in my.enspiral funds transfer recording, particularly around time zones.
    # As of this writing, the FundsTransfer "date" field was time zone agnostic. It was recorded in system time (using Date.today)
    # but because the Date data type is time zone agnostic, the actual date was recorded in the DB as UTC.

    # This becomes a problem when displaying the date of a transfer. For some reason, the table in /app/views/funds_trasfers/_table.html.haml
    # takes the UTC created_at value and displays that in local time (again, NZ time) so we would get the following:

    # ID: 18642
    # Date: 2016-12-01
    # created_at: Mon, 30 Nov 2015 21:11:51 UTC +00:00

    # The logic to display this does the following:
    # localize(ft.created_at)
    # which gives 30 Nov, which is a day behind!
    # and the filter mechanism was using the "Date" field, which really just confuses things.

    # > I18n.localize(ft.created_at)
    # => "Monday  9:11 PM, 30 November 2015"
    # > I18n.localize(ft.date)
    # => "Tuesday 1 December 2015"

    # - charlie, 14 Feb 2016 (20:55, +13:00) :P

    def check_for_strange_dates
      FundsTransfer.all.each do |transfer|

        # the 'date' can either be the same date, or the day before. I'll assume the date is in UTC.
        transfer.date # this is NZT date of the accounts
        transfer.created_at # this is good, this is what we want. In UTC

        # find the NZT equivalent of created_at
        created_at_in_wgtn_time = transfer.created_at.in_time_zone("Wellington")
        next if transfer.date == created_at_in_wgtn_time.to_date
        # log it if it's different than date.
        log "Transfer #{transfer.id} Date: #{transfer.date} (Wgtn) created_at (UTC): #{transfer.created_at} Wgtn: #{created_at_in_wgtn_time}}"
      end
    end

    def log(message)
     ::Scripts::ImportLogger.import_logger.info(message)
    end
  end

  class ImportLogger

    def self.import_logger
      @@import_logger ||= Logger.new("#{Rails.root}/log/strange_dates.log")
    end

  end

end