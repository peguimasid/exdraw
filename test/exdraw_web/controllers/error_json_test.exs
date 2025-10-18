defmodule ExdrawWeb.ErrorJSONTest do
  use ExdrawWeb.ConnCase, async: true

  test "renders 404" do
    assert ExdrawWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ExdrawWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
