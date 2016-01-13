

require 'open-uri'
require 'json'
require 'sequel'

token="?access_token=877738b0ede13b627605e301dd4f00725697ca0d"
state="all"
target_repo1="nostra13/Android-Universal-Image-Loader"
target_repo2="JakeWharton/ActionBarSherlock"

api_repos="https://api.github.com/repos"
api_pulls="#{api_repos}/pulls"
api_issue="#{api_repos}/issue"
args="?stare=all&#{token}&per_page=100&page="

target_url="#{api_repos}/#{target_repo1}#{token}"
p target_url


data = open(target_url).read
info=JSON.parse(data)
p info







=begin
require 'mechanize'
agent=Mechanize.new
agent.user_agent_alias ='Windows Edge'
page=agent.get(target_url)
=end




