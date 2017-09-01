class TerminalDecorator < ApplicationDecorator
  delegate :id

  def name
    handle_present(model.name)
  end

  def icon(options = {})
    if model.paired?
      h.octicon 'device-mobile', options
    else
      h.octicon 'info', options
    end
  end

  def created_at
    "##{model.id} • created #{h.timeago_for(model)}".html_safe
  end

  def edit_link
    h.link_to 'Edit', h.edit_terminal_path(model), class: 'btn btn-success mr-2'
  end

  def delete_link
    h.link_to 'Delete',
              h.terminal_path(model),
              class: 'btn btn-danger',
              method: :delete,
              data: { confirm: 'Are you sure?' }
  end

  def qr_image
    if model.pairing_token.present?
      data_url = model.pairing_token_png(200).to_data_url
      h.content_tag :img, '', src: data_url, title: 'QR Image'
    else
      h.content_tag :span, 'Can\'t cook QR Image'
    end
  end
end
