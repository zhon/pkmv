require "pkmv/version"

require 'exif'
require 'fileutils'

module Pkmv

  #FileUtils = FileUtils::DryRun
  #
  #System "sudo umount #{INPUT_DIRECTORY}"

  def self.date_to_dirname date
    date.strftime("%Y-%m-%d")
  end

  require 'set'
  class FileCopier

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

    def initialize(input,
                   output_base)
      raise ArgumentError.new("Output directory (#{output_base}) doesn't exist.") unless File.directory? output_base
      raise ArgumentError.new("Input directory (#{input}) doesn't exist.") unless File.directory? input
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
      File.join(output_dir_base, File.extname(input_filename)[1..-1].downcase, dirname)
    end

  end

end
