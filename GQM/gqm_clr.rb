require 'sequel'
require 'json'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test?characterEncoding=UTF-8')




DB[:repo_issues_abs].select().each do |row_i|
  if row_i[:comments]==0 then next end

  # get issue(include pr)'s info [login,create_time] ,use unix timestamp
  issue_created_at=Time.parse(row_i[:created_at]).to_i
  issue_author=JSON.parse(row_i[:user].gsub('=>',':'))['login']


  # get issue's all comments  mate=>[user,time,body]
  # c include issue+comments
  c=[]
  DB[:repo_issues_comments_abs].select().where(:issue_id=>row_i[:number]).each do |row_c|
    id=row_c[:issue_id]
    comments=JSON.parse(row_c[:comments].gsub('=>',':'))
    t=Time.parse(comments['created_at']).to_i
    body=comments['body']
    user=comments['user']['login']
    c.push [user,t,body]
  end

  #sort by time
  c.sort!{|x,y| x[1]<=>y[1]}
  c.unshift([issue_author,issue_created_at,row_i[:body]])


  # calculate ILR=> Number of low response for issues
  start_t=0
  c.each_with_index do |item,index|
    if index==0 then
      start_t=item[1]
      next
    end

    if  /@/ =~ item[2]
      p item[2]
    end
  end
  p c
end


