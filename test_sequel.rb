require 'open-uri'
require 'json'
require 'sequel'

#DB = Sequel.connect(:adapter => 'mysql2', :user => 'root', :password => "", :host => "127.0.0.1" , :database => "github")
#DB = Sequel.sqlite # memory database, requires sqlite3
DB = Sequel.connect('mysql2://root:@127.0.0.1:3306/github')


#DB.drop_table :repo_info

=begin
DB.create_table? :repo_info do
  String :id
  String :name
  String :full_name
  Text :owner
  Boolean :private
  String :html_url
  String :description
  String :fork
  String :url
  String :forks_url
  String :keys_url
  String :collaborators_url
  String :teams_url
  String :hooks_url
  String :issue_events_url
  String :events_url
  String :assignees_url
  String :branches_url
  String :tags_url
  String :blobs_url
  String :git_tags_url
  String :git_refs_url
  String :trees_url
  String :statuses_url
  String :languages_url
  String :stargazers_url
  String :contributors_url
  String :subscribers_url
  String :subscription_url
  String :commits_url
  String :git_commits_url
  String :comments_url
  String :issue_comment_url
  String :contents_url
  String :compare_url
  String :merges_url
  String :archive_url
  String :downloads_url
  String :issues_url
  String :pulls_url
  String :milestones_url
  String :notifications_url
  String :labels_url
  String :releases_url
  String :created_at
  String :updated_at
  String :pushed_at
  String :git_url
  String :ssh_url
  String :clone_url
  String :svn_url
  String :homepage
  Integer :size
  Integer :stargazers_count
  Integer :watchers_count
  String :language
  Boolean :has_issues
  Boolean :has_downloads
  Boolean :has_wiki
  Boolean :has_pages
  Integer :forks_count
  String :mirror_url
  Integer :open_issues_count
  Integer :forks
  Integer :open_issues
  Integer :watchers
  String :default_branch
  String :permissions
  Integer :network_count
  Integer :subscribers_count
end
=end


#items = DB[:repo_info] # Create a dataset


token="&access_token=877738b0ede13b627605e301dd4f00725697ca0d"
target_repo1="nostra13/Android-Universal-Image-Loader"
target_repo2="JakeWharton/ActionBarSherlock"
api_repos="https://api.github.com/repos"
args="?stare=all&#{token}&per_page=100&page="
target_url_repo="#{api_repos}/#{target_repo2}#{token}"
page_num=2

target_url_issue="#{api_repos}/#{target_repo1}/issues#{args}#{page_num}#{token}"

p target_url_issue
data = open(target_url_issue).read
info=JSON.parse(data)
info[97]['labels'][0]['name']


p info
#items.insert(info)


# Print out the number of records
#puts "Item count: #{items.count}"
