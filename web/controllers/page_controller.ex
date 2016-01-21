defmodule Segfault.PageController do
  use Segfault.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
