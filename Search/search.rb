require 'open-uri'
require 'json'


url='https://api.github.com/search/repositories?q=+language:java&stars%3E=1000&fork=only&sort=stars&order=desc'
data=JSON.parse(open(url).read)
data.fetch('items').each do |item|
    p [item['name'],item['stargazers_count'],item['forks']]
end
