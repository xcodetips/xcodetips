require 'erb'
include ERB::Util
require 'fileutils'
require 'yaml'

def generate_tip_page(tip, tips, output_dir_path, title = nil, output_name = nil)
  output_name ||= "#{tip['file_name']}.html"
  title ||= "#{tip['title']} | Xcode Tips"

  File.open("#{output_dir_path}/#{output_name}", 'w') do |file|
    file.write ERB.new(File.read('./template.erb')).result(binding)
  end
end

def generate_index(tip, tips, output_dir_path)
  generate_tip_page(tip, tips, output_dir_path, 'Xcode Tips', 'index.html')
end

catalog_path = ARGV[0] || './catalog.yml'

unless File.exists? catalog_path
  puts "Could not find file at #{catalog_path}"
  exit 1
end

source = YAML.load_file(catalog_path)
tips = source['tips']
drafts = source['drafts']

if tips.nil?
  puts "No input"
  exit 1
end

if tips.empty?
  puts "No tips"
  exit 2
end

tips = tips.sort_by { |tip| tip['publish_date'] || '' }.reverse

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

if drafts.nil? == false
  drafts.each do |draft_tip|
    puts "Generating draft page for #{draft_tip['title']}"
    # Notice how we're still just passing the tips array here. This is
    # intentional to avoid having the entire drafts content leaking
    generate_tip_page(draft_tip, tips, "#{output_dir_path}/tips")
  end
end
