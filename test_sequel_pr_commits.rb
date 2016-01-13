require 'open-uri'
require 'json'
require 'sequel'
token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"

DB = Sequel.connect('mysql2://root:@127.0.0.1:3306/github?characterEncoding=UTF-8')

dDB.create_table?(:repo_pr_commits_abs,:charset => 'utf8') do
#DB.create_table?(:repo_pr_commits_auil,:charset => 'utf8') do
  Integer :pull_id
  String :sha
  Text :commit
  String :url
  String :html_url
  String :comments_ur
  Text :author
  Text :committer
  String :message
  Text :parents
end
items=DB[:repo_pr_commits_abs]

DB[:repo_pr_abs].select(:commits_url).each do |row|
  p row.fetch(:commits_url)
  JSON.parse(open(row.fetch(:commits_url)+"?#{token_access2}").read).each do |item|
    item['message']=item['commit'].fetch('message').to_s
    item['commit']=item['commit'].to_s
    item['author']=item['author'].to_s
    item['committer']=item['committer'].to_s
    item['parents']=item['parents'].to_s
    item['pull_id']= DB[:repo_pr_abs].select(:number).where(:commits_url=>row.fetch(:commits_url))[:number].fetch(:number)
    p item['pull_id']
    items.insert(item)
    p item['sha']
  end
  sleep(1)
end

















