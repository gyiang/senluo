a=[1,3,2,4,5,6,7,8]
a.partition{|x| x%2!=0}

=begin
a.map.with_index do |x,i|
  p [x,a[i-1]]
  p [x,i]
  p [x,a[i+1]]
  p "============"
end
=end

[1,2,3].zip([2,4,6],[3,5,6]) {|x| p x }

b=[5    ,2,3]
c=b.map
p c.next
p c.next
p c.next


c=c.map{|x| x**2}
p c.map.next

m={}
m[1]=2
m[2]=4
m[5]=3

m.each_with_index  do |x, i|
  p [x, i]
end



n=[1,2,3,4,5]
n1=[3,4,5,6,7,8]
p n1.zip n


ary = ["1", "11", "2", "6"]
p ary.sort{|a,b| a.to_i <=> b.to_i}
# 结果
# ["1","2","6","11"]

p ary.map{|i|[i.to_i,i]}.sort.map{|j|j[-1]}
# [1,2,6,11]

p ary.sort_by{|x| x.to_i}
# 结果
# ["1", "2", "6", "11"]