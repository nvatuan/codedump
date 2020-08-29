#!usr/bin/env ruby

############### CREATED ON 2017 APR 24th ###############

require 'FileUtils'

path = "D:/Test"
tag = "///"

begin
Dir.chdir(path)
rescue
	puts "Path not found! Input a legitmate path: "
	print "path< "; path = gets.chomp
	retry
end

puts "change phase"

unless Dir.exist?(tag)
	begin
		Dir.mkdir(tag)
	rescue
		puts "oh.. i caught an error.."
		sleep(1)
		2.times{print "."; sleep(1) }
		puts "\nmaybe it's the tag was not suitable as a folder name"; sleep(0.5)
		puts "so.. change it then? Current /tag/ is: '#{tag}'"; sleep(0.5)
		print "Follow the rules for naming a folder to set tag:\ntag< "
		tag = gets.chomp
		retry
	end
end

############################
puts "Moving files..."

Dir.foreach(path, :encoding => 'utf-8') { |img|
	if File.file?(img)
		if /#{tag}/ =~ img
			FileUtils.mv img, tag
			puts "Moving '#{img}'..."
		end
	end
}
