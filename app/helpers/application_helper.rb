module ApplicationHelper

  def flash_message(col = nil)
    html = ""
    flash.each do |key, value|
      type = flash_type(key)
      html += <<~HTML
        <div class="flash-message alert alert-#{type} alert-dismissable fade show my-0" role="alert">
          <div class="container">
            #{build_flash_content(value, col)}
          </div>
        </div>
      HTML
    end

    html.html_safe
  end

private

  def build_flash_content(value, col)
    content = ""

    if !col.nil?
      content += <<~HTML
        <div class="row justify-content-center">
          <div class="#{col}">
      HTML
    end

    content += <<~HTML
      <button class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      #{value}
    HTML

    if !col.nil?
      content += <<~HTML
          </div>
        </div>
      HTML
    end

    content
  end

  def flash_type(type)
    case type
    when :alert
      return 'danger'
    when :notice
      return 'success'
    else
      return type
    end
  end
end
