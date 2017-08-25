# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /<(input|textarea|select)/
    html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    html_field.children.add_class 'is-invalid'
    input_name = html_field.children.first[:id].split('_').last
    errors = instance.object.errors[input_name].join('<br>')
    html_field.children.first.add_next_sibling "<div class=\"invalid-feedback\">#{errors}</div>"
    html_field.to_s.html_safe
  else
    html_tag.html_safe
  end
end
