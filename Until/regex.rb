string = "@@ -147,7 +147,7 @@"

string=~/@@ -(\d+),(\d+) \+\d+,\d+ @@/
p $1
p $2

string.scan(/@@ -(\d+),(\d+) \+\d+,\d+ @@/) do |mat|
  print mat
end