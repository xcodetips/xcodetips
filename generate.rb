require 'erb'
include ERB::Util
require 'fileutils'
require 'yaml'

def generate_tip_page(tip, tips, output_dir_path, output_name = nil)
  output_name ||= "#{tip['file_name']}.html"

  File.open("#{output_dir_path}/#{output_name}", 'w') do |file|
    file.write ERB.new(File.read('./template.erb')).result(binding)
  end
end

def generate_index(tip, tips, output_dir_path)
  generate_tip_page(tip, tips, output_dir_path, 'index.html')
end

tips = YAML.load_file('./catalog.yml')['tips']

if tips.nil?
  puts "No input"
  exit 1
end

if tips.empty?
  puts "No tips"
  exit 2
end

output_dir_path = "build"

FileUtils.remove_dir output_dir_path if File.exists? output_dir_path

FileUtils.mkdir output_dir_path
FileUtils.mkdir "#{output_dir_path}/tips"

tips.each do |tip|
  puts "Generating page for #{tip['title']}"
  generate_tip_page(tip, tips, "#{output_dir_path}/tips")
end

puts "Generating index using #{tips.first['title']}"
generate_index(tips.first, tips, output_dir_path)
