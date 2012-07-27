require File.dirname(__FILE__) + '/spec_helper'
require 'benchmark'

describe Excelinator do
  let(:table) {
    table = <<-HTML
        <table>
          <tr>
            <td></td>
          </tr>
        </table>
    HTML
    table.strip
  }
  let(:utf8) { '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' }
  let(:one_two_three_xls) { one_two_three_xls = "\320\317\021\340\241\261\032\341" }

  it "should strip out table" do
    Excelinator.html_as_xls("<body>#{table}</body>").should == utf8 + table
  end

  it "should strip out multiple tables" do
    # TODO: this will grab any html in between tables - should be smarter about that
    Excelinator.html_as_xls("<body>#{table}<hr/>#{table}</body>").should == utf8 + "#{table}<hr/>#{table}"
  end

  it "should allow option to not strip out table since this will be an expensive memory operation for a huge HTML file" do
    Excelinator.html_as_xls("<body>#{table}</body>", :do_not_strip => true).should == utf8 + "<body>#{table}</body>"
  end

  it "should detect table and convert as html" do
    Excelinator.convert_content("<body>#{table}</body>").should == utf8 + table
  end

  it "should not detect table and convert CSV" do
    # mini-gold standard test: pre-calculated the Excel header bytes and merely that part to match
    Excelinator.convert_content([1, 2, 3].to_a.join(','))[0..7].should == one_two_three_xls
  end

  it "should not take a very long time to detect CSV content" do
    # this test verifies a quick HTML regex. Previously, the 'strip table' regex was used and that's too expensive
    # for detection in the case of large HTML content (at least double, though progressively worse as size increased)
    #
    # it's a risky test, as this can easily fail in other environments than it was written in. so, judge for yourself
    # whether or not it's worth it.
    large_html = table * 200_000
    Benchmark.realtime { Excelinator.convert_content(large_html) }.should < 0.5
  end
end
