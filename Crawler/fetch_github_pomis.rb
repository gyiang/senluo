require 'open-uri'
require 'json'
require 'sequel'
require 'set'

DB=Sequel.connect('mysql2://root:1234@127.0.0.1:3306/cmw?characterEncoding=UTF-8')
DB.create_table?(:orgs_pom,:charset => 'utf8') do
  Integer :id
  Integer :has_pom
  String :full_name
  Blob :pom
end
items=DB[:orgs_pom]

item={}
bp=Set.new
DB[:orgs_pom].select(:id).each { |row| bp.add(row[:id])}
DB[:orgs].select().where(:language=>'Java').each do |row|
  if bp.include?(row[:id]) then next end
  item['id']=row[:id]
  item['full_name']=row[:full_name]

  begin
    pom=open("https://raw.githubusercontent.com/"+row[:full_name].to_s+"/master/pom.xml").read
    item['has_pom']=1
    item['pom']=pom
  rescue OpenURI::HTTPError
    p  $!
    item['has_pom']=0
    item['pom']=nil
  end

  items.insert(item)
  p [row[:id],row[:full_name]]

end
