class XeroImportLog < ActiveRecord::Base

  serialize :invoices_with_errors, Hash

  belongs_to :company
  belongs_to :person

  def author_name
    return "system" if person.nil?
    person.name
  end

end