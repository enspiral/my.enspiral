module XeroErrors

  class UnrecognisedInvoiceReferenceFormat < StandardError; end

  class AmbiguousInvoiceError < StandardError; end

  class InvalidXeroInvoiceStatusError < StandardError; end

  class InvalidCustomerError < StandardError; end

  class InvoiceAlreadyExistsError < StandardError
    attr_accessor :enspiral_invoice, :xero_invoice

    def initialize(message, enspiral_inv, xero_inv)
      super(message)
      self.enspiral_invoice = enspiral_inv
      self.xero_invoice = xero_inv
    end

  end

  class CannotFindEnspiralInvoiceError < StandardError; end

  class EnspiralInvoiceAlreadyPaidError < StandardError; end

  class NoInvoiceCreatedError < StandardError

    attr_accessor :enspiral_invoice, :xero_invoice, :overwrite, :other_error

    def initialize(message, enspiral_inv, xero_inv, overw, error=nil)
      super(message)
      self.enspiral_invoice = enspiral_inv
      self.xero_invoice = xero_inv
      self.overwrite = overw
      self.other_error = error
    end

  end

end