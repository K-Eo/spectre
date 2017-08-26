module ApplicationHelper

  def flash_message
    html = ""
    flash.each do |key, value|
      type = flash_type(key)
      html += <<-HTML
        <div class="alert alert-#{type} alert-dismissable fade show my-0" role="alert">
          <div class="container">
            <button class="close" data-dismiss="alert" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            #{value}
          </div>
        </div>
      HTML
    end

    html.html_safe
  end

private

  def flash_type(type)
    case type
    when 'alert'
      'danger'
    when 'notice'
      'success'
    else
      type
    end
  end
end
