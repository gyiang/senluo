# git_tree="--git-dir=/root/Desktop/fastjson/.git"
# work_tree="--work-tree=/root/Desktop/fastjson"
# a=Array.new
# `git #{git_tree} #{work_tree} log --pretty=oneline`.each_line do |f|
#   p f.split(" ")[0]
#   a.push(f.split(" ")[0])
# end
# p a.length


#p `sonar-runner`


#puts format(".2f",1.33333)


=begin
a=[1,2,3,4,5,6]
a.clear
p a
p [].empty?
=end

require 'date'
def days_between(date1, date2)
  d1 = Date.parse(date1)
  d2 = Date.parse(date2)
  (d1 - d2).to_i
end

p days_between(Time.now.to_s,"2015-12-31T13:28:38Z")

require 'mathn'
p 1/2

5.times do |i|
  p i
end