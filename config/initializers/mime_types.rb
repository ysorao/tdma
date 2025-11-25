# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
Mime::Type.register "application/pdf", :pdf
Mime::Type.register "audio/mp4", :mp4
MIME::Types.add(
  MIME::Type.new('application/icml').tap do |type|
    type.add_extensions 'icml'
  end
)
