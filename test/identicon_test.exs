defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  test "hash_input should return a struct with a list of hex values" do
    struct = Identicon.hash_input("test")
    assert struct.hex == [9, 143, 107, 205, 70, 33, 211, 115, 202, 222, 78, 131, 38, 39, 180, 246]
  end

  test "pick_color should return a struct with a tuple of 3 hex values" do
    initial =
      %Identicon.Image{
        hex: [9, 143, 107, 205, 70, 33, 211, 115, 202, 222, 78, 131, 38, 39, 180, 246]
      }
    struct = Identicon.pick_color(initial)
    assert struct.color == {9, 143, 107}
  end

  test "mirror_row should take a list [a,b,c] and return [a,b,c,b,a]" do
    mirrored = Identicon.mirror_row([1,2,3])
    assert mirrored == [1,2,3,2,1]
  end

  test "build_grid should return a struct with 25 tuples" do
    initial =
      %Identicon.Image{
        hex: [9, 143, 107, 205, 70, 33, 211, 115, 202, 222, 78, 131, 38, 39, 180, 246]
      }
    struct = Identicon.build_grid(initial)
    assert struct.grid == [
      {9, 0}, {143, 1}, {107, 2}, {143, 3}, {9, 4}, {205, 5}, {70, 6}, {33, 7}, {70, 8}, {205, 9},
      {211, 10}, {115, 11}, {202, 12}, {115, 13}, {211, 14}, {222, 15}, {78, 16}, {131, 17}, {78, 18},
      {222, 19}, {38, 20}, {39, 21}, {180, 22}, {39, 23}, {38, 24}
    ]
  end

  test "filter_odd_squares should remove all items from the grid list where the first item in tuple is odd" do
    inital = 
      %Identicon.Image{
        grid: [{9, 0}, {143, 1}, {107, 2}, {143, 3}, {9, 4}, {205, 5}, {70, 6}, {33, 7}, {70, 8}, {205, 9},
               {211, 10}, {115, 11}, {202, 12}, {115, 13}, {211, 14}, {222, 15}, {78, 16}, {131, 17}, {78, 18},
               {222, 19}, {38, 20}, {39, 21}, {180, 22}, {39, 23}, {38, 24}]
      }
    struct = Identicon.filter_odd_squares(inital)
    assert struct.grid == [{70, 6}, {70, 8}, {202, 12}, {222, 15}, {78, 16}, {78, 18}, {222, 19}, {38, 20}, {180, 22}, {38, 24}]
  end

  test "build_pixel_map should return struct with a list of tuples for each item in the grid" do
    inital = 
      %Identicon.Image{
        grid: [{70, 6}, {70, 8}, {202, 12}, {222, 15}, {78, 16}, {78, 18}, {222, 19}, {38, 20}, {180, 22}, {38, 24}]
      }
    struct = Identicon.build_pixel_map(inital)
    assert struct.pixel_map == [ {{50, 50}, {100, 100}}, {{150, 50}, {200, 100}}, {{100, 100}, {150, 150}}, {{0, 150}, 
      {50, 200}}, {{50, 150}, {100, 200}}, {{150, 150}, {200, 200}}, {{200, 150}, {250, 200}}, {{0, 200}, {50, 250}}, 
      {{100, 200}, {150, 250}}, {{200, 200}, {250, 250}} ]
  end

  test "" do

  end

end
