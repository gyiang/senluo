require 'open-uri'
require 'json'
require 'sequel'
require 'set'

DB=Sequel.connect('mysql2://root:1234@127.0.0.1:3306/cmw?characterEncoding=UTF-8')
DB.create_table?(:orgs_pom2,:charset => 'utf8') do
  Integer :id
  String :branch
  Integer :has_pom
  String :full_name
  Blob :pom
end
items=DB[:orgs_pom2]

item={}
bp=Set.new
DB[:orgs_pom2].select(:id).each { |row| bp.add(row[:id])}
DB[:orgs_pom].select().where(:has_pom=>0).each do |row|
  if bp.include?(row[:id]) then next end
  item['id']=row[:id]
  item['full_name']=row[:full_name]
  item['branch']=DB[:orgs].select().where(:id=>row[:id]).to_a[0][:default_branch]

  begin
    pom=open("https://raw.githubusercontent.com/"+row[:full_name].to_s+"/#{item['branch']}/pom.xml").read
    item['has_pom']=1
    item['pom']=pom
  rescue OpenURI::HTTPError
    p  $!
    item['has_pom']=0
    item['pom']=nil
  end

  items.insert(item)
  p [row[:id],row[:full_name],item['branch']]

end
