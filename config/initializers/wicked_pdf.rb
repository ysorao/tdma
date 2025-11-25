#WickedPdf.config = {
    #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf',
    #:layout => "pdf.html",
    #:exe_path => '/home/rails/telederma/current/vendor/bundle/ruby/2.3.0/bin/wkhtmltopdf'
    #exe_path: '/usr/local/bin/wkhtmltopdf'
#}

WickedPdf.config ||= {}
WickedPdf.config.merge!(
  exe_path: ENV.fetch("WKHTMLTOPDF_PATH", "/home/rails/.rvm/gems/ruby-2.5.0/bin/wkhtmltopdf")
)