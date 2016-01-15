require 'sequel'
require 'json'
require 'open-uri'
require 'set'



DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test?characterEncoding=UTF-8')
table=:repo_issues_abs
token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"

# issue,pr author
contributors=Set.new
DB[table].select().each do |row|
 contributors.add(JSON.parse(row[:user].to_s.gsub!('=>',':'))['login'])
end

# pr_commits_author
table=:repo_pr_commits_abs
DB[table].select().each do |row|
  begin
    contributors.add(JSON.parse(row[:author].to_s.gsub!('=>',':'))['login'])
  rescue
    p row[:sha]
  end
end

# issue,pr'comments author
table=:repo_issues_comments_abs
DB[table].select().each do |row|
  contributors.add(JSON.parse(row[:comments].gsub!('=>',':'))['user']['login'])
end


p contributors.size

DB.create_table?(:repo_contributor_abs,:charset => 'utf8') do
  Integer :id
  String :login
  String :email
  Text :info
end
items = DB[:repo_contributor_abs]
i=1

has_c=DB[:repo_contributor_abs].select().to_hash(:login,:email)
contributors.each do |c|
  if has_c.key?(c) then
    p c+"=>pass"
    p [c,i.to_s+"/"+contributors.size.to_s]
    i+=1
    next
  end

  info=JSON.parse(open("https://api.github.com/users/"+c+"?#{token}").read)
  item=Hash.new
  item[:info]=info.to_s
  item[:id]=info['id']
  item[:login]=info['login']
  item[:email]=info['email']
  items.insert(item)
  p [c,i.to_s+"/"+contributors.size.to_s]
  i+=1
end


