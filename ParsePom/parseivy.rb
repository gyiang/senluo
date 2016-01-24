require 'open-uri'
require 'json'
require 'sequel'
require 'set'

DB=Sequel.connect('mysql2://root:1234@127.0.0.1:3306/cmw?characterEncoding=UTF-8')
DB.create_table?(:orgs_ivy,:charset => 'utf8') do
  Integer :id
  Integer :has_ivy
  String :full_name
  Blob :ivy
end
items=DB[:orgs_ivy]
item={}

bp=Set.new
DB[:orgs_ivy].select(:id).each { |row| bp.add(row[:id])}
DB[:orgs_pom].select().where(:has_pom=>0).each do |row|
  if bp.include?(row[:id]) then next end
  item['id']=row[:id]
  item['full_name']=row[:full_name]
  begin
    ivy=open("https://raw.githubusercontent.com/"+row[:full_name].to_s+"/master/ivy.xml").read
    item['has_ivy']=1
    item['ivy']=ivy
  rescue OpenURI::HTTPError
    p  $!
    item['has_ivy']=0
    item['ivy']=nil
  end
  items.insert(item)
  p [row[:id],row[:full_name]]
end