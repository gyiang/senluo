require 'open-uri'
require 'json'
require 'sequel'

token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"
target_repo1="nostra13/Android-Universal-Image-Loader"
target_repo2="JakeWharton/ActionBarSherlock"
api_repos="https://api.github.com/repos"
args="?state=all&#{token}&per_page=100&page="
target_url_repo="#{api_repos}/#{target_repo2}#{token}"


DB = Sequel.connect('mysql2://root:@127.0.0.1:3306/github?characterEncoding=UTF-8')

options={}
DB.create_table?(:repo_issues_abs,:charset => 'utf8') do
#DB.create_table?(:repo_issues_auil,:charset => 'utf8') do
    String :url
    String :labels_url
    String :comments_url
    String :events_url
    String :html_url
    Integer :id
    Integer :number
    String :title
    Text :user
    String :labels
    String :state
    String :locked
    String :assignee
    String :milestone
    Integer :comments
    String :created_at
    String :updated_at
    String :closed_at
    Text :pull_request
    Text :body
end


items = DB[:repo_issues_abs]
#items = DB[:repo_issues_auil]
page_num=0
while true
  target_url_issue="#{api_repos}/#{target_repo2}/issues#{args}#{page_num+=1}"
  p page_num
  data=open(target_url_issue).read
  if data=="[]" then
    break
  end
  JSON.parse(data).each do |item|
    if !item['labels'].empty? then
      l=Array.new
      p item
      item['labels'].each do |label|
        l.push(label['name'])
      end
      item['labels']=l.to_s
    end
    item['user']=item['user'].to_s
    if !item['pull_request'].nil?
      item['pull_request']=item['pull_request'].to_s
    end
    item['milestone']=item['milestone'].to_s
    item['assignee']=item['assignee'].to_s
    items.insert(item)
  end
end
