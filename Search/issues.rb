require 'sequel'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/github?characterEncoding=UTF-8')



DB[:issues].select().each do |row|
  d=row[:locations].to_sequl_blob
  p d.class
end

