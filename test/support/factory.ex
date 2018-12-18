defmodule Mytube.Factory do
  use ExMachina.Ecto, repo: Mytube.Repo

  def user_factory do
    %Mytube.User{
      token: "fdsnoafhnoofh08h38h",
      email: "batman@example.com",
      first_name: "Bruce",
      last_name: "Wayne",
      provider: "google"
    }
  end
  
end
