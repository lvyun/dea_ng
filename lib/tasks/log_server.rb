desc "Install/run log server for tests"
namespace :log_server do
  ROOT = File.expand_path("../../..", __FILE__)
  LOG_SERVER_BRANCH = "public-logplex"
  LOG_SERVER_REPO = "git@github.com:cloudfoundry/logplex.git"

  desc "Run log server for integration tests"
  task :run => [:install] do
    Dir.chdir(log_server_dir) do
      system "source keys.sh && bin/logplex"
    end
  end

  desc "Install log server for integration tests"
  task :install do
    fetch_log_server
    build_log_server
  end

  def fetch_log_server
    unless Dir.exists?(log_server_dir)
      system "git clone #{LOG_SERVER_REPO} #{log_server_dir} --depth 1"
    end

    Dir.chdir(log_server_dir) do
      system "git fetch origin #{LOG_SERVER_BRANCH}"
      system "git checkout origin/#{LOG_SERVER_BRANCH}"
    end
  end

  def build_log_server
    Dir.chdir(log_server_dir) do
      system "./rebar --config public.rebar.config get-deps compile"
    end
  end

  def log_server_dir
    "#{ROOT}/tmp/log-server"
  end
end