Rails.application.assets.context_class.instance_eval do
  include AssetsHelper
end
Rails.application.config.assets.precompile += %w(ckeditor/*)
Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
Rails.application.config.assets.precompile += %w(inspinia.css
                                                 application_inspinia.js
                                                 home.js home.css
                                                 instruments.js
                                                 companies.js companies.css
                                                 messages.js messages.css
                                                 activation_requests.js
                                                 purse_payment/activations.js
                                                 purse_payment/vouchers.js
                                                 payment/cash_deposits.js
                                                 payment/cash_withdrawals.js
                                                 users.js users.css
                                                 users/registrations.js
                                                 users/registrations.css
                                                 payments.js
                                                 purse_payments.js
                                                 voucher_requests.js)
Rails.application.config.assets.precompile += %w(one.css
                                                 one/modernizr.js one.js)