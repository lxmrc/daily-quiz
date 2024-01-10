require 'sinatra/activerecord'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'quiz.db')

class Question < ActiveRecord::Base
end
