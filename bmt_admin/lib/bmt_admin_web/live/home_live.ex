defmodule BmtAdminWeb.HomeLive do
  @moduledoc false
  use BmtAdminWeb, :live_view
  alias BmtAdminWeb.DashBoardComponent
  alias BmtAdminWeb.AccountsComponent
  alias BmtAdmin.Accounts
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
      <.live_component module={AccountsComponent} id="accounts" items={@items} page_title={@page_title} live_action={@live_action}/>
   """
  end
  def render(_, assigns) do
    ~H"""
    <div> <p> Hello, I'm Home </p> </div>
  """
  end
  def mount(%{"side_flag" => side_flag}, _sessions, socket) do
    {:ok, update_current_side_flag(String.to_atom(side_flag), socket)}
  end
  def mount(_, _sessions, socket) do
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
  def handle_params(%{"side_flag" => side_flag}, _, socket) do
    {:noreply, update_current_side_flag(String.to_atom(side_flag), socket)}
  end
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end
  def update_current_side_flag(:accounts, socket) do
    assign(socket, :items, Accounts.list_items())
    |> assign(:page_title, "List Items")
    |> assign(:live_action, :index)
    |> assign(:side_flag, :accounts)
  end
  def update_current_side_flag(flag, socket) do
      assign(socket, :side_flag, flag)
  end
  def handle_info({BmtAdminWeb.ItemLive.FormComponent, {:saved, item}}, socket) do
    {:noreply, assign(socket, :item, item)}
  end
end
