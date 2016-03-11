require 'sequel'
require 'pp'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test1?characterEncoding=UTF-8')
$git_tree="--git-dir=/root/Desktop/elasticsearch/.git"
author="Martijn van Groningen"

# target table
users_radar=DB[:users_radar]
tags=[]

`git #{$git_tree} tag`.each_line do |tag|
  tags.push(tag.chomp)
end

# merge tag versions(v0.x.y) to v0.x
# get tag's date
tags_date={}
tags.each do |tag|
  `git #{$git_tree} show #{tag} --date=short`.each_line do |line|
    if line.start_with?("Date:") then
      tags_date["#{tag}"]=line.match(/\d{4}-\d{2}-\d{2}/)[0]
      break
    end
  end
end
pp tags_date

radar={}
ur={} #store data
tags_date.each do |k,v|
  cmt=`git #{$git_tree} log --pretty=oneline --author="#{author}" --before={#{v}} | wc -l`.chomp

  add, del, changes=`git #{$git_tree}  log --author="#{author}" --before={#{v}} --pretty=tformat: --numstat |
 gawk '{ add += $1;subs += $2;loc += $1 + $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

  fixs=`git #{$git_tree} log --pretty="%s" --author="#{author}" --before="#{v}" | grep -P '(fix|fixes|fixed)' | wc -l`.chomp

  closes=`git #{$git_tree} log --pretty="%s" --author="#{author}" --before="#{v}" | grep -P '(close|closes|closed)\s#\\d+' | wc -l`.chomp

  # try to pre it
  id=DB[:users].select(:user_id).where(:git_name=>"#{author}").all[0][:user_id]

  # merge tag
  tag=k.match(/(v\d+\.\d+)/)[0]
  radar[tag]=[cmt.to_i,add.to_i,del.to_i,fixs.to_i,closes.to_i,v] if (radar[tag]==nil or radar[tag][0]<cmt.to_i)

  p k
end

# insert to database
radar.each do |k,v|
  ur[:git_name]="#{author}"
  ur[:cmt]=v[0]
  ur[:add]=v[1]
  ur[:del]=v[2]
  ur[:fixs]=v[3]
  ur[:closes]=v[4]
  ur[:date]=v[5]
  ur[:tag]=k
  users_radar.insert(ur)
end


# cal issues comments
id=DB[:users].select(:user_id).where(:git_name=>"#{author}").all[0][:user_id]
DB[:users_radar].select(:tag,:date).each do |d|
  issues=DB[:issues].where('created_at< ?',d[:date]).group_and_count(:author_id).all.detect{|x|x[:author_id]==id}
  comments=DB[:issue_comments].where('created_at< ?',d[:date]).
      group_and_count(:author_id).all.detect{|x| x[:author_id]==id}
  # if nil
  issues={:count=>0} if issues.nil?
  comments={:count=>0} if comments.nil?
  DB[:users_radar].where(:tag=>d[:tag]).update(:issues=>issues[:count],:comments=>comments[:count])
end




