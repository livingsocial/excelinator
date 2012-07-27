module Excelinator
  module Rails
    def self.setup
      require 'action_controller'

      Mime::Type.register Excelinator::MIME_TYPE, :xls

      self.add_renderer if ::Rails::VERSION::MAJOR >= 3
    end

    def self.add_renderer
      ActionController::Renderers.add :xls do |filename, options|
        send_xls_data(filename, options)
      end
    end

    module ACMixin
      def send_xls_data(filename, options={})
        content = render_to_string(options)
        xls_content = Excelinator.convert_content(content)
        send_data(xls_content, :filename => filename, :type => Excelinator::MIME_TYPE, :disposition => 'inline')
      end
    end
  end
end