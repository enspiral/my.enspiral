class Report < ActiveRecord::Base
	def self.to_csv(reports)
		csv = "Account,Amount\n"
		total = 0
		reports.each do |key, value|
			total = total + value 
			csv +="#{key},#{value}\n"
		end
		csv +="Total,#{total}"
		csv
	end
  
end