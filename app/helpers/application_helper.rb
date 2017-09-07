module ApplicationHelper

  def gravatar(object, args = {})
    options = Hash.new

    options[:d] = args[:d] || 'retro'
    options[:s] = args[:s] || 80

    image_class = args[:class] || ''

    hash = Digest::MD5.hexdigest(object.email)

    image_tag "https://www.gravatar.com/avatar/#{hash}?#{options.to_query}",
              class: image_class,
              width: options[:s],
              height: options[:s]
  end

  def tab_item(name = '', **options)
    url = options.fetch(:url, '')
    controller = options.fetch(:controller, '')
    icon = options.fetch(:icon, '')

    active_class = active_link(url, controller)

    css = ['nav-link',
           'd-flex',
           'align-items-center',
           active_class].compact.join(' ')

    content_tag :li, class: 'nav-item' do
      link_to url, class: css do
        concat octicon icon, class: 'mr-1' if icon.present?
        concat name
      end
    end
  end

  def flash_message(col = nil)
    html = ""
    flash.each do |key, value|
      html << build_alert(value, key, col)
    end
    html.html_safe
  end

  def timeago_for(object)
    if object.nil? || !object.created_at.present?
      return content_tag :span, ''
    end

    content_tag :span, '',
                class: 'timeago',
                datetime: object.created_at,
                title: object.created_at
  end

private

  def active_link(url, controller)
    url = controller if controller.present?

    if url.include?(controller_name)
      'active'
    else
      ''
    end
  end

  def build_alert(content, type, col)
    content = alert_content_wrapper(col) do
      <<~HTML
        <button class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        #{content}
      HTML
    end

    <<~HTML
      <div class="flash-message alert alert-#{flash_type(type)} alert-dismissable fade show my-0" role="alert">
        <div class="container">
          #{content}
        </div>
      </div>
    HTML
  end

  def alert_content_wrapper(col)
    if col.nil?
      yield
    else
      html = <<~HTML
        <div class="row justify-content-center">
          <div class="#{col}">
            #{yield}
          </div>
        </div>
      HTML
    end
  end

  def flash_type(type)
    case type
    when :alert, 'alert'
      return 'danger'
    when :notice, 'notice'
      return 'success'
    else
      return type
    end
  end
end
