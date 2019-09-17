defmodule VocialWeb.PollControllerTest do
  use VocialWeb.ConnCase

  alias Vocial.Votes

  setup do
    conn = build_conn()

    {:ok, user} =
      Vocial.Accounts.create_user(%{
        username: "test",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test"
      })

    {:ok, poll} =
      Votes.create_poll_with_options(
        %{"title" => "My New Test Poll", "user_id" => user.id},
        ["One", "Two", "Three"]
      )

    {:ok, conn: conn, user: user, poll: poll}
  end

  defp login(conn, user) do
    conn |> post("/sessions", %{username: user.username, password: user.password})
  end

  test "GET /polls", %{conn: conn, user: user} do
    {:ok, poll} =
      Votes.create_poll_with_options(%{title: "Poll 1", user_id: user.id}, [
        "Choice 1",
        "Choice 2",
        "Choice 3"
      ])

    conn = get(conn, "/polls")
    assert html_response(conn, 200) =~ poll.title

    Enum.each(poll.options, fn option ->
      assert html_response(conn, 200) =~ "#{option.title}"
      assert html_response(conn, 200) =~ "#{option.votes}"
    end)
  end

  test "GET /polls/new", %{conn: conn, user: user} do
    conn = conn |> login(user) |> get("/polls/new")
    assert html_response(conn, 200) =~ "New Poll"
  end

  test "POST /polls (with valid data)", %{conn: conn, user: user} do
    conn =
      conn
      |> login(user)
      |> post("/polls", %{"poll" => %{"title" => "Test Poll"}, "options" => "One,Two,Three"})

    assert redirected_to(conn) == "/polls"
  end

  test "POST /polls (with invalid data)", %{conn: conn, user: user} do
    conn =
      conn
      |> login(user)
      |> post("/polls", %{"poll" => %{"title" => nil}, "options" => "One,Two,Three"})

    assert html_response(conn, 302)
    assert redirected_to(conn) == "/polls/new"
  end

  test "GET /options/:id/vote", %{conn: conn, poll: poll} do
    option = Enum.at(poll.options, 0)
    before_votes = option.votes
    conn = get(conn, "/options/#{option.id}/vote")
    after_option = Vocial.Repo.get!(Vocial.Votes.Option, option.id)

    assert html_response(conn, 302)
    assert redirected_to(conn) == "/polls"
    assert after_option.votes == before_votes + 1
  end

  test "GET /polls/:id", %{conn: conn, poll: poll} do
    conn = get(conn, "/polls/#{poll.id}")
    assert html_response(conn, 200) =~ poll.title
  end
end
