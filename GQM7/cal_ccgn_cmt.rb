git_tree="--git-dir=/root/Desktop/elasticsearch/.git"

#total commits,contributors
total_commits=`git #{git_tree} log --pretty=oneline | wc -l`.to_i

require 'sequel'
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test1?characterEncoding=UTF-8')

h={}
#each contributor
`git #{git_tree}  log --pretty='%an,%ae' | sort | uniq -c | sort -k1 -n -r `.each_line do |line|
  commits_num, user=line.chomp.split(" ", 2)
  uname, email=user.split(",")

  add, del, changes=`git #{git_tree}  log --author="#{uname}" --pretty=tformat: --numstat |
 gawk '{ add += $1;subs += $2;loc += $1 - $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

  #percentage="%.2f" % (Float(commits_num)/total_commits*100) +"%"

  p [commits_num, uname, email, add, del, changes.to_i.abs]

  #gen ju email he bing ,qu chong
  if h[email] then
    h[email][0]=h[email][0]+commits_num.to_i
    h[email][1]=h[email][1]+changes.to_i.abs
  else
    h[email]=[commits_num.to_i,changes.to_i.abs]
  end

  DB[:users].where(:git_email=>email).update(:CMT=>h[email][0],:CCGN=>h[email][1])
end







