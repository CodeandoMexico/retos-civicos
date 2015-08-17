module MemberHelper
  def panel_links
    [
      {
        active_class: 'panel/entries',
        name: 'Propuestas',
        path: panel_entries_path
      }
    ]
  end

  def member_user_links
    [
      { name: 'Retos', path: challenges_path },
      { name: 'Perfil', path: edit_member_path(current_user.userable) },
      { name: 'Cerrar sesión', path: destroy_user_session_path, method: :delete }
    ]
  end
end
