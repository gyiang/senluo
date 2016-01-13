git_tree="--git-dir=/root/Desktop/lab/ActionBarSherlock/.git"

#total commits,contributors
totals=Array.new(3,0)
total_commits=`git #{git_tree} log --pretty=oneline | wc -l`.to_i

#each contributor
`git #{git_tree}  log --pretty='%an,%ae' | sort | uniq -c | sort -k1 -n -r `.each_line do |line|
  commits_num, user=line.chomp.split(" ", 2)
  uname, email=user.split(",")

  add, del, changes=`git #{git_tree}  log --author="#{uname}" --pretty=tformat: --numstat |
 gawk '{ add += $1;subs += $2;loc += $1 + $2} END {printf("%s,%s,%s",add,subs,loc)}' -`.split(",")

  percentage="%.2f" % (Float(commits_num)/total_commits*100) +"%"

  totals[0]+=add.to_i
  totals[1]+=del.to_i
  totals[2]+=changes.to_i

  p [percentage,commits_num, uname, email, add, del, changes]
end


p totals