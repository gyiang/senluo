require 'open-uri'
require 'json'
require 'sequel'


token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"
api_repos="https://api.github.com/repos"
url="https://api.github.com/orgs/hibernate/repos?&#{token}&per_page=100&page="
pn=0

a=[]

while true
  data=open(url+(pn+=1).to_s).read
  if data=="[]" then
    break
  end
  p pn
  File.open("/root/Desktop/hibernate/hibernate#{pn}.json", "a+") do |file|
    file.write(data)
  end
end



#"#{`#{data} | json2csv -o /root/Desktop/test+#{pn}.csv`
#" p pn
