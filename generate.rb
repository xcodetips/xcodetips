require 'erb'
require 'yaml'

def generate_tip_page(tip, tips, output_dir_path, output_name = nil)
  puts "Generating page for #{tip['title']}"
  
  output_name ||= "#{tip['file_name']}.html"

  File.open("#{output_dir_path}/#{output_name}", 'w') do |file|
    file.write ERB.new(File.read('./template.erb')).result(binding)
  end
end

def generate_index(tip, tips, output_dir_path)
  puts "Generating index using #{tip['title']}"

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

output_dir_path = "build_#{Time.now.getutc.to_i}"
`mkdir #{output_dir_path}`
`mkdir #{output_dir_path}/tips`

generate_index(tips.first, tips, output_dir_path)
tips.each { |tip| generate_tip_page(tip, tips, "#{output_dir_path}/tips") }
