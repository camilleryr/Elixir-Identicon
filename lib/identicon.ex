defmodule Identicon do
  @moduledoc """
  Build a Identicon based on the hased value of a string input
  """

  @doc """
  Pass {input} in a string and a Identicon will be drawn and saved to the file
  system under the filename input.png
  """
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares()
    |> build_pixel_map()
    |> draw_image()
    |> save_image(input)
  end

  @doc """
  Helper method to write the image to the file system using the origianl input string as filename
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
  Helper method utilizing the Erlang Graphical Drawer to create and return the image using the pixel \
  map and hex color generated with the input string
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250,250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Helper method to transform the grid values into pixel values for the egd module and
  return a new Identicon.Image struct
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map grid, fn({_code, index}) ->
        hor = rem(index, 5) * 50
        vert = div(index, 5) * 50

        t_left = {hor, vert}
        b_right = {hor+50, vert+50}

        {t_left, b_right}
      end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Helper method that removes all incedences of the grid where the hex code value is odd
  leaving only the incedences that will be used to create the filled rectangles and returns
  a new Identicon.Image struct
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = 
      Enum.filter(grid, fn({code, _index}) ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Helper method that takes in the list of 16 hex codes and creates a list of 25 tuples that
  are {hex_code, index} and returns a new Identicon.Image struct
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Helper method for build_grid that takes in a list [a,b,c] and returns that list mirrored
  as [a,b,c,b,a}]
  """
  def mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  @doc """
  Helper method that pulls the first 3 hex values from the list for use as the color used by
  the egd and returns a new Identicon.Image struct
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _t]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Helper method that takes a string input, hashes it and creates a list of 16 hex values
  returns a Identicon.Image struct with the list saved on the hex key
  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
