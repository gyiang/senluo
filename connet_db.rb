require 'mysql'
db = Mysql.new("127.0.0.1", "root", "", "gitlabhq_development_v8")
r=db.query("select * from projects")

r.each_hash do |f|
  puts "#{f['name']},#{f["path"]},#{f["created_at"]}"
end