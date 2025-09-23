defmodule SpkpProject.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SpkpProject.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password: valid_user_password(),
        password_confirmation: valid_user_password(),  # ✅ confirm password
        full_name: "Test User",                 # ✅ required field
        role: "user"
      })
      |> SpkpProject.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a maklumat_pekerja.
  """
  def maklumat_pekerja_fixture(attrs \\ %{}) do
    {:ok, maklumat_pekerja} =
      attrs
      |> Enum.into(%{
        nama_bank: "some nama_bank",
        no_akaun: "some no_akaun",
        no_ic: "some no_ic",
        no_tel: "some no_tel"
      })
      |> SpkpProject.Accounts.create_maklumat_pekerja()

    maklumat_pekerja
  end
end
