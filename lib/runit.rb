#!/usr/bin/env ruby

require "runit/version"
require "yaml"

module Colors

  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end

end

module Runit

  # Path constants
  RUNIT_HOME = File.realpath(File.join(File.dirname(__FILE__), '..')).freeze
  CONFIGS_PATH = File.join(RUNIT_HOME, 'configs').freeze


  class Transit
    include Runit

    String.send(:include, Colors)

    def initialize(argv=nil)

      puts "Tranist - search line in source files with russian letters "

      config_file = File.join(Runit::CONFIGS_PATH, 'default.yaml')

      if !argv.nil? && argv[0] == "-c"
        if argv[1] && File.file?(File.join(Runit::CONFIGS_PATH, argv[1]))
          config_file = argv[1]
        else
          puts "Config not found!".red
          puts "Usage:"
          puts "#{__FILE__} -c <config name>.yaml"
          exit
        end
      end

      if File.file? config_file
        config = YAML.load_file(config_file)
      else
        puts "Please create valid config file. Read: (https://github.com/dealer-point/transit)"
        exit
      end

      paths = config['include']
      exclude = config['exclude']

      if paths.nil? || exclude.nil?
        puts "Wrong params. Please modify config file. Read: (https://github.com/dealer-point/transit)"
        exit
      end

      paths.each { |path| rscan_dir(path, exclude) }

    end

  private

    # scan Cyrillic in file
    def scan_file(path)
      begin
        line_num = 1
        File.open(path, "r") do |infile|
          infile.each_line do |line|
            if start_idx = line.index(/\p{Cyrillic}/u)
              end_idx = line.index(' ', start_idx) || start_idx + 12 # если нет пробела, то не больше 12 символов
              puts "#{path.green}:#{line_num.to_s.brown}:#{start_idx.to_s.brown} \t\"#{line[start_idx, end_idx - start_idx]}\"".gray
            end
            line_num += 1
          end
        end
      rescue => err
        puts "Exception: #{err}"
        err
      end
    end

    def exclude_regs?(path, exclude)
      exclude.each do |regs|
        return true if File.fnmatch(regs, path, File::FNM_PATHNAME || File::FNM_DOTMATCH)
      end
      false
    end

    # recursive scan dirs
    def rscan_dir(root_path, exclude)
      if File.directory?(root_path)
        Dir.foreach root_path do |path|
          unless path == '.' || path == '..'
            next_path = "#{root_path}/#{path}"

            if File.directory?(next_path)
              rscan_dir(next_path, exclude) unless path == '.' || path == '..'
            else
              unless exclude_regs?(next_path, exclude)
                scan_file next_path
              end
            end
          end
        end
      elsif File.file? root_path
        scan_file root_path
      end
    end


  end

end