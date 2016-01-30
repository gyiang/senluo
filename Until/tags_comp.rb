require 'sequel'

DB=Sequel.connect('mysql2://root:1234@127.0.0.1:3306/neo?characterEncoding=UTF-8')

DB.create_table?(:proj_tags,:charset => 'utf8') do
  Integer :projid
  String :tags
end


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

is_save=false
if is_save then
  # save
  tags=DB[:proj_tags]
  tag={}
  h.each_pair do |k,v|
    tag['projid']=k.to_i
    tag['tags']=v.to_s
    tags.insert(tag)
  end
end

DB.create_table?(:values,:charset => 'utf8') do
  Integer :k1
  Integer :k2
  Integer :v1_len
  Integer :v2_len
  Integer :c
  Double  :similarity
end
values=DB[:values]
value={}

h.each_pair do |k1,v1|
  h.each_pair do |k2,v2|
    if k2.to_i< k1.to_i then next end
    c=(v1 & v2).size
    if c==0 then next end

    v1_len=v1.length
    v2_len=v2.length
    value['k1']=k1
    value['k2']=k2
    value['v1_len']=v1_len
    value['v2_len']=v2_len
    value['c']=c
    #value['similarity']=c/Float(v1_len**(1.0/2)*v2_len**(1.0/2))
    value['similarity']=c/(Math.sqrt(v1_len)*Math.sqrt(v2_len))
    values.insert(value)
    #resulet.puts("#{k1},#{k2},#{(v1 & v2).size}\n")
  end
  p "#{k1}/#{h.size}"
end
