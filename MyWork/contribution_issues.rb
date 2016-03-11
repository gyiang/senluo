require 'sequel'

DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test1?characterEncoding=UTF-8')

author="Simon Willnauer"

def cal_issues
# try to do
  id=DB[:users].select(:user_id).where(:git_name=>"#{author}").all[0][:user_id]
  DB[:users_radar].select(:tag,:date).each do |d|
    issues=DB[:issues].where('created_at< ?',d[:date]).group_and_count(:author_id).all.detect{|x|x[:author_id]==id}
    comments=DB[:issue_comments].where('created_at< ?',d[:date]).
        group_and_count(:author_id).all.detect{|x| x[:author_id]==id}
    # if nil
    issues={:count=>0} if issues.nil?
    comments={:count=>0} if comments.nil?
    DB[:users_radar].where(:tag=>d[:tag]).update(:issues=>issues[:count],:comments=>comments[:count])
  end
end





