require 'sequel'
DB = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/test1?characterEncoding=UTF-8')

DB.create_table?(:users_aat_set) do
  Integer :author_id
  String :action_time
end

=begin
[:issues,:issue_comments].each do |table|
  DB[table].select(:author_id,:created_at).all do |row|
    DB[:users_aat_set].insert(row[:author_id],row[:created_at])
    p row
  end
end
=end

user_act_cnt={}
aat={}
DB[:users_aat_set].group_and_count(:author_id).all do |gc|
  user_act_cnt[gc[:author_id]]=gc[:count]
end

user_act_cnt.each do |user_id,cnt|
  user_at=[]
  DB[:users_aat_set].select(:action_time).where(:author_id=>user_id).all do |at|
    user_at.push Time.parse(at[:action_time]).to_i
  end
  interval_time_sum=0
  user_at.sort!.each_with_index do |time,index|
    interval_time_sum=Time.now.to_i-time if cnt==1
    break if index==cnt-1
    interval_time_sum+=(user_at[index+1]-time)
  end
  aat[user_id]=interval_time_sum/cnt
  p [aat[user_id],interval_time_sum,cnt]
end


