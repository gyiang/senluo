require 'sequel'

DB=Sequel.connect('mysql2://root:1234@127.0.0.1:3306/neo?characterEncoding=UTF-8')

h={} #77757 elements
DB[:open_source_projects].select(:id).each do |row|
  DB[:proj_tag].select().where(:projId=>row[:id]).each do |tag|
      if h[tag[:projId]] then
        h[tag[:projId]]=h[tag[:projId]].push(tag[:tag])
      else
        h[tag[:projId]]=[tag[:tag]]
      end
  end
  p row[:id]
end


File.new("/root/Desktop/h","a+").puts(h)


h.each_pair do |k1,v1|
  h.each_pair do |k2,v2|
    if k2.to_i< k1.to_i then next end
    p [k1,k2,(v1 & v2).size]
    resulet.puts("#{k1},#{k2},#{(v1 & v2).size}\n")
  end
end

value=[]
=begin
10.times do |x|
  x=x+1
  if h[x] then
    for y in x..10 do
       (h[x] & h[y]).size
    #65
    end
  else
    for y in x..10 do
      value[x][y]=value[y][x]= 0
    end
  end
end
=end

p value
