require 'excelinator/xls'
require 'excelinator/rails'
require 'excelinator/version'
require 'spreadsheet'
require 'fastercsv'

if defined?(Rails)
  Excelinator::Rails.setup
  class ActionController::Base
    include Excelinator::Rails::ACMixin
  end
end
