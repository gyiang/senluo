require 'open-uri'
require 'json'
require 'sequel'

token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"
target_repo1="nostra13/Android-Universal-Image-Loader"
target_repo2="JakeWharton/ActionBarSherlock"
api_repos="https://api.github.com/repos"
args="?state=all&#{token}&per_page=100&page="
target_url_repo="#{api_repos}/#{target_repo2}#{token}"


DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/github?characterEncoding=UTF-8')

options={}
DB.create_table?(:repo_pr_abs,:charset => 'utf8') do
#DB.create_table?(:repo_pr_auil,:charset => 'utf8') do
    String :url
    Integer :id
    String :html_url
    String :diff_url
    String :patch_url
    String :issue_url
    Integer :number
    String :state
    Boolean :locked
    String :title
    Text :user
    Text :body
    String :created_at
    String :updated_at
    String :closed_at
    String :merged_at
    String :merge_commit_sha
    String :assignee
    String :milestone
    String :commits_url
    String :review_comments_url
    String :review_comment_url
    String :comments_url
    String :statuses_url
    Text :head
    Text :base
    Text :_links
end


items = DB[:repo_pr_abs]
#items = DB[:repo_pr_auil]
page_num=0
while true
  target_url_issue="#{api_repos}/#{target_repo2}/pulls#{args}#{page_num+=1}"
  p page_num
  data=open(target_url_issue).read
  if data=="[]" then
    break
  end
  JSON.parse(data).each do |item|
    item['head']=item['head'].to_s
    item['base']=item['base'].to_s
    item['_links']=item['_links'] .to_s
    item['user']=item['user'].to_s
    items.insert(item)
  end
end
