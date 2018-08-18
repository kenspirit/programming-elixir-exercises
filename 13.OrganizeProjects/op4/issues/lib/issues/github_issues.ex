defmodule Issues.GithubIssues do
  require Logger

  @user_agent [ { "User-agent", "Elixir chengusky@gmail.com" } ]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info fn -> "Fetching #{user}' project #{project}" end

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({ :ok, %{ status_code: status_code, body: body } }) do
    Logger.info("Got response: status code = #{status_code}")
    Logger.debug(fn -> inspect(body) end)
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!(%{})
    }
  end

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error
end
