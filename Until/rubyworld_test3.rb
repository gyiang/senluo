f3=File.open("/root/Desktop/f3.txt","a+")
File.open("/root/Desktop/fone2.txt") do |file|
  file.readlines.each do |line|
    id,data =line.split(",",2)
    f3.write(id+"\t"+data.chomp+"\n")
  end
end