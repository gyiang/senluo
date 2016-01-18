require 'sequel'
require 'json'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test?characterEncoding=UTF-8')


# extra github' login
github=[]
DB[:repo_contributor_abs].select(:login,:email).each do |row|
  github.push([row[:login],row[:email]])
  #p [row[:login],row[:email]]
end


d_time=[] #store duration_time =>[user,duration_time]
DB[:repo_issues_abs].select().where().each do |row_i|
  #p "scan:"+row_i[:number].to_s
  if row_i[:comments]==0 then next end

  # get issue(include pr)'s info [login,create_time] ,use unix timestamp
  issue_created_at=Time.parse(row_i[:created_at]).to_i
  issue_author=JSON.parse(row_i[:user].gsub('=>',':'))['login']


  # get issue's all comments  mate=>[user,time,body]+
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

  # sort by time
  c.sort!{|x,y| x[1]<=>y[1]}
  # [0] is issues'content body
  c.unshift([issue_author,issue_created_at,row_i[:body]])


  # sign whether the contributor is 1st post
  onest={}
  c.each_with_index do |one,one_index|
    if onest[one] then
      next
    else
      onest[one]=one_index
    end
  end

  # calculate ILR=> Number of low response for issues
  # c is all comments
  # start_t=0

  sign=[] #clear sign info
  c.each_with_index do |item,index|
    # get U1'time
    if index==0 then
      start_t=item[1]
      next
    end

    # scan @
    catch :scan_loop do
      github.each_with_index do |login,index_github|
        if  /@#{login[0]}/ =~ item[2]
          # store current info
          cur_time=item[1]
          call_user=login[0]

          # forword to find tongban,until [0]
          index.times do |i_forward|
            #whether it was calculated
            if sign.include?(index) then
              break
            end

            # to find if have see @user
            if c[index-1-i_forward][0]==call_user then
              # if find
              # to @U' time
              d_time.push([item[0],cur_time-c[index-1-i_forward][1]])
              sign.push(index)
              break
            end

            # if not find
=begin
            if i_forward==index-1 then
              #whether 1st post
              if onest[item[0]]==index then
                # to issues's time
                d_time.push(item[0],cur_time-start_t) #c[0][1]
              else
                # to nearest comment's time
                duration_time=cur_time-c[index-1][1]
                d_time.push([item[0],duration_time])
              end
            end
            sign.push(index)
=end
          end

          # backward to find @user
          c.each_with_index do |c2,i2|
            if i2<=index_github then next end
            # if find
            if c2[0]==call_user then
              duration_time=c2[1]-cur_time
              d_time.push([call_user,duration_time])
              # sign the #
              sign.push(i2)
              throw :scan_loop
            end
          end
          # not find @user,how ? i give it a -1
          d_time.push([call_user,-1])
          break
        end
      end
    end

    # no @ scene or has @ but forward@U not find
    if !sign.include?(index) then
      # 1st ?
      if onest[item[0]]==index then
        # to issues's time
        d_time.push(item[0],item[1]-start_t) #c[0][1]
      else
        # to nearest comment's time
        duration_time=item[1]-c[index-1][1]
        d_time.push([item[0],duration_time])
      end
    end
  end
  #p c
end
#p d_time

h=Hash.new

# 10min =prolong time
hx_time=60*30
d_time.each do |t|
  if t[1]<hx_time then
    next
  end

  if h[t[0]] then
    h[t[0]]= h[t[0]]+1
  else
    h[t[0]]=1
  end
end

Hash[h.sort{|k,v| v[1]<=>k[1]}].each_pair do |k,v|
 p [k,v]
end
p h.length










