defmodule ETagTracker.PageController do
  use ETagTracker.Web, :controller
  alias ETagTracker.Visitor

  def index(conn, _params) do
    visitor = find_or_initialize_visitor(conn)

    Repo.insert_or_update(
      Visitor.changeset(visitor, %{visits: visitor.visits + 1})
    )

    conn
    |> put_resp_header("etag", visitor.token)
    |> assign(:visits, visitor.visits)
    |> render("index.html")
  end

  defp find_or_initialize_visitor(conn) do
    visitor = case get_req_header(conn, "if-none-match") do
      [value] ->
        Visitor |> Repo.get_by(token: value)
      [] ->
        nil
    end

    visitor || %Visitor{visits: 0, token: generate_token()}
  end

  defp generate_token do
    :crypto.strong_rand_bytes(32) |> Base.encode16(case: :lower)
  end
end
