require 'excelinator/xls'
require 'excelinator/rails'
require 'excelinator/version'
require 'spreadsheet'

def old_ruby?
  RUBY_VERSION.to_f < 1.9
end

if old_ruby?
  require 'fastercsv'
else
  require 'csv'
end

if defined?(Rails)
  Excelinator::Rails.setup
  class ActionController::Base
    include Excelinator::Rails::ACMixin
  end
end
