require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @alphabets = ("A".."Z").to_a
    @random_string = 10.times.map{ @alphabets[rand(9).round] }
  end

  def compute_score(attempt, start_time)
    end_time = Time.now
    time_taken = end_time - Time.parse(start_time)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def score
    @word = params[:word]
    @random_string = params[:random_string]
    @start_time = params[:start_time]
    if @word.chars.all? { |letter| @word.count(letter) <= @random_string.count(letter) }
      if english_word?(@word)
        @score = compute_score(@word, @start_time)
        @result = [@score, "well done"]
      else
        @result = [0, "not an english word"]
      end
    else
      @result = [0, "not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
