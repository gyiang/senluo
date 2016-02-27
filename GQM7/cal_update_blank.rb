require 'sequel'
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test2?characterEncoding=UTF-8')

DB[:users].with_sql('update_sqlusers where git_emial')