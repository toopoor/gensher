window.CashWithdrawalForm = (($, w, undefined_) ->
  changePay = (pay) ->
    $('#cash_withdrawal_form').find('#payment_payer_id').val pay
    $('#cash_withdrawal_form').find('.pay-system').removeClass 'active'
    $('#cash_withdrawal_form').find('.pay-system.'+pay).addClass 'active'

  change: (pay) ->
    changePay pay
)(jQuery, window)
