require_dependency 'hooks'

Redmine::Plugin.register :autowatch do
  name 'AutoWatch plugin'
  author 'University of Trier - Andreas Litt, Matthias Lohr'
  description 'Configure users to become a watcher for all new tickets'
  version '0.1.0'
  url ''
  author_url 'http://www.uni-trier.de/'

  settings(:partial => 'settings/autowatch_settings',
           :default => {
               'role_id' => '6'
           })
end
