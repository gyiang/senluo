require 'sequel'
require 'json'
require 'set'
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test1?characterEncoding=UTF-8')
$git_tree="--git-dir=/root/Desktop/elasticsearch/.git"

tags=[]
`git #{$git_tree} tag`.each_line do |tag|
  tags.push(tag.chomp)
end

tags_date={}
tags.each do |tag|
  `git #{$git_tree} show #{tag} --date=short`.each_line do |line|
    if line.start_with?("Date:") then
      tags_date["#{tag}"]=line.match(/\d{4}-\d{2}-\d{2}/)[0]
      break
    end
  end
end
p tags_date

author="Martijn van Groningen"
radar={}
users_radar=DB[:users_radar]
ur={}
tags_date.each do |k,v|
  cmt=`git #{$git_tree} log --pretty=oneline --author="#{author}" --before={#{v}} | wc -l`.chomp

  add, del, changes=`git #{$git_tree}  log --author="#{author}" --before={#{v}} --pretty=tformat: --numstat |
 gawk '{ add += $1;subs += $2;loc += $1 + $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

  #
  tag=k.match(/(v\d+\.\d+)/)[0]

  radar[tag]=[cmt.to_i,add.to_i,del.to_i,v] if (radar[tag]==nil or radar[tag][0]<cmt.to_i)

  p k

=begin
  if radar[tag] then
    radar[tag]=[radar[tag][0]+cmt.to_i,radar[tag][1]+add.to_i,radar[tag][2]+del.to_i]
  else
    radar[tag]=[cmt.to_i,add.to_i,del.to_i]
  end
=end
end

radar.each do |k,v|
  ur[:git_name]="#{author}"
  ur[:cmt]=v[0]
  ur[:add]=v[1]
  ur[:del]=v[2]
  ur[:date]=v[3]
  ur[:tag]=k
  users_radar.insert(ur)
end



