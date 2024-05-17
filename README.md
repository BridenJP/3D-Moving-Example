# Godot: 3D movement sample

This Godot (4.2) project looks at _basic movement_.

It implements 3 examples of movement, with detailed commenting:

1. **Simple:** _(basic_character.gd)_ The default character movement. The character moves forwards and backwards with up/down arrow keys
   and strafes with left/right arrow keys. The code is heavily commented to explain how each part
   works.
   The only additional code is 1 line that changes the character animation between Idle and Running.
1. **Turn w/ Keys:** _(key_turn_character.gd)_ Changes the default character movement to use the left and right arrow keys for turning.
1. **Turn w/ Mouse:** _(mouse_turn_character.gd)_ Adds minimal code to the default character movement to allow the character to change
   the direction in which they are facing when the mouse is moved left and right. Mouse capture is turned on to avoid the mouse going
   outside the window.

Note: The ESC key immediately closes the "game"

## See also:

For more information, including tilting the view when the mouse moves in the Y direction,
see Mr Thawley's excellent video on this topic:

- https://www.youtube.com/watch?v=RO7sAUY5sxA

## Acknowledgements

- 3D-Godot-Robot-Platformer-Character by CaptainRipley:<br>
  https://godotengine.org/asset-library/asset/1467
- Marble Tiles - Charlotte Baglioni:<br>
  https://polyhaven.com/a/marble_tiles
