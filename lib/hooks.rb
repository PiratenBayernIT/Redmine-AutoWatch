class Hooks < Redmine::Hook::ViewListener
  def view_projects_form(context={} )
    return content_tag("p", "Custom content added to the left")
  end
end