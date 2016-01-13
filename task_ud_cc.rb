require 'sequel'

#usr@pwd may cause error if pwd has '@';
git_tree="--git-dir=/home/git/repositories"
DB = Sequel.connect('mysql2://127.0.0.1:3306/gitlab?characterEncoding=UTF-8')

DB[:projects].select(:id,:name,:namespace_id).each  do |row|
  namespace=DB[:namespaces].select(:name).where(:id=>row.fetch(:namespace_id)).to_hash(nil,:name)
  `git #{git_tree}/#{namespace.fetch(nil)}/#{row.fetch(:name)}.git log --pretty=oneline | wc -l`.each_line do |num|
    if /^\d+$/=~num then DB[:projects].where(:id=>row.fetch(:id)).update(:commit_count=>num) end
  end
end








