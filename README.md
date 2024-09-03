# Camera Dust in Roblox!

this is innovative, new graphics technology for roblox games
paired with volumetric lighting




Static lights are meant to be unmoving. This allows the script less processing power, because all the data is pre-computed. Please refrain from making light sources that do not move around Dynamic lights.

Dynamic lights do not store any pre-computed data. This means it has to query the data every frame. Dynamic lights should be used sparingly in a scene.

# Visual Demonstrations
demonstration showing a blue `Dynamic` light moving around the scene

![md-demonstrate-lights-disabled](https://github.com/user-attachments/assets/04e1199a-6928-4f1a-9115-f2db087a763c)

demonstration of camera reacting to a `Static` light

![md-demonstrate-lights-movement](https://github.com/user-attachments/assets/846108f6-07fc-4621-a0bd-05b7cdf8bb67)

## Setup
 - call the `init` function
 - write your preferences to the script
 - call the `draw` function
 - set the parent of `gui_output`
 - implement `step` into your render loop


## Properties
`preferences`: is a table containing numbers. is used to customize the behavior of the textures during runtime.

`lens_texture_addresses`: array of image ids that can be replaced.

`gui_output`: nil be default. on `init`, it becomes an unparented ScreenGui. this is where all textures are drawn.
## Methods
`init` (): creates all instances that are used within the script.

`draw` (): creates every dust texture based on `dust_draw_count`.

`new_Dynamic` (Light): inserts a `Dynamic` Light into its registry.

`new_Static` (Light): inserts a `Static` Light into its registry.

`step` (): designed to run every frame, which does all of the processing.
