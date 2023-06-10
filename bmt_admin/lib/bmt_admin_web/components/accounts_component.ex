defmodule BmtAdminWeb.AccountsComponent do
  @moduledoc false
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
   <p> I'm accounts </p>
  """
  end
  def update(_assigns, socket) do
    {:ok, socket}
  end
end
