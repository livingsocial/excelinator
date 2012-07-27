class FooController < ApplicationController
  def index
    redirect_to :action => :empty
  end

  def empty
    # idea here is to have only a default html view and see if it could be re-used without any controller code.
    # - not currently.
  end

  def xls_view
    # no controller code here, but a view per format supported. this is working.
    # - arabic only in xls, mixed in csv.
  end

  def xls_view_respond_to
    respond_to do |format|
      format.xls { send_xls_data 'xls_view_respond_to.xls' }
    end
  end

  def respond_to_html_only
    respond_to do |format|
      format.html
      # other requested formats will return a 406
    end
  end

  def respond_to_all
    # here's how to re-use a CSV view
    respond_to do |format|
      format.html
      format.csv { render :partial => 'all.erb' }
      format.xls {
        partial = params[:render_from] == 'html' ? 'all.html.erb' : 'all.erb'
        send_xls_data('respond_to_all.xls', :partial => partial, :locals => {:arabic_only => true})
      }
    end
  end
end
