#custom modifications

require File.expand_path(File.dirname(__FILE__) + '/../../spec/blueprints.rb')

#invoice -> Invoice, invoice allocations -> InvoiceAllocation
def str_to_class_name string
  parts = string.split(' ')
  str = ""
  parts.each do |part|
    str += part.singularize.capitalize
  end
  str
end

#Invoices -> invoice, invoice allocations -> invoice_allocations
def str_to_css_names string
  parts = string.split(' ')
  str = ""
  parts.each do |part|
    str += "_" unless str.empty?
    str += part.singularize.downcase
  end
  [str, str.pluralize]
end
