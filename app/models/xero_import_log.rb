class XeroImportLog < ActiveRecord::Base

  serialize :invoices_with_errors, Hash
  serialize :successful_invoices, Array

  paginates_per 20

  belongs_to :company
  belongs_to :person

  validates_presence_of :company

  def author_name
    return "system" if person.nil?
    person.name
  end

  def load_successful_invoices(all_invoices)
    invoices = []
    return unless successful_invoices.respond_to?(:each)

    successful_invoices.each do |invoice_id|
      matching_invoices = all_invoices.select{|i| i.id == invoice_id.to_i}
      if matching_invoices.any?
        invoices << matching_invoices.first
      end
    end
    invoices
  end

end