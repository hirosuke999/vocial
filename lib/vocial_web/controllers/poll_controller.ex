defmodule VocialWeb.PollController do
  use VocialWeb, :controller

  alias Vocial.Votes

  def index(conn, _params) do
    polls = Votes.list_polls()
    render(conn, "index.html", polls: polls)
  end

  def new(conn, _params) do
    poll = Votes.new_poll()
    render(conn, "new.html", poll: poll)
  end

  def create(conn, %{"poll" => poll_params, "options" => options}) do
    split_options = String.split(options, ",")

    with user <- get_session(conn, :user),
         poll_params <- Map.put(poll_params, "user_id", user.id),
         {:ok, _poll} <- Votes.create_poll_with_options(poll_params, split_options) do
      conn
      |> put_flash(:info, "Poll created successfully!")
      |> redirect(to: Routes.poll_path(conn, :index))
    else
      {:error, _} ->
        conn
        |> put_flash(:alert, "Error creating Poll!")
        |> redirect(to: Routes.poll_path(conn, :new))
    end
  end
end
