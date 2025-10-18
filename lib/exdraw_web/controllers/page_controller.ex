defmodule ExdrawWeb.PageController do
  use ExdrawWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
