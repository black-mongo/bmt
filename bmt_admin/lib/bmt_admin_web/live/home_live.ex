defmodule BmtAdminWeb.HomeLive do
  @moduledoc false
  use BmtAdminWeb, :live_view
  alias BmtAdminWeb.DashBoardComponent
  alias BmtAdminWeb.AccountsComponent
  def render(assigns) do
    render(assigns[:side_flag], assigns)
  end
  def render(:dashboard,assigns) do
      ~H"""
      <.live_component module={DashBoardComponent} id="dashboard"/>
      """
  end
  def render(:accounts, assigns) do
   ~H"""
      <.live_component module={AccountsComponent} id="accounts"/>
   """
  end
  def render(_, assigns) do
    ~H"""
    <div> <p> Hello, I'm Home </p> </div>
  """
  end
  def mount(_params, _sessions, socket) do
    {:ok, update_current_side_flag(:dashboard, socket)}
  end
  def handle_event("dashboard", params, socket) do
    {:noreply, update_current_side_flag(:dashboard, socket)}
  end
  def handle_event("accounts", params, socket) do
    {:noreply, update_current_side_flag(:accounts, socket)}
  end
  def handle_event("logs", params, socket) do
    {:noreply, update_current_side_flag(:logs, socket)}
  end
  def handle_event("privacy", params, socket) do
    {:noreply, update_current_side_flag(:privacy, socket)}
  end
  def update_current_side_flag(flag, socket) do
      assign(socket, :side_flag, flag)
  end
end
