defmodule VocialWeb.PollControllerTest do
  use VocialWeb.ConnCase

  test "GET /polls", %{conn: conn} do
    poll = %{
      title: "My First Poll",
      options: [
        {"Choice 1", 0},
        {"Choice 2", 5},
        {"Choice 3", 2}
      ]
    }

    conn = get(conn, "/polls")
    assert html_response(conn, 200) =~ poll.title
    Enum.each(poll.options, fn {option, votes} ->
      assert html_response(conn, 200) =~ option
      assert html_response(conn, 200) =~ "#{votes} votes"
    end)
  end
end
