# encoding: utf-8
require 'sequel'


DBCode = Sequel.connect('mysql2://root:1234@127.0.0.1:3306/trustie122?characterEncoding=UTF-8')
DBTrustie= Sequel.connect('mysql2://root:1234@127.0.0.1:3306/trustie122?characterEncoding=UTF-8')


commons=DBTrustie[:homework_commons]
programings=DBTrustie[:homework_detail_programings]
homework_tests=DBTrustie[:homework_tests]
manuals=DBTrustie[:homework_detail_manuals]

common={}
programing={}
homework_test={}
manual={}

index=0
DBCode[:problem_detail].select().each do |row|
        index= "%04d" % (index.to_i+1)
        ab=row[:problem_index][row[:problem_index].length-1]
        common['name']="#{index}#{ab}(#{row[:problem_index]}) #{row[:name]} / 题目(tag)_姓名"
        common['user_id']=11890
        common['description']=row[:description].gsub("\n","<br />\n")
        p common['description']
        common['publish_time']='2016-01-28'
        common['end_time']='2016-01-31'
        common['homework_type']=2
        common['late_penalty']=10
        common['course_id']=478
        common['created_at']='2016-01-28'
        common['updated_at']='2016-01-31'
        common['teacher_priority']=1
        common['anonymous_comment']=0
        commons.insert(common)

        id= DBTrustie[:homework_commons].select(:user_id,:id).where(:name=>common['name']).to_a
        programing['language']=2
        programing['homework_common_id']=id[id.length-1][:id]
        programing['ta_proportion']=0.5
        programing['created_at']='2016-01-28'
        programing['updated_at']='2016-01-31'
        code=DBCode[:problem_code_gnu].select(:problem_index,:code).where(:problem_index=>row[:problem_index]).to_a
        if code!=[] then
          programing['standard_code']=code[0:code]
        end
        programings.insert(programing)


        DBCode[:test_data].select().where(:problem_index=>row[:problem_index]).each  do |test|
          homework_test['input']=test[:input]
          homework_test['output']=test[:output]
          homework_test['homework_common_id']=programing['homework_common_id']
          homework_test['created_at']='2016-01-28'
          homework_test['updated_at']='2016-01-31'
          homework_tests.insert(homework_test)
        end

        manual['ta_proportion']=0.3
        manual['comment_status']=1
        manual['evaluation_start']='2016-02-07'
        manual['evaluation_end']='2016-02-14'
        manual['evaluation_num']=3
        manual['absence_penalty']=5
        manual['homework_common_id']=programing['homework_common_id']
        manual['created_at']='2016-01-28'
        manual['updated_at']='2016-01-31'
        manuals.insert(manual)

        p common['name']
end



