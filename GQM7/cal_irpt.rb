require 'sequel'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test1?characterEncoding=UTF-8')

DB[:issues].group_and_count(:author_id).all do |item|
  DB[:users].where(:user_id=>item[:author_id]).update(:IRPT=>item[:count])
end