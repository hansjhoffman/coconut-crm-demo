defmodule Coconut.Factory do
  @moduledoc """
  Factory for tests
  """

  use ExMachina.Ecto, repo: Coconut.Repo

  alias Coconut.Accounts.User

  def user_factory do
    %User{
      email: sequence(:email, &"foo-#{&1}@example.com"),
      name: "Foo Bar",
      avatar: "https://foobar.com/avatar.png",
      uid: "1234567890"
    }
  end
end
