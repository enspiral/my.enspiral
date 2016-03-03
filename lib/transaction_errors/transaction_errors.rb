module TransactionErrors

  class InsufficientPrivilegesError < StandardError; end

  class SomeoneElsesTransactionError < StandardError; end

  class TooLateToUndoError < StandardError; end

  class InsufficientFundsError < StandardError; end

end