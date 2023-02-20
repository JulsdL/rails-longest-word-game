require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # generate random grid of letters
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
    @letters
  end

  def score
    @attempt = params[:attempt].strip
    letters = params[:letters].split
    start_time = Time.now
    end_time = Time.now
    @result = {}
    @attempt.upcase.chars.each do |character|
      index = letters.index(character)
      if index.nil?
        @result[:time] = end_time - start_time
        @result[:score] = 0
        @result[:message] = "Sorry but #{@attempt} can't be built out of #{letters.join('')}"
        return @result
      else
        letters.delete_at(index)
      end
      url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
      test_serialized = URI.open(url).read
      test = JSON.parse(test_serialized)
      @result[:time] = end_time - start_time
      if test['found']
        @result[:score] = @attempt.length.fdiv(end_time - start_time)
        @result[:message] = "Congratulations! #{@attempt.upcase} is a valid English word!"
      else
        @result[:score] = 0
        @result[:message] = "Sorry but #{@attempt.upcase} does not seem to be a valid English word..."
      end
    end
    @result
  end
end
