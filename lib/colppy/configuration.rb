# frozen_string_literal: true

require 'dry-configurable'
require 'logger'

module Colppy
  class Configuration
    extend Dry::Configurable

    setting :user_email
    setting :user_password
    setting :dev_user_email
    setting :dev_user_password
    setting :company_id

    setting :service_url
    setting :log, default: false
    setting :logger, default: Logger.new(STDOUT)
  end
end
