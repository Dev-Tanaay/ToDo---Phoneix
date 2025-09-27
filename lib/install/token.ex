defmodule Install.Token do
  @signer Joken.Signer.create("HS256", "my_secret_key_for_dev")

  def generate_and_sign(claims) do
    Joken.generate_and_sign(%{}, claims, @signer)
  end

  def verify_and_validate(token) do
    Joken.verify_and_validate(%{}, token, @signer)
  end
end
