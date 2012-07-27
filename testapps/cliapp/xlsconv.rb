require "rubygems"
require "bundler"
Bundler.require

class XlsConverter
  def convert_csv(csv_filename)
    xls_content = Excelinator.csv_to_xls(csv_filename)
    File.open("sample.csv.xls", 'wb') do |f| f.print xls_content end
    system 'open sample.csv.xls'
  end

  def convert_html(html_filename)
    xls_content = Excelinator.html_as_xls(html_filename)
    File.open("sample.html.xls", 'wb') do |f| f.print xls_content end
    system 'open sample.html.xls'
  end
end

converter = XlsConverter.new
converter.convert_csv(File.read('sample.csv'))
converter.convert_html(File.read('sample.html'))