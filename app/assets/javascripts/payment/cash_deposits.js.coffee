window.CashDepositForm = (($, w, undefined_) ->
  changePay = (pay) ->
    $('#cash_deposit_form').find('#payment_payer_id').val pay
    $('#cash_deposit_form').find('.pay-system').removeClass 'active'
    $('#cash_deposit_form').find('.pay-system.'+pay).addClass 'active'

  change: (pay) ->
    changePay pay
)(jQuery, window)
