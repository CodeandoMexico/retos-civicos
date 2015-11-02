module DashboardHelper
  def dashboard_links
    [{
      active_class: 'dashboard',
      name: 'Dashboard',
      path: dashboard_path
    },

    {
      active_class: 'dashboard/challenges',
      name: 'Retos',
      path: dashboard_challenges_path
    },

    {
      active_class: 'dashboard/entries',
      name: 'Propuestas',
      path: dashboard_entries_path
    },

    {
      active_class: 'dashboard/collaborators',
      name: 'Participantes',
      path: dashboard_collaborators_path
    },

    {
      active_class: 'dashboard/judges',
      name: 'Jurado',
      path: dashboard_judges_path
    },

    {
      active_class: 'dashboard/report_cards',
      name: 'Resultados',
      path: dashboard_report_cards_path
    }]
  end

  def admin_links
    [
      { name: 'Perfil', path: edit_organization_path(organization) },
      { name: 'Cerrar sesión', path: destroy_user_session_path, method: :delete }
    ]
  end
end
