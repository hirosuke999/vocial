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
end
