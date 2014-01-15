# Copyright (c) 2013 University of Trier - ZIMK - Andreas Litt, Matthias Lohr
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module AutoWatch
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_before_save(context={} )
      dest_role = Setting.plugin_autowatch['role_id'].to_i
      tracker_ids = Setting.plugin_autowatch['tracker_ids']
      #Rails.logger.debug("tracker_ids '#{tracker_ids}'")
      issue = context[:issue]
      project = Project.find(issue.project_id) # Get Project
      project.members.each do |member| # Get all members from Project and loop through them
        member.roles.each do |role|
          tracker_ids.each do |tracker_id|
            if role.id == dest_role and issue.tracker_id == tracker_id.to_i
              # Member is in autowatch role and ticket has the selected tracker
              user = member.user
              if !(issue.watched_by? user)
                Rails.logger.debug("autowatch: adding watcher #{user.login} for issue '#{issue.subject}'")
                issue.add_watcher(user)
              end
            end
          end
        end
      end
    end
  end
end
