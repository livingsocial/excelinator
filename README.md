Excelinator
===========
Small gem for generating _real_ Excel spreadsheets from existing CSV data and
HTML tables that fully supports UTF-8 characters.

Why?
----
Well, when you're starting up and things are small and then things grow and
then people want reports and they'd like them in Excel most of the time and
then you realize you can just throw some cheap CSV views at them and Excel
will be fine with them and then you get even bigger and you start getting,
like, friggin' _international_ and then the French dudes are like, "My umlauts
look like chewed croissant" and you try prefixing your CSV with a UTF-8 BOM
and that makes some Excels happy (Windows) but not others (Mac) and you think
man I totally want to just, y'know, _eat_ the croissant like it was meant to
be eaten y'know? and there's a zillion spreadsheet gems out there already
except they all like merge back to that one spreadsheet gem, and you could go
XMLDoc maybe, but then it's just like lemme use the CSV I've already got and
try to not make me work much?

No Rails Required
-----------------
The heart of this gem has a couple of small methods to handle the
transformations. If that's all you need, you're good to go.

###CSV

Call `Excelinator.csv_to_xls(csv_content)`. The csv_content will be parsed by
FasterCSV and converted to Excel spreadsheet contents ready to be saved to
file or sent across the wire.

###HTML

Call `Excelinator.html_as_xls(html_content)`. The table element from the HTML
content is extracted, a meta tag indicating utf-8 encoding is prepended and
that's it. The resulting content isn't actually an Excel spreadsheet, just the
HTML data. But write this out to a file with an .xls extension and Excel will
open the contents and translate the `<table>` for you, formatting and all.
	
_NOTE: While some spreadsheet programs (e.g. Google Docs) will not translate
HTML tables like this, both Excel on Windows and Mac will as well as
OpenOffice._

But I Need Rails
----------------
As you wish. As always, [TMTOWTDI](http://en.wikipedia.org/wiki/There's_more_than_one_way_to_do_it),
but here are a few usage options. All examples work in Rails 2 and 3, except
where noted.

If you want to make an explicit xls view that has CSV content in it:

```ruby
class FooController < ApplicationController
  def report
    respond_to do |format|
      format.html
      format.csv
      format.xls { render :xls => 'foo_report.xls' }
    end
  end
end
```

Rails 2 doesn't support custom renderers, but the guts of our :xls renderer
are mixed into the controllers, so you can call it directly this way:

```ruby
      format.xls { send_xls_data 'foo_report.xls' }
```

If you want to re-use an existing HTML view:

```ruby
      format.xls { send_xls_data 'foo_report.xls', :file => 'foo/report.html.erb' }
```
_`:template` also works in place of `:file` in Rails 3. `render :xls =>` also
works in place of `send_xls_data` in Rails 3._

Also note, `send_xls_data` (the guts of `render :xls`) will parse the given
content and detect CSV or HTML, so no need to specify which is being passed in.

You can even go with just an explicit xls view and no controller code, but
you'll need to convert the CSV content yourself inside the view:

```ruby
<%= Excelinator.csv_to_xls(render :file => 'foo/xls_view.csv.erb').html_safe %>
```
_`:template` works in place of `:file` here as well in Rails 3._

Or ... refactor the CSV content to a format-less partial:

```ruby
# _report.erb
<%= generate_csv_report %>

# report.csv.erb
<%= render :partial => 'report' %>

# report.xls.erb
<%= Excelinator.csv_to_xls(render :partial => 'report').html_safe %>
```

There are test apps included in the source repo that exercise these different
options.

FAQ
---

###You lied when you said "_real_ Excel spreadsheets from ... HTML tables." What about converting HTML tables to a _real_ Excel file?

I did, and I apologize. Lemme know when your pull request is ready.

###Are there any options to re-use CSV/HTML views with No additional controller/view code?

I've tinkered with it, but it requires a bit of duck punching of the Rails
rendering code.

###What if I want to generate a real Excel spreadsheet from scratch with all sorts of awesome in it?

This gem uses `spreadsheet` under the covers. There are also others that
support a wide variety of Excel features:

- http://spreadsheet.rubyforge.org/
- http://surpass.ananelson.com/ 
- https://github.com/randym/axlsx

With any of these, you can create specific .xls views and have them use the
classes in these gems that let you define a Workbook with multiple Worksheets
with rows and columns of formatted formulas.

For support higher up the ladder within Rails and/or ActiveRecord, here are a
few options I've found, though I can't vouch for any. Search rubygems and
github for 'spreadsheet' 'excel' and 'xls' and you'll find lots of additional
projects. Most appear to use either the above Spreadsheet gem or generate
XMLDoc.

- https://github.com/glebm/to_spreadsheet 
- https://github.com/splendeo/to_xls 
- https://github.com/asanghi/excel_rails 
- https://github.com/hallelujah/rails-excel
- https://github.com/liangwenke/to_xls-rails

###Some of the links in the test Rails apps don't work

They're not all supposed to work. Think of it more as a workshop for example
code.
