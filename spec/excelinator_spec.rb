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
  let(:one_two_three_xls) { one_two_three_xls = "\xD0\xCF\x11\xE0\xA1\xB1\x1A\xE1" }

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
    # due to string encoding issues beyond my comprehension, ruby1.9 makes a bad guess on the header, this fixes it
    compare_string = ruby19? ? one_two_three_xls.force_encoding('US-ASCII') : one_two_three_xls

    # mini-gold standard test: pre-calculated the Excel header bytes and merely that part to match
    Excelinator.convert_content([1, 2, 3].join(','))[0..7].should == compare_string
  end

  it "should not take a very long time to detect CSV content" do
    # this test verifies a quick HTML regex. Previously, the 'strip table' regex was used and that's too expensive
    # for detection in the case of large HTML content (at least double, though progressively worse as size increased)
    #
    # it's a risky test, as this can easily fail in other environments than it was written in. so, judge for yourself
    # whether or not it's worth it.
    large_html = table * 200_000
    Benchmark.realtime { Excelinator.convert_content(large_html) }.should < 1.0 # 0.5 was too fast for me, always failed
  end
end
