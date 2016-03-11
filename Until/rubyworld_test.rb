def test1
  a=[1,3,2,4,5,6,7,8]
  a.partition{|x| x%2!=0}


  a.map.with_index do |x,i|
    p [x,a[i-1]]
    p [x,i]
    p [x,a[i+1]]
    p "============"
  end


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
end


def test2

  a=[1,2,3,4]
  b=[5,6,7]
  result = []
  ia = a.each
  ib = b.each
  loop do
    result.push(ia.next)
    result.push(ib.next)
  end
  p  result
  #=>[1, 5, 2, 6, 3, 7, 4, 8]
end


#require 'jcode'
def test3
  s = "abc de"
  p s.tr("a-z", "A-Z")

  s2="aaaaaaabbbbbbbcccccccddbbnnjjkkkkppppp"
  p s2.squeeze

  p s.reverse

  p s.succ.succ

end

def test4
  p 2.weeks.ago

end

def test5
  if /\A(?<a>|.|(?:(?<b>.)\g<a>\k<b+0>))\z/=~"ccvvaaaavvcc"
    p 1
  end
end


def test6
  sieve = []
  max = 100
  for i in 2 .. max
    sieve[i] = i
  end
  for i in 2 .. Math.sqrt(max)
    next unless sieve[i]
    #step func
    (i*i).step(max, i) do |j|
      sieve[j] = nil
    end
  end
  puts sieve.compact.join(", ")
end


require 'complex'

def mandelbrot(cr, ci)
  limit=95
  iterations=0
  c=Complex.new(cr,ci)
  z=Complex.new(0,0)
  while iterations<limit and z.abs<10
    z=z*z+c
    iterations+=1
  end
  return iterations
end

def mandel_calc(min_r, min_i, max_r, max_i, res)
  cur_i = min_i
  while cur_i > max_i
  print "|"
  cur_r = min_r
  while cur_r < max_r
  ch = 127 - mandelbrot(cur_r, cur_i)
  printf "%c",ch
  cur_r += res
  end
print "|\n"
cur_i -= res
end
end
mandel_calc(-2, 1, 1, -1, 0.04)