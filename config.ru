# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

# Unicorn worker_killer config
if ENV['RAILS_ENV'] == 'production'
  require 'unicorn/worker_killer'
  CHECK_CYCLE = 16
  # use Unicorn::WorkerKiller::MaxRequests, 3072, 4096
  use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))
end
