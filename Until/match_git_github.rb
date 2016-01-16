require 'sequel'
require 'json'
# github set
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test?characterEncoding=UTF-8')
table=:repo_contributor_abs
github=[]
DB[table].select(:login,:email).each do |row|
  github.push([row[:login],row[:email]])
  #p [row[:login],row[:email]]
end


# git set
git=[]
git_tree="--git-dir=/root/Desktop/lab/ActionBarSherlock/.git"
`git #{git_tree}  log --pretty='%an,%ae' | sort | uniq `.each_line do |line|
  uname, email=line.chomp.split(",")
  # need reduce dup
  git.push([uname,email])
  #p [uname,email]
end

#math
math=[]
github.each_with_index do |c1,i1|
  git.each_with_index do |c2, i2|
     if c2[1]==c1[1] then
       #p c1[0]+"<=>"+c2[0]
       math.push([c2[0],c1[0],c2[1]])
       p [c2[0],c1[0],c2[1]]
     end
  end
end


p ''
p "git contributors =>"+git.length.to_s
p "github contributors =>"+github.length.to_s
p "match:"+math.length.to_s
p "match ratio(git):"+('%.2f' % (Float(math.length)/git.length*100)).to_s+"%"




github2=[]

DB[table].select().each do |row|
  begin
    name=JSON.parse(row[:info].gsub!('=>',':').gsub!('nil','null'))['name']
  rescue
    p row[:info]
  end

  github2.push [row[:login],row[:email],name]
end

match_name=[]

github2.each_with_index do |c1,i1|
  git.each_with_index do |c2, i2|
    #match name
    if c2[0]==c1[2] then
      #p c1[0]+"<=>"+c2[0]
      match_name.push([c2[0],c1[0],c1[2],c2[1],c1[1]])
      # c2[0] is git'author
      # c1[0] is github'login
      # c1[2] is github'name

      # c2[1] is git'email
      # c1[1] is github'email
      p [c2[0],c1[0],c1[2],c2[1],c1[1]]
    end
  end
end
p match_name.length










