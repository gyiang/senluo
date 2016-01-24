require 'rexml/document'
require 'open-uri'
require 'json'
require 'sequel'
require 'set'

x=0
y=0
error=[]
DB=Sequel.connect('mysql2://root:1234@127.0.0.1:3306/cmw?characterEncoding=UTF-8')

DB.create_table?(:orgs_dependency2,:charset => 'utf8') do
  Integer :id
  String :groupId
  String :artifactId
end

items=DB[:orgs_dependency2]
item={}

DB[:orgs_pom2].select().where(:has_pom=>1).each do |row|
  x+=1
  begin
    doc = REXML::Document.new(row[:pom])
  rescue
    #error.push([row[:full_name],$!])
    error.push(row[:full_name])
    next
  end
  item['id']=row[:id]
  doc.root.get_elements("dependencyManagement").each do |depend|
    depend.get_elements("dependencies").each do |d1|
      d1.get_elements("dependency").each do |d2|
        p [d2.elements["groupId"].text,d2.elements["artifactId"].text]
        item['groupId']=d2.elements["groupId"].text
        item['artifactId']=d2.elements["artifactId"].text
        items.insert(item)
        y+=1
      end
    end
  end

  doc.root.get_elements("dependencies").each do |depend|
    depend.get_elements("dependency").each do |d|
      p [d.elements["groupId"].text,d.elements["artifactId"].text]
      item['groupId']=d.elements["groupId"].text
      item['artifactId']=d.elements["artifactId"].text
      items.insert(item)
      y+=1
    end
  end
end

p [x,y]
p error
