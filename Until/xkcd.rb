require "mechanize"
# ruby aichen.rb pagenmber
url="http://xkcd.com/"
page_num=1655
agent=Mechanize.new
agent.user_agent_alias = 'Windows IE 9'
file="pics/"
page=agent.get(url+page_num)
file=file+page_num+"/"
page.links_with(:text => /\[\d+P\]/).each do |link|
  puts link.href
  imgcount=0
  next_page=link.click
  subfile=next_page.at('h1#subject_tpc').content
  puts subfile
  next_page.images_with(:src => /jpg/).each do |img|
    puts img.url
    begin
      img.fetch.save(file+subfile+"/"+imgcount.to_s+".jpg")
    rescue
      puts "can not get this one"
    end
    imgcount+=1
  end
end