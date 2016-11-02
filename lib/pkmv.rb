require "pkmv/version"

require 'pkmv/date_to_dirname'

require 'exif'
require 'yaml'
require 'fileutils'

module Pkmv


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

  require 'set'
  class FileCopier
    FileUtils = FileUtils::DryRun

    def initialize
      @dir_created = Set.new
    end

    def cp(filename, new_dir)
      unless @dir_created.include? new_dir
        FileUtils.mkdir_p new_dir
        @dir_created.add new_dir
      end
      FileUtils.cp filename, new_dir
    end
  end

  class ImageRelocator

    def relocate
      fc = FileCopier.new

      files = Dir.glob(File.join INPUT_DIRECTORY, '**', '*.JPG')

      files.each do |filename|
        new_dir = Pkmv.filename_to_output_directory(filename, OUTPUT_DIRECTORY)
        fc.cp filename, new_dir
      end

      sound_thread = Thread.new {
        `say "Finished #{
      files.size.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        } JPEGs."`
      }

      # total files 2,613

      jpg_file_count = files.size

      files = Dir.glob(File.join INPUT_DIRECTORY, '**', '*.[^J][^P][^G]')
      files.each do |filename|
        new_dir = Pkmv.filename_to_output_directory(filename, OUTPUT_DIRECTORY)
        fc.cp filename, new_dir
      end

      other_file_count = files.size

      puts jpg_file_count + other_file_count

      sound_thread.join
    end

  end

  ImageRelocator.new.relocate


  # take an input directory
  # take an output directory
  # parse picture file to get shot date
  # mkdir_p to create date directory
  # move image file into output/date directory
  # move jpg to output/date/jpg directory

end
