module Permissions::MonitorsHelper
  def toggle_monitor_permission(user)
    method = user.monitor? ? "DELETE" : "PATCH"
    css = "btn btn-sm "
    css << (user.monitor? ? "btn-success" : "btn-secondary")

    link_to "Monitor",
            user_permissions_monitor_path(user),
            id: "toggle_monitor_permission_#{user.id}",
            class: css,
            method: method,
            remote: true,
            data: { 'disable-with': "Guardando..." }
  end
end
