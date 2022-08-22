defmodule Coconut.AccountsTest do
  use Coconut.DataCase, async: true

  import Coconut.Factory

  alias Coconut.Accounts
  alias Coconut.Accounts.User

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = insert(:user)

      assert %User{id: ^id} = Accounts.get_user_by_email(user.email)
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!("11111111-1111-1111-1111-111111111111")
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = insert(:user)

      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates email uniqueness" do
      %User{} = existing_user = insert(:user)
      %User{} = new_user = build(:user, %{email: existing_user.email})

      {:error, changeset} = Accounts.register_user(%{email: new_user.email})

      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_user(%{email: String.upcase(new_user.email)})

      assert "has already been taken" in errors_on(changeset).email
    end
  end

  describe "find_or_create/1" do
    test "returns an existing user" do
      %{email: email} = existing_user = insert(:user)
      auth = ueberauth_fixture(existing_user)

      assert {:ok, %User{} = found_user} = Accounts.find_or_create(auth)
      assert %User{email: ^email} = found_user
    end

    test "creates a new user" do
      %{email: email} = new_user = build(:user)
      auth = ueberauth_fixture(new_user)

      refute Accounts.get_user_by_email("unknown@example.com")

      assert {:ok, %User{} = found_user} = Accounts.find_or_create(auth)
      assert %User{email: ^email} = found_user
    end
  end

  defp ueberauth_fixture(%User{} = user) do
    %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        expires: true,
        expires_at: 600,
        other: %{},
        refresh_token: nil,
        scopes: [
          "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid"
        ],
        secret: nil,
        token: "some_token",
        token_type: "Bearer"
      },
      extra: %Ueberauth.Auth.Extra{
        raw_info: %{
          token: %OAuth2.AccessToken{
            access_token: "some_access_token",
            expires_at: 600,
            other_params: %{
              "id_token" => "some_id_token",
              "scope" =>
                "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile openid"
            },
            refresh_token: nil,
            token_type: "Bearer"
          },
          user: %{
            "email" => user.email,
            "email_verified" => true,
            "family_name" => "Foo",
            "given_name" => "Bar",
            "locale" => "en",
            "name" => user.name,
            "picture" => "https://lh3.googleusercontent.com/a-/AFdZucoGT",
            "sub" => "102379317609754087855"
          }
        }
      },
      info: %Ueberauth.Auth.Info{
        birthday: nil,
        description: nil,
        email: user.email,
        first_name: "Foo",
        image: "https://lh3.googleusercontent.com/a-/AFdZucoGTssaff7O",
        last_name: "Bar",
        location: nil,
        name: user.name,
        nickname: nil,
        phone: nil,
        urls: %{profile: nil, website: nil}
      },
      provider: :google,
      strategy: Ueberauth.Strategy.Google,
      uid: "102379318509754087855"
    }
  end
end
