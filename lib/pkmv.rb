require "pkmv/version"

require 'pkmv/date_to_dirname'

require 'exif'
require 'yaml'
require 'fileutils'

module Pkmv

  INPUT_DIRECTORY = '/Volumes/M16/X-T1_Backup/XT-2/'
  OUTPUT_DIRECTORY = './'

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

    def initialize(input=INPUT_DIRECTORY,
                   output_base=OUTPUT_DIRECTORY)
      @input = input
      @output_base = output_base
    end

    def relocate
      fc = FileCopier.new
      jpg_files = Dir.glob(File.join @input, '**', '*.JPG')
      relocate_files(fc, jpg_files)
      notify_jpeg_completion(jpg_files.count)
      other_files = Dir.glob(File.join @input, '**', '*.[^J][^P][^G]')
      relocate_files(fc, other_files)
    end

    def relocate_files(fc, files)
      files.each do |filename|
        relocate_file(fc, filename)
      end
    end

    def relocate_file(fc, filename)
      new_dir = output_file_path(filename, @output_base)
      fc.cp filename, new_dir
    end

    def notify_jpeg_completion(count)
      sound_thread = Thread.new {
        `say "Finished #{
          count.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        } JPEGs."`
      }
    end

    def output_file_path(input_filename, output_dir_base)
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

  end

end
