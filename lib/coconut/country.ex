defmodule Coconut.Country do
  @moduledoc """
  Compile-time struct used to country list
  """

  @derive Jason.Encoder
  defstruct name: "", country_code: ""
end
