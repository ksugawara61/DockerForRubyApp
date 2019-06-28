# coding: utf-8
app_root = File.expand_path('../../', __FILE__)

ENV['BUNDLE_GEMFILE'] = app_root + "/Gemfile"

worker_processes 2

working_directory app_root

timeout 300

stdout_path '/var/log/unicorn/stdout.log'
stderr_path '/var/log/unicorn/stderr.log'

listen '/var/sock/unicorn.sock'
pid '/var/run/unicorn.pid'

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
