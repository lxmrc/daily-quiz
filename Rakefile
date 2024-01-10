require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './app'  # Replace with the path to your main Sinatra application file

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:quiz.db')

namespace :db do
  desc "Resets the database"
  task :reset => [:drop, :setup]

  desc "Drops the database"
  task :drop do
    Rake::Task['db:drop'].invoke
  end

  desc "Sets up the database"
  task :setup do
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
