git_tree="--git-dir=/root/Desktop/fastjson/.git"
work_tree="--work-tree=/root/Desktop/fastjson"

`git #{git_tree} #{work_tree} checkout 1.2.7`

cmd=`git #{git_tree} #{work_tree} log --pretty='%an' | sort | uniq -c | sort -k1 -n -r ` #| head -n 10
puts "commits,author,commit_change"

cmd.each_line do |f|
  commits_num,author=f.chomp.split(" ")
  changes=`git #{git_tree} #{work_tree} log --author="#{author}" --pretty=tformat: --numstat | gawk '{ add += $1;} END {printf add}' -`
  puts [commits_num+","+author+","+changes]
end


p "total_changes:"+`git #{git_tree} #{work_tree} log --pretty=tformat: --numstat | gawk '{ add += $1;} END {printf add}' -`


commits=Array.new
`git #{git_tree} #{work_tree} log --pretty=oneline`.each_line do |f|
  commits.push(f.split(" ")[0])
end

commits.reverse!



changes_file_pre=Array.new
changes_file_cur=Array.new
commits_need_scan=Array.new

commits.each_with_index do |c,index|
  #if first
  if index==0 then
    commits_need_scan.push(c)
    `git #{git_tree} #{work_tree} diff #{commits[0]} --stat`.each_line do |f|
      changes_file_pre.push(f.split("|")[0].chomp.strip)
    end
    changes_file_pre.pop
    next
  end

  `git #{git_tree} #{work_tree} diff #{commits[index]} #{commits[index-1]} --stat`.each_line do |f|
    changes_file_cur.push(f.split("|")[0].chomp.strip)
  end
  changes_file_cur.pop

  changes_file_pre.each do |f|
    if changes_file_cur.include?f then
      commits_need_scan.push(c)
      break
    end
  end
  changes_file_pre=changes_file_cur.clone
  changes_file_cur.clear
end
puts "#{commits_need_scan.length}/#{commits.length}=#{(Float(commits_need_scan.length)/commits.length).round(3)}"

#""b24e6ca975ade7ae42aeb1abb18237c12ebafc75""