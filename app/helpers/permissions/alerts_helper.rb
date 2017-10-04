module Permissions::AlertsHelper
  def toggle_alert_permission(user)
    method = user.create_alert? ? "DELETE" : "PATCH"
    css = "btn btn-sm "
    css << (user.create_alert? ? "btn-success" : "btn-secondary")

    link_to "Alertas",
            user_permissions_alert_path(user),
            id: "toggle_alert_permission_#{user.id}",
            class: css,
            method: method,
            remote: true,
            data: { 'disable-with': "Guardando..." }
  end
end
