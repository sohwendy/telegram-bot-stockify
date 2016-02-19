job_type :rake, "cd :path && rake ':task' :output"
set :output, error: 'tmp/cron_error_log.log', standard: 'tmp/cron_log.log'

every :weekday, at: '9:05 am' do
  rake 'bot:push'
end
