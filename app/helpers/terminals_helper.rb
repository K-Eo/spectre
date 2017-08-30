module TerminalsHelper

  def tab_item(name = '', url = '')
    content_tag :li, class: 'nav-item' do
      active_link(name, url)
    end
  end

private

  def active_link(name, url)
    css = 'nav-link'
    css << ' active' if url.include?(controller_name)
    link_to name, url, class: css
  end

end
