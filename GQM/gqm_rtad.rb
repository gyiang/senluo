git_tree="--git-dir=/root/Desktop/lab/Android-Universal-Image-Loader/.git"

#`git log --pretty='%an %ad' --date=short --since=3.months| uniq -c| sort -k1 -r -n`
h=Hash.new
`git #{git_tree} log --pretty='%an,%ad' --date=short --since=3.months | uniq`.each_line do |line|
  author=line.split(",")[0]

  #group by
  if h[author] then
    h[author]=h[author]+1
  else
    h[author]=1
  end
end

#output
h.each_pair do |k,v|
  p [k,v]
end

