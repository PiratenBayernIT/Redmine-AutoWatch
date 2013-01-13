class Hooks < Redmine::Hook::ViewListener
  def controller_issues_new_before_save(context={} )
    dest_role = Setting.plugin_autowatch['role_id'].to_i
    issue = context[:issue]
    project = Project.find(issue.project_id) # Get Project
    project.members.each do |member| # Get all members from Project and loop through them
      member.roles.each do |role|
        if role.id == dest_role
          # Member is in autowatch role
          user = member.user
          if !(issue.watched_by? user)
            issue.add_watcher(user)
          end
        end
      end
    end
  end
end