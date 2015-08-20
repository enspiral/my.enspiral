module ExternalTransactionsHelper

  def display_if_present(attribute)
    if attribute.present?
      attribute
    else
      'N/A'
    end
  end
end