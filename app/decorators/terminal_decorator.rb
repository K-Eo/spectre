class TerminalDecorator < ApplicationDecorator
  delegate_all

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
    model.pairing_token_png(200).to_data_url
  end
end
