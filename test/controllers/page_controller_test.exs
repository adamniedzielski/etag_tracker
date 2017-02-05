defmodule ETagTracker.PageControllerTest do
  use ETagTracker.ConnCase

  test "new visitor", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Number of previous visits: 0"

    assert Repo.aggregate(ETagTracker.Visitor, :count, :id) == 1

    visitor = Repo.one!(ETagTracker.Visitor)
    etag = get_resp_header(conn, "etag") |> List.first

    assert visitor.token == etag
    assert visitor.visits == 1
  end

  test "wrong ETag", %{conn: conn} do
    conn = put_req_header(conn, "if-none-match", "wrong")
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Number of previous visits: 0"
  end

  test "returning visitor", %{conn: conn} do
    conn = put_req_header(conn, "if-none-match", "my_etag")
    Repo.insert(%ETagTracker.Visitor{visits: 7, token: "my_etag"})

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Number of previous visits: 7"

    visitor = Repo.one!(ETagTracker.Visitor)
    assert visitor.visits == 8
  end
end
