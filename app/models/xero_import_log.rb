class XeroImportLog < ActiveRecord::Base

  belongs_to :company
  belongs_to :person

  def author_name
    return "system" if person.nil?
    person.name
  end

end