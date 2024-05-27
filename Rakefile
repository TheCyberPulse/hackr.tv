require 'rake'
require 'slim'
require 'fileutils'

desc 'Generate Site'
task :generate do |t|
  puts ''
  puts '|=========================================='
  puts "| [#{Time.now.strftime("%m/%d/%Y %H:%M")}] Generating site..."
  puts '|=========================================='
  puts ''

  public_dir_name = 'public'
  public_backup_dir = "#{public_dir_name}_backup"
  content_dirs = ['pages']

  if Dir.exist?(public_dir_name)
    if Dir.exist?(public_backup_dir)
      puts '|=========================================='
      puts '| Removing public backup directory...'
      puts '|=========================================='
      puts ''
      FileUtils.rm_rf(public_backup_dir)
    end
    puts '|=========================================='
    puts '| Backing up the public directory...'
    puts '|=========================================='
    puts ''
    FileUtils.mv(public_dir_name, public_backup_dir)
  end

  Dir.mkdir public_dir_name
  FileUtils.cp_r './assets', public_dir_name

  content_dirs.each do |dir|

    puts '|=========================================='
    puts "| Processing the #{dir} directory..."
    puts '|=========================================='
    puts ''

    Dir.glob("#{dir}/**/*.slim").each do |filepath|

      context_path = filepath
        .split("#{dir}/")[1]
        .to_s
        .gsub('.slim', '')
        .gsub('/index', '')
        .gsub('index', '')

      post_content = Slim::Template.new(filepath).render || ''

      post = Slim::Template
        .new('layout/template.slim')
        .render
        .gsub('<!--~~~POST_CONTENT_PLACEHOLDER~~~-->', post_content)

      post_name_directory = "#{public_dir_name}/#{context_path}"

      unless File.directory? post_name_directory
        FileUtils.mkdir_p(post_name_directory)
      end

      File.write("#{post_name_directory}/index.html", post)
    end
  end

  puts '|=========================================='
  puts "| [#{Time.now.strftime("%m/%d/%Y %H:%M")}] Generation complete!"
  puts '|=========================================='
  puts ''

end

desc 'Run web server'
task :server do |t|
  puts '|=========================================='
  puts '| Running webrick server...'
  puts '|=========================================='
  puts ''
  sh "ruby -run -e httpd ./public -p 4567"
end

task :g => :generate
task :gen => :generate
task :s => :server
task :serve => :server
