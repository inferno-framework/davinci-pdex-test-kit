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
  # TODO: namespace payer server as well?
  # namespace :payer_server do

    desc 'Generate PDex payer server tests'
    task :generate do
      require_relative 'lib/davinci_pdex_test_kit/pdex_payer_server_suite'

      DaVinciPDexTestKit::Generator.generate
    end

  # end
end
