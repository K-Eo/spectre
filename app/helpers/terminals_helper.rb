module TerminalsHelper

  def tab_item(name, url)
    content_tag :li, class: 'nav-item' do
      klass = 'nav-link'
      klass << ' active' if url.include?(controller_name)
      concat link_to name, url, class: klass
    end
  end

end
