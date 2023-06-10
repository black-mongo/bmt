defmodule BmtAdminWeb.OAuthCallbackController do
  use BmtAdminWeb, :controller
  require Logger

  alias BmtAdmin.Accounts

  def new(conn, %{"provider" => "github", "code" => code, "state" => state}) do
    client = github_client(conn)

    with {:ok, info} <- client.exchange_access_token(code: code, state: state),
         %{info: _info, primary_email: primary, emails: _emails, token: token} = info,
         {:ok, user} <- check_and_insert_user(primary, token) do
      conn
      |> put_flash(:info, "Welcome #{user.email}")
      |> BmtAdminWeb.UserAuth.log_in_user(user)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.debug("failed GitHub insert #{inspect(changeset.errors)}")

        conn
        |> put_flash(
          :error,
          "We were unable to fetch the necessary information from your GithHub account"
        )
        |> redirect(to: "/")

      {:error, reason} ->
        Logger.debug("failed GitHub exchange #{inspect(reason)}")

        conn
        |> put_flash(:error, "We were unable to contact GitHub. Please try again later")
        |> redirect(to: "/")
    end
  end

  def new(conn, %{"provider" => "github", "error" => "access_denied"}) do
    redirect(conn, to: "/")
  end

  def sign_out(conn, _) do
    BmtAdminWeb.UserAuth.log_out_user(conn)
  end

  defp github_client(conn) do
    conn.assigns[:github_client] || BmtAdmin.Github
  end
  defp check_and_insert_user(email, token) do
    case Accounts.get_user_by_email(email) do
         nil ->
               Accounts.register_user(%{email: email, password: token})
         user ->
               {:ok, user}
    end
   end
end
