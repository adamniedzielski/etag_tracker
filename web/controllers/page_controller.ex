defmodule ETagTracker.PageController do
  use ETagTracker.Web, :controller
  alias ETagTracker.Visitor

  def index(conn, _params) do
    visitor = case get_req_header(conn, "if-none-match") do
      [value] ->
        Visitor |> Repo.get_by(token: value)
      [] ->
        nil
    end

    case visitor do
      nil ->
        visitor = %Visitor{visits: 0, token: generate_token}
      _ ->
    end

    visits = visitor.visits

    Repo.insert_or_update(Visitor.changeset(visitor, %{visits: visits + 1}))

    conn
    |> put_resp_header("etag", visitor.token)
    |> assign(:visits, visits)
    |> render("index.html")
  end

  defp generate_token do
    :crypto.strong_rand_bytes(32) |> Base.encode16(case: :lower)
  end
end
