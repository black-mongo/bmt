defmodule BmtAdminWeb.AccountsComponent do
  @moduledoc false
  use BmtAdminWeb, :live_component
  alias BmtAdmin.Accounts
  alias BmtAdmin.Accounts.Item
  @impl true
  def render(assigns) do
    ~H"""
    <div>
<.header>
  Listing Items
  <:actions>
    <.link phx-click={JS.push("item_new", value: %{})} phx-target={@myself}>
      <.button>New Item</.button>
    </.link>
  </:actions>
</.header>

<.table
  id="items"
  rows={@items}
  row_target={@myself}
  row_click={fn item -> "#{item.id}" end}
>
  <:col :let={item} label="Name"><%= item.name %></:col>
  <:col :let={item} label="Password"><%= item.password %></:col>
  <:col :let={item} label="Desc"><%= item.desc %></:col>
  <:action :let={item}>
    <div class="sr-only">
      <.link navigate={~p"/items/#{item}"}>Show</.link>
    </div>
    <.link phx-click={JS.push("item_edit", value: %{id: item.id})} phx-target={@myself}>Edit</.link>
  </:action>
  <:action :let={item}>
    <.link
      phx-target={@myself}
      phx-click={JS.push("item_delete", value: %{id: item.id}) |> hide("##{item.id}")}
      data-confirm="Are you sure?"
    >
      Delete
    </.link>
  </:action>
</.table>

<.modal :if={@live_action in [:new, :edit]} id="item-modal" show on_cancel={JS.patch(~p"/home/accounts")}>
  <.live_component
    module={BmtAdminWeb.ItemLive.FormComponent}
    id={@item.id || :new}
    title={@page_title}
    action={@live_action}
    item={@item}
    patch={~p"/items"}
  />
</.modal>
      </div>
    """
  end
  def update(%{:items => items, :live_action => live_action, :page_title => page_title}, socket) do
    {:ok, assign(socket, :items, items) |>
    assign(:live_action, live_action) |>
    assign(:page_title, page_title)}
  end
  def handle_event("item_delete", %{"id" => item_id}, socket) do
    item = Accounts.get_item!(item_id)
    {:ok, _} = Accounts.delete_item(item)
    {:noreply,
         socket
         |> put_flash(:info, "Item deleted successfully")
         |> push_patch(to: "/home/accounts")}
  end
  def handle_event("item_new", _, socket) do
    {:noreply, socket |> assign(:page_tile, "New Item")
    |> assign(:live_action, :new)
    |> assign(:item, %Item{})
    }
  end
  def handle_event("item_edit", %{"id" => item_id}, socket) do
    {:noreply, socket
    |> assign(:page_title, "Edit Item")
    |> assign(:live_action, :edit)
    |> assign(:item, Accounts.get_item!(item_id))}
  end
  def handle_event(item_id, _, socket) do
  {:noreply, socket
    |> assign(:page_title, "Edit Item")
    |> assign(:live_action, :edit)
    |> assign(:item, Accounts.get_item!(item_id))}
  end
end
