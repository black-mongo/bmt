defmodule BmtAdminWeb.DashBoardComponent do
  @moduledoc false
  use Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
     <p><%= @users %>!</p>
    """
  end
  def update(_assigns, socket) do
    {:ok, assign(socket,:users, 10)}
  end
end
