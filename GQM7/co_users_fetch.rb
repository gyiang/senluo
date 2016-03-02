require 'sequel'
require 'mechanize'
require 'json'
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/co_user_test?characterEncoding=UTF-8')

agent = Mechanize.new
agent.user_agent_alias = 'Windows Edge'

target_repo="elastic/elasticsearch"
id=507775
token="877738b0ede13b627605e301dd4f00725697ca0d"
pn=320
url="https://api.github.com/repos/#{target_repo}/commits?access_token=#{token}&per_page=100&page="


items=DB[:commits_github]
item={}
while true
  page=agent.get(url+pn.to_s)
  if page.code=="200" then
    break if page.body=="[\n\n]\n"
    commits=JSON.parse(page.body)
    commits.each do |row|
      item['repo_id']=id
      item['sha']=row['sha']
      item['commit_info']=row.to_s
      items.insert(item)
    end
    p page.uri
  else
    p "Error:"+page.uri
    next
  end
  pn+=1
end









