module XeroErrors

  class UnrecognisedInvoiceReferenceFormat < StandardError; end

  class InvoiceAlreadyExistsError < StandardError
    attr_accessor :enspiral_invoice, :xero_invoice

    def initialize(message, enspiral_inv, xero_inv)
      super(message)
      self.enspiral_invoice = enspiral_inv
      self.xero_invoice = xero_inv
    end

  end

  class EnspiralInvoiceAlreadyPaidError < StandardError; end

  class NoInvoiceCreatedError < StandardError

    attr_accessor :enspiral_invoice_id, :xero_invoice_id

    def initialize(message, enspiral_inv, xero_inv, overw)
      super(message)
      self.enspiral_invoice_id = enspiral_inv
      self.xero_invoice_id = xero_inv
      self.overwrite = overw
    end

  end

end