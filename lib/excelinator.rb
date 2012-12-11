require 'excelinator/xls'
require 'excelinator/rails'
require 'excelinator/version'
require 'spreadsheet'

def ruby19?
  RUBY_VERSION =~ /1.9/
end

if ruby19?
  require 'csv'
else
  require 'fastercsv'
end

if defined?(Rails)
  Excelinator::Rails.setup
  class ActionController::Base
    include Excelinator::Rails::ACMixin
  end
end
