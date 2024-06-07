require 'fileutils'
require 'rake'
require 'slim'

desc 'Generate Site'
task :generate do |t|
  puts ''
  puts '|=========================================='
  puts "| [#{Time.now.strftime("%m/%d/%Y %H:%M")}] Generating site..."
  puts '|=========================================='
  puts ''

  public_dir_name = 'public'
  public_backup_dir = "#{public_dir_name}_backup"
  content_dirs = ['pages', 'redirects']

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

  page_template = Slim::Template.new('layout/template.slim').render
  redirect_template = File.read('layout/redirect.php')

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

      post = page_template
        .gsub('<!--~~~POST_CONTENT_PLACEHOLDER~~~-->', post_content)

      post_name_directory = "#{public_dir_name}/#{context_path}"

      unless File.directory? post_name_directory
        FileUtils.mkdir_p(post_name_directory)
      end

      File.write("#{post_name_directory}/index.html", post)
    end

    Dir.glob("#{dir}/**/*.redirect").each do |filepath|

      context_path = filepath
        .split("#{dir}/")[1]
        .to_s
        .gsub('.redirect', '')


      redirect_content = File.read(filepath)

      # The second gsub is to prevent an unwanted newline.
      redirect = redirect_template
        .gsub('<~~~REDIRECT_URL~~~>', redirect_content)
        .gsub("\n\"",'"')

      redirect_name_directory = "#{public_dir_name}/#{context_path}"

      unless File.directory? redirect_name_directory
        FileUtils.mkdir_p(redirect_name_directory)
      end

      File.write("#{redirect_name_directory}/index.php", redirect)
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
