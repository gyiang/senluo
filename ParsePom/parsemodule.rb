require 'rexml/document'
require 'open-uri'
require 'json'
require 'sequel'
require 'set'

x=0
y=0
error=[]
DB=Sequel.connect('mysql2://root:1234@127.0.0.1:3306/cmw?characterEncoding=UTF-8')

DB.create_table?(:orgs_module,:charset => 'utf8') do
  Integer :id
  String :full_name
  String :module
end

items=DB[:orgs_module]
item={}

DB[:orgs_pom].select().where(:has_pom=>1).each do |row|
  x+=1
  begin
    doc = REXML::Document.new(row[:pom])
  rescue
    #error.push([row[:full_name],$!])
    error.push(row[:full_name])
    next
  end
  item['id']=row[:id]
  item['full_name']=row[:full_name]
  doc.root.get_elements("modules").each do |modules|
    modules.get_elements("module").each do |m|
      p [row[:full_name],m.text]
      item['module']=m.text
      items.insert(item)
      y+=1
    end
  end
end

p [x,y]
p error