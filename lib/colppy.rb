# frozen_string_literal: true

require 'colppy/version'
require 'colppy/configuration'
require 'colppy/client'

module Colppy
  class << self
    def log(level, message)
      return unless Colppy::Configuration.config.log
      Colppy::Configuration.config.logger.send(level, message)
    end
  end
end
