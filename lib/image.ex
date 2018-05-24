defmodule Identicon.Image do
  @moduledoc """
  State struct for building Identicons
  hex: list of 16 hex values from hashed string input
  color: tuple of 3 hex values
  grid: list of tuples {hex_code, index}
  pixel: list of tuples for image generation {top_left_pixel, bottom_right_pixel}
  """
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
