
require 'pkmv/date_to_dirname'
require 'test_helper'

module Pkmv

  describe Pkmv do

    describe 'date_to_dirname' do

      describe 'on invalid date' do

        it "raises exception" do
          skip
          date = Time.parse 'not a valid date'
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
end
