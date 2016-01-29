require 'open-uri'
require 'json'

token="access_token=877738b0ede13b627605e301dd4f00725697ca0d"
apiurl='https://api.github.com/search/repositories?q=+'
language='language%3Ajava'
stars='stars%3A%3C=1000'
create_ad='created%3A%3E2015-01-01'
sort='sort=stars&order=desc'
per_page='per_page=100'

# https://api.github.com/search/repositories?q=+created%3A%3C2015-01-01+language%3AJava+stars%3A%3E1000

u="#{apiurl}#{language}&#{stars}&#{create_ad}&#{sort}&#{token}&#{per_page}&page=2"




#data=JSON.parse()

File.open("/root/Desktop/testj2c", "w") do |file|
    file.write(open(u).read)
end

`cat /root/Desktop/testj2c | json2csv -p >> /root/Desktop/testre.csv`

=begin
data.fetch('items').each do |item|
    p [item['name'],item['stargazers_count'],item['forks']]
end
=end



