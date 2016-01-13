git_tree="--git-dir=/root/Desktop/fastjson/.git"
work_tree="--work-tree=/root/Desktop/fastjson"


#get all history file changes log
commits=Array.new
`git #{git_tree} #{work_tree} log --pretty=oneline`.each_line do |f|
  commits.push(f.split(" ")[0])
end

commits.reverse!

changes_files_each=Array.new
changes_files=Array.new
commits.each_with_index do |c,index|
    `git #{git_tree} #{work_tree} show #{c} --stat`.each_line do |line|
      if line.include?"|"
        changes_files_each.push(line.split("|")[0].chomp.strip)
      end
    end
    changes_files.push(changes_files_each.clone)
    changes_files_each.clear
end


#find commit_id that need scan
temp=Array.new
commits_need_scan=Array.new

temp.concat(changes_files[0])
changes_files.each_index do |i|
  if i==changes_files.length-1 then
    commits_need_scan.push(commits[i])
    break
  end
  next_change_files=changes_files[i+1]
  if (next_change_files & temp).empty? then
    #temp=temp+next_change_files
    temp.concat(next_change_files)
  else
    commits_need_scan.push(commits[i])
    temp.clear
    temp=next_change_files.clone
  end
end

p commits_need_scan.length


