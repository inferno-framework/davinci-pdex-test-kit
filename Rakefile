begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError # rubocop:disable Lint/SuppressedException
end

namespace :db do
  desc 'Apply changes to the database'
  task :migrate do
    require 'inferno/config/application'
    require 'inferno/utils/migration'
    Inferno::Utils::Migration.new.run
  end
end

namespace :pdex do
  namespace :payer_server do

    desc 'Generate PDex Server read and search API tests'
    task :generate do
      require_relative 'lib/davinci_pdex_test_kit/pdex_payer_server/generator'

      DaVinciPDexTestKit::PDexPayerServer::Generator.generate
    end
  end
end
