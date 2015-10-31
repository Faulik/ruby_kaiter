namespace :bootstrap do
  desc 'Create and populate db'
  task setup: [:environment] do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['populate:all'].invoke
  end
end
