require 'sequel'
require 'json'

repo_pr=:repo_pr_abs
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/github?characterEncoding=UTF-8')

pr=Hash.new
#calculate pr
DB[repo_pr].select().each do |row|
  u=JSON.parse(row[:user].gsub('=>', ':'))['login']

  if pr[u] then
    pr[u]=pr[u]+1
  else
    pr[u]=1
  end
end

p "pr_contributors:#{pr.length}"
#sort and output it
Hash[pr.sort{|key,val|val[1]<=>key[1]}].each_pair  do |key,val|
  p [key,val]
end
