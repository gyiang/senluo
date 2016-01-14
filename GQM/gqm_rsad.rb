require 'sequel'
require 'json'
require 'open-uri'


token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test?characterEncoding=UTF-8')

=begin
DB.create_table?(:repo_issues_abs_c,:charset => 'utf8') do
  Integer :issue_id
  Text :comments
end
items = DB[:repo_issues_abs_c]
DB[:repo_issues_abs].select().each do |row|
  if (Date.parse(Time.now.to_s)-Date.parse(row[:updated_at])).to_i <=100 then
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
end
=end

require 'set'
h=Hash.new
# use set to dup
s=Set.new
DB[:repo_issues_abs_c].select().each do |row|
  item=JSON.parse(row[:comments].gsub!('=>',':'))
  author=item['user']['login']
  date=Date.parse(item['created_at'])
  s.add([author,date.to_s,1])
end

s.each do |s1|
  if h[s1[0]] then
    h[s1[0]]=h[s1[0]]+1
  else
    h[s1[0]]=1
  end
end

# sort and output it
Hash[h.sort{|k,v|v[1]<=>k[1]}].each_pair do |k,v|
  p [k,v]
end





