require 'dry-configurable'

require_relative 'colppy/version'
require_relative 'colppy/client'

class Colppy
  include Version
  extend Dry::Configurable

  setting :user_email
  setting :user_password
  setting :dev_user_email
  setting :dev_user_password
  setting :company_id

  setting :service_url
  setting :log, false
  setting :logger, Logger.new(STDOUT)

  def self.log(level, message)
    return unless Colppy.config.log
    Colppy.config.logger.send(level, message)
  end
end
