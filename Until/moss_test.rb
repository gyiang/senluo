require 'moss_ruby'

# Create the MossRuby object
moss = MossRuby.new(000000000) #replace 000000000 with your user id

# Set options  -- the options will already have these default values
moss.options[:max_matches] = 10
moss.options[:directory_submission] =  false
moss.options[:show_num_matches] = 250
moss.options[:experimental_server] =    false
moss.options[:comment] = ""
moss.options[:language] = "java"

# Create a file hash, with the files to be processed
to_check = MossRuby.empty_file_hash
MossRuby.add_file(to_check, "/root/Desktop/RxJava/src/perf/java/rx/ObservablePerfBaseline.java")
MossRuby.add_file(to_check, "/root/Desktop/ObservablePerfBaseline.java")
MossRuby.add_file(to_check, "/root/Desktop/vace/ObservablePerfBaseline.java")
start=Time.now.to_i
# Get server to process files
url = moss.check to_check

# Get results
results = moss.extract_results url

# Use results
puts "Got results from #{url}"
results.each { |match|
  puts "----"
  match.each { |file|
    puts "#{file[:filename]} #{file[:pct]} #{file[:html]}"
    #p file[:filename],file[:pct]
  }
}
end1=Time.now.to_i
p (end1-start)