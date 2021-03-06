# frozen_string_literal: true

require './init.rb'
require 'rake/testtask'

# Print current RACK_ENV it's using
puts "Environment: #{ENV['RACK_ENV'] || 'development'}"

task :default do
  puts `rake -T`
end

Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

namespace :run do
  task :dev do
    sh 'rerun "rackup -p 9292"'
  end

  task :test do
    loop do
      puts 'Setting up test environment'
      ENV['RACK_ENV'] = 'test'
      Rake::Task['db:_setup'].execute
      Rake::Task['db:reset'].execute
      puts 'Populating test database'
      EXISTS_SEARCH = 'love'
      LoadSongFromSpotify.call(EXISTS_SEARCH)
      sh 'rerun "rackup -p 3000"'
    end
  end
end

namespace :db do
  task :_setup do
    require 'sequel'
    require_relative 'init'
    Sequel.extension :migration
  end

  desc 'Run database migrations'
  task migrate: [:_setup] do
    puts "Migrating to latest for: #{ENV['RACK_ENV'] || 'development'}"
    Sequel::Migrator.run(DB, 'db/migrations')
  end

  desc 'Reset migrations (full rollback and migration)'
  task reset: [:_setup] do
    Sequel::Migrator.run(DB, 'db/migrations', target: 0)
    Sequel::Migrator.run(DB, 'db/migrations')
  end
end

desc 'delete cassette fixtures'
task :wipe do
  sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
    puts(ok ? 'Cassettes deleted' : 'No casseettes found')
  end
end

namespace :quality do
  CODE = 'app.rb'

  desc 'run all quality checks'
  task all: %i[rubocop flog flay]

  task :flog do
    sh "flog #{CODE}"
  end

  task :flay do
    sh "flay #{CODE}"
  end

  task :rubocop do
    sh 'rubocop'
  end
end

namespace :crypto do
  desc 'Create sample cryptographic key for database'
  task :db_key do
    puts "DB_KEY: #{SecureDB.generate_key}"
  end
end
