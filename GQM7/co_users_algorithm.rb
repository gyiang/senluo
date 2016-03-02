require 'sequel'
require 'json'
require 'set'
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/co_user_test?characterEncoding=UTF-8')


$gg_author_and_login={}
def github_co
  $cnt=0
  DB[:commits_github].select(:sha,:commit_info).all.each do |row|
    begin
      #.gsub("=>nil",'=>""')
      ci=JSON.parse(row[:commit_info].gsub("=>nil",'=>""').gsub("=>",":"))
    rescue
      puts "error:#{$!} at:#{$@}"
      next
    end

=begin
    if ci['commit']['author']['email']!=ci['commit']['committer']['email']
      p [ci['commit']['author']['name'],ci['commit']['committer']['name']]
      p [ci['commit']['author']['email'],ci['commit']['committer']['email']]
      p [ci['author']['login'],ci['committer']['login']]
      $cnt+=1
    end
=end

    git_email=ci['commit']['author']['email']
    $gg_author_and_login[git_email]=ci['author']['login']
  end
  p $cnt
end



def get_git_user_and_email
  github_co

  h1={}
  h2={}
  git_tree="--git-dir=/root/Desktop/elasticsearch/.git"
  # %an=name %ae=email
  `git #{git_tree}  log --pretty='%an,%ae' | sort -u`.each_line do |item|
    author,email=item.chomp.split(",")
    # co_eamil
    if h1[email] then
      h1[email]=h1[email].push(author)
    else
      h1[email]=[author]
    end
    # co_name
    if h2[author] then
      h2[author]=h2[author].push(email)
    else
      h2[author]=[email]
    end
  end

  # merge result
  h3={}
  h1.each do |k,v|
    if v.size>1 then
      h1[k].each do |author|
        if h2[author].size>1 then
          if h3[h1[k]] then
            h3[h1[k]]=h3[h1[k]].concat(h2[author])
          else
            h3[h1[k]]=h2[author]
          end
        end
      end
    end
  end

  # remove email duplicate
  h3.each do |k,v|
    h3[k]=Set.new(v)
  end

  #output it
  h3.each do |k,v|
    p [k,v]
    v.each do |email|
      if $gg_author_and_login[email] then
        puts "match it: "+[email,$gg_author_and_login[email]].to_s
      end
    end
  end





  #return
  h3
end

get_git_user_and_email
