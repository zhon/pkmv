require "pkmv/version"

require 'pkmv/date_to_dirname'

require 'exif'
require 'yaml'
require 'fileutils'

module Pkmv

  FileUtils = FileUtils::DryRun

  INPUT_DIRECTORY = '/Volumes/M16/X-T1_Backup/XT-2/'
  OUTPUT_DIRECTORY = './'

  def self.filename_to_output_directory(input_filename, output_dir_base)
    dirname = nil
    begin
      data = Exif::Data.new(input_filename)
      dirname = Pkmv.date_to_dirname(data.date_time)
    rescue=>e
      puts "#{input_filename} has no EXIF data or is not readable"
      dirname = Pkmv.date_to_dirname(File.ctime input_filename)
    end
    File.join(dirname, File.extname(input_filename)[1..-1].downcase)
  end

  Dir.glob(File.join INPUT_DIRECTORY, '**', '*.*').each do |filename|
    next if File.directory?(filename)

    new_dir = filename_to_output_directory(filename, OUTPUT_DIRECTORY)

  end

  require 'set'
  class FileCopier

    def initialize
      @dir_created = Set.new
    end

    def cp(filename, new_dir)
      unless @dir_created.include? new_dir
        @dir_created.add new_dir
        FileUtils.mkdir_p new_dir
      end
      FileUtils.cp filename, new_dir
    end
  end



  # take an input directory
  # take an output directory
  # parse picture file to get shot date
  # mkdir_p to create date directory
  # move image file into output/date directory
  # move jpg to output/date/jpg directory

end