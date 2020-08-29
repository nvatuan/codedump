#!usr/bin/env ruby

############### CREATED ON 2017 FEB 27th ###############

def introduction
	puts   "## FER - File Extension Replacer  ##\n"
end

###################  Change logs  #####################
#### v1.0
#  | - Usable.
#### v1.2
#  | - Slight change to be more flexible
#  | - Improve interaction
#  | - Compacting code
#######################################################

def change_directory

=begin
			if input.include? '\\'
			#puts "Using the Backslash '\\' in Dir is not recommended."
			#puts "It's still going to work, but you should replace all Backslash '\\' with ForwardSlash '/'."
			input.length.times { |i|
				input[i-1] = '/' if input[i-1] == '\\'
				}
			end 
=end
		begin
			puts "Current working directory: " << Dir.pwd
			print "Change directory? (Leave blank if no):\ninput< "
			input = gets.chomp
			input = '.' if input.empty?
			Dir.chdir(input)
		rescue
			puts "Dir path not found! Retrying..."
			sleep(0.5)
			retry
		ensure
			input == '.' ? msg = "Current dir path preserved." : msg = "Change succeed."
			puts "#{msg} Current dir is> " + Dir.pwd
		end
	
end

def replace

	loop do
		print "Extension to replace with:\n."; seek_ext = gets.chomp
		print "Replace with:\n."; replace_ext = gets.chomp
		puts ""
	
		array_dir = Dir.entries(".")
		array_dir.collect! { |f|
			f if f[((-1*seek_ext.length)..-1)] == seek_ext
		}
		array_dir.compact!
		print "Folder contains #{array_dir.size} match(es):\n   "
		array_dir.size.times{|i| print " | #{array_dir[i-1]} "};
		print "\nAppropriated file(s) will be changed as below:\n*.#{seek_ext} => *.#{replace_ext}\n"
		print "Type 'yes' to proceed, else to redo:< "
		inp = gets.chomp
		break if inp.downcase == 'yes'

		puts "Redo..."
		sleep(0.5)
	end

	#-------------------------------------
	array_dir.length.times do |i|
		rename = array_dir[i][(0..(array_dir[i].length - seek_ext.length - 1))] << replace_ext
		File.rename(array_dir[i-1],rename)
	end

end

introduction
change_directory
replace
