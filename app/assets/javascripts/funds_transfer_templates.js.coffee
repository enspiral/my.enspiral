$('#funds_transfer_template_lines').bind 'insertion-callback', (e) ->
  $('form .czn-select').chosen()

  # copy source account, destination account and amount values into the new row.
  $rows = $('#funds_transfer_template_lines .nested-fields .control-group')
  $last_row = $($rows[$rows.length - 2])
  $new_row = $($rows[$rows.length - 1])
  
  _.each ['source-account', 'destination-account'], (account) ->
    id = $last_row.find("select.fttl-#{account} > option:selected").attr('value')
    $new_row.find("select.fttl-#{account} > option[value=#{id}]").attr('selected', 'selected')
    $new_row.find('select').trigger('liszt:updated')

  amount = $last_row.find('input.fttl-amount').attr('value')
  $new_row.find('input.fttl-amount').attr('value', amount)


$('#pending_allocations').on('cocoon:after-insert', (e, new_item) ->
  $('.czn-select').chosen()
)
