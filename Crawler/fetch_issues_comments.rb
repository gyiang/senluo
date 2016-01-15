require 'sequel'
require 'json'
require 'open-uri'

token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test?characterEncoding=UTF-8')


DB.create_table?(:repo_issues_comments_abs,:charset => 'utf8') do
  Integer :issue_id
  Text :comments
end
items = DB[:repo_issues_comments_abs]
DB[:repo_issues_abs].select().each do |row|
    if row[:comments] >0 then
      JSON.parse(open(row[:comments_url]+"?#{token}").read).each do |comment|
        item=Hash.new
        item[:comments]=comment.to_s
        item[:issue_id]=row[:number]
        items.insert(item)
        p item[:issue_id]
      end
    end
end

