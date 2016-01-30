require 'sequel'
require 'open-uri'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/clone?characterEncoding=UTF-8')

DB[:repo_java].select().where(:isdown=>nil).each do |row|
  clone_url="https://github.com/#{row[:full_name]}.git"
  p "clone #{row[:full_name]}"
  `git clone #{clone_url}`
  DB[:repo_java].where(:id=>row[:id]).update(:isdown=>1)
end