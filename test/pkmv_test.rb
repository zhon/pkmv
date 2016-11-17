require 'test_helper'

class PkmvTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Pkmv::VERSION
  end

end

require 'time'

module Pkmv

  describe Pkmv do

    describe 'date_to_dirname' do

      describe 'on invalid date' do

        it "raises exception" do
          skip
          date = ''
          err = -> { Pkmv.date_to_dirname(date) }.must_raise ArgumentError
          err.message.must_equal "'#{date}' is not a valid date"
        end

      end

      describe 'with valid date' do

        it "2016/11/01" do
          date = Time.parse "2016/11/01"
          Pkmv.date_to_dirname(date).must_equal "2016-11-01"
        end

        it "2016-10-29 17:05:04 -0600" do
          date = Time.parse "2016-10-29 17:05:04 -0600"
          Pkmv.date_to_dirname(date).must_equal "2016-10-29"
        end
      end

    end

  end

  describe Pkmv::ImageRelocator do

    describe 'initalization' do

      it 'raises if output directory doesnt exist' do
        input_dir = './'
        output_dir = 'not a directory'

        err = -> { ImageRelocator.new(input_dir, output_dir) }.must_raise ArgumentError
        err.message.must_equal "Output directory (#{output_dir}) doesn't exist."
      end

    end

  end
end
