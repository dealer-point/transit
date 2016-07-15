#!/usr/bin/env ruby

require "yaml"

config_file = ".transit.yaml"

puts "Tranist search russian letters in files"

if ARGV[0] == "-c"
  if ARGV[1] && File.file?(ARGV[1])
    config_file = ARGV[1]
  else
    puts "Usage:"
    puts "#{__FILE__} -c <config name>.yaml"

    exit
  end
end

CONFIG = YAML.load_file(config_file)

paths = CONFIG['include']
exclude = CONFIG['exclude']

def scan_file(path)
  begin
    line_num = 1
    File.open(path, "r") do |infile|
      while (line = infile.gets)
        if start_idx = line.index(/\p{Cyrillic}/)
          end_idx = line.index(' ', start_idx)
          puts "#{line_num}: start at #{start_idx} \"#{line[start_idx, end_idx - start_idx]}\"..."
        end
        line_num = line_num + 1
      end
    end
  rescue => err
    puts "Exception: #{err}"
    err
  end
end

def exclude_path?(path, exclude)
  exclude.each do |regs|
    return true if File.fnmatch(regs, path, File::FNM_PATHNAME | File::FNM_DOTMATCH)
  end
  false
end

def rscan_dir(root_path, exclude)
  if File.directory?(root_path)
    Dir.foreach root_path do |path|
      unless path == '.' || path == '..'
        next_path = "#{root_path}/#{path}"

        if File.directory?(next_path)
          rscan_dir(next_path, exclude) unless path == '.' || path == '..'
        else
          unless exclude_path? next_path, exclude
            puts "File: #{next_path}"
            scan_file next_path
          end
        end
      end
    end
  elsif File.file? root_path
    puts "File: #{root_path}"
    scan_file root_path
  end
end

paths.each { |path| rscan_dir(path, exclude) }
