#!/usr/bin/env ruby

require "transit/version"
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

module Transit

  # Path constants
  WORK_PATH = Dir.pwd.freeze
  TRANSIT_HOME = File.realpath(File.join(File.dirname(__FILE__), '..')).freeze
  CONFIGS_PATH = File.join(TRANSIT_HOME, 'configs').freeze

  class << self
     attr_accessor :total
  end

  self.total = { 'files' => 0, 'lines' => 0, 'lines_cyr' => 0 }

  class Runit
    include Transit

    String.send(:include, Colors)

    def initialize(argv=nil)

      config_file = File.join(Transit::WORK_PATH, '.transit.yaml')

      config_file = File.join(Transit::CONFIGS_PATH, 'default.yaml') unless File.file?(config_file)

      if !argv.nil? && argv[0] == "-c" && argv[1]
        config_file = File.expand_path(argv[1])
        unless File.file?(config_file)
          puts "Config not found!".red
          puts "Usage:"
          puts "#{File.basename(__FILE__)} -c <config_name>.yaml"
          exit 1
        end
      end

      if File.file? config_file
        config = YAML.load_file(config_file)
      else
        puts "Please create valid config file. Read: (https://github.com/dealer-point/transit)"
        exit 1
      end

      paths = config['include']
      excludes = config['exclude'] || []

      if paths.nil?
        puts "Wrong params. Please modify config file. Read: (https://github.com/dealer-point/transit)"
        exit 1
      end

      scan_paths(paths, excludes)

    end

  private

    # Scan Cyrillic in file
    def scan_file(path)
      begin
        Transit.total["files"] += 1
        line_num = 1
        lines_cyr = 0

        File.open(path, "r") do |infile|
          infile.each_line do |line|
            if start_idx = line.index(/\p{Cyrillic}/u)
              end_idx = line.index(/[[:space:]]/, start_idx) || start_idx + 12 # если нет пробела, то не больше 12 символов
              puts "#{path.green}:#{line_num.to_s.brown}:#{start_idx.to_s.brown} \t\"#{line[start_idx, end_idx - start_idx]}\""
              lines_cyr += 1
            end
            line_num += 1
          end
        end

        Transit.total["lines"] += line_num
        Transit.total["lines_cyr"] += lines_cyr

      rescue => err
        puts "Exception: #{err}"
        err
      end
    end

    # Scan
    def scan_paths(paths, excludes)
      file_path = Dir.glob(paths) - Dir.glob(excludes)
      file_path.each do |path|

        if File.file? path
          scan_file path
        elsif File.directory?(path)
        else
          # wildcard
          scan_file WORK_PATH + path
        end

      end
    end

  end

end
