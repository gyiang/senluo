require 'sequel'
require 'json'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/github?characterEncoding=UTF-8')
table=:repo_issues_abs

issue=Hash.new
pr=Hash.new
DB[table].select().each do |row|
  u=JSON.parse(row[:user].gsub('=>', ':'))['login']
  if !row[:pull_request] then
    #issue
    h=issue
  else
    #pull_request
    h=pr
  end

  #statistic
  if h[u] then
    h[u]=[h[u][0]+1,h[u][1]+row[:comments]]
  else
    h[u]=[1,row[:comments]]
  end

end

# sort by issue/pr's nums
# key=author,val[0]=nums,val[1]=comments
issue=Hash[issue.sort{|key,val|val[1][0]<=>key[1][0]}]
pr=Hash[pr.sort{|key,val|val[1][0]<=>key[1][0]}]
p "1"