defmodule VocialWeb.PollController do
  use VocialWeb, :controller

  def index(conn, _params) do
    poll = %{
      title: "My First Poll",
      options: [
        {"Choice 1", 0},
        {"Choice 2", 5},
        {"Choice 3", 2},
      ]
    }

    conn
    |> put_layout(:special)
    |> render("index.html", poll: poll)
  end
end
