require 'open-uri'
require 'sequel'
require 'json'

token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/github?characterEncoding=UTF-8')

table=:repo_pr_commits_abs

h=Hash.new
# calculate commit_author's comments_count
# author' name not a login,but a git
DB[table].select().each do |row|
  commit=JSON.parse(row[:commit].gsub!('=>',':'))
  author=commit['author']['name']
  cc=commit['comment_count']
  if h[author] then
    h[author]=h[author]+cc
  else
    h[author]=cc
  end
end

# sort it
Hash[h.sort{|key,val|val[1]<=>key[1]}].each_pair do |k,v|
  p [k,v]
end
p "total_authors:#{h.length}"

# needn't to fetch api
# page=open(row.fetch(:comments_url) + "?#{token}").read
# if page=="[]"