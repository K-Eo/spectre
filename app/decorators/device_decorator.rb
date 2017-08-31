class DeviceDecorator < ApplicationDecorator
  delegate_all

  def associated_at
    "Associated #{h.timeago_for(model)}".html_safe
  end

  def owner
    handle_present(model.owner)
  end

  def phone
    handle_present(model.phone)
  end

  def imei
    handle_present(model.imei)
  end

  def os
    handle_present(model.os)
  end

  def modelify
    handle_present(object.model)
  end

  def delete_link(terminal)
    h.link_to 'Delete',
            h.pair_device_terminal_path(terminal),
            class: 'btn btn-danger',
            method: :delete,
            data: { confirm: 'Are you sure?' }
  end
end
