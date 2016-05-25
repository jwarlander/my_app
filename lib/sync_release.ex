defmodule :sync_release do
  def seed do
    repo = MyApp.Repo
    start_repo(repo)
    info "Seeding data for #{inspect repo}.."

    #seed
    
    :init.stop()
  end

  def migrate do
    repo = MyApp.Repo
    start_repo(repo)

    path = Application.app_dir(:my_app, "priv/repo/migrations")
    Ecto.Migrator.run(MyApp.Repo, path, :up, all: true)

    :init.stop()
  end

  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {_ , message } = Application.ensure_all_started(app)
      info "Start application #{inspect app} got message: #{inspect message}"
    end)
  end

  defp start_repo(repo) do
    load_app()
    info "Start Repo"
    message = repo.start_link()
    info(inspect message)
  end

  defp load_app do
    start_applications([:logger, :postgrex, :ecto])
    info "Loading App"
    :ok = Application.load(:my_app)
  end

  defp info(message) do
    IO.puts(message)
  end

  defp fatal(message) do
    IO.puts :stderr, message
    System.halt(1)
  end
end
