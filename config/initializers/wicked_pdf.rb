WickedPdf.config ||= {}
WickedPdf.config.merge!(
  exe_path: ENV.fetch("WKHTMLTOPDF_PATH", "/home/rails/.rvm/gems/ruby-3.4.1/bin/wkhtmltopdf")
)
