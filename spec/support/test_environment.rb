# encoding: utf-8
require 'rspec_tag_matchers'
require 'active_support/core_ext/class/inheritable_attributes'

RSpec.configure do |config|
  config.include RspecTagMatchers
  config.include CustomMacros
  config.mock_with :rspec
end

if Formtastic::Util.rails3?

  require "action_controller/railtie"
  require "active_resource/railtie"
  require 'active_model'

  # Create a simple rails application for use in testing the viewhelper
  module FormtasticTest
    class Application < Rails::Application
      # Configure the default encoding used in templates for Ruby 1.9.
      config.encoding = "utf-8"
      config.active_support.deprecation = :stderr
    end
  end
  FormtasticTest::Application.initialize!

  require 'rspec/rails'
end




