require 'sequel'
require 'json'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/github?characterEncoding=UTF-8')

# unified handling, modifies 'targets'
targets=[:repo_issues_abs,:repo_pr_abs]

result=Array.new
targets.each_with_index do |t,i|
  h=Hash.new

  # calculate each contributor
  DB[t].select().each do |row|
    u=JSON.parse(row[:user].gsub('=>', ':'))['login']
    if h[u] then
      h[u]=h[u]+1
    else
      h[u]=1
    end
  end

  # sort it by value
  result[i]=Hash[h.sort{|key,val|val[1]<=>key[1]}]
end

# [0] is issue, [1] is pr
result.each do |h|
  p "contributors:#{h.length}"
  h.each_pair do |k,v|
    p [k,v]
  end
end
