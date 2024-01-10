require 'sinatra'
require 'sinatra/activerecord'
require 'net/http'
require 'json'
require './models'

set :database, {adapter: 'sqlite3', database: 'quiz.db'}

before do
  prepare_questions if Question.where(date: Date.today).empty?
end

get '/' do
  @questions = Question.where(date: Date.today)
  erb :index
end

post '/submit' do
  @responses = params.select { |k, _| k.start_with?("answer_") }
  @questions = Question.where(id: @responses.keys.map { |k| k.split('_').last.to_i })

  @results = @questions.each_with_object({}) do |question, memo|
    user_answer = @responses["answer_#{question.id}"]
    memo[question.id] = {
      question: question.question,
      user_answer: user_answer,
      correct_answer: question.answer,
      is_correct: user_answer.strip.downcase == question.answer.downcase
    }
  end

  erb :results
end

def prepare_questions
  uri = URI('https://the-trivia-api.com/api/questions?limit=20')
  response = Net::HTTP.get(uri)
  fetched_questions = JSON.parse(response)

  fetched_questions.each do |q|
    Question.create(
      question: q['question'],
      answer: q['correctAnswer'],
      option1: q['incorrectAnswers'][0],
      option2: q['incorrectAnswers'][1],
      option3: q['incorrectAnswers'][2],
      date: Date.today
    )
  end
end
