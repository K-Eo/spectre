module ApplicationHelper
  def form_feedback_icon(icon = "check", badge = "success")
    content_tag :span,
                class: "badge badge-pill badge-#{badge} ml-3 align-middle",
                id: "form_feedback_icon" do
      octicon icon, height: 18
    end
  end

  def sidebar_link(options = {})
    options.symbolize_keys

    url         = options.delete(:url)
    icon        = options.delete(:icon)
    name        = options.delete(:name)
    controller  = options.fetch(:controller, "")
    method      = options.delete(:method)

    active_target = if controller.present? then controller else url end

    class_name = "nav-link text-light d-flex align-items-center"
    class_name << " active" if active_target.include?(controller_name)

    link_to url, class: class_name, method: method do
      concat octicon(icon, class: "mr-3", height: 15)
      concat content_tag(:span, name)
    end
  end

  def gravatar(object, args = {})
    options = {
      d: args.fetch(:d, "retro"),
      s: args.fetch(:height, "80")
    }

    args.delete(:d)

    hash = Digest::MD5.hexdigest(object.email)
    image_tag "https://www.gravatar.com/avatar/#{hash}?#{options.to_query}", args
  end

  def flash_message(options = {})
    html = ""
    flash.each do |key, value|
      html << build_alert(value, key, options)
    end
    html.html_safe
  end

  def timeago_for(object)
    if object.nil? || !object.created_at.present?
      return content_tag :span, ""
    end

    content_tag :span, "",
                class: "timeago",
                datetime: object.created_at,
                title: object.created_at
  end

private

  def build_alert(content, type, options)
    options.symbolize_keys

    col = options.fetch(:col, "col-12")
    container = options.fetch(:container, "container-fluid")

    <<~HTML
      <div class="flash-message alert alert-#{flash_type(type)} alert-dismissable fade show my-0 px-0" role="alert">
        <div class="#{container}">
          <div class="row justify-content-center">
            <div class="#{col}">
              <button class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
              #{content}
            </div>
          </div>
        </div>
      </div>
    HTML
  end

  def flash_type(type)
    case type
    when :alert, "alert"
      return "danger"
    when :notice, "notice"
      return "success"
    else
      return type
    end
  end
end
