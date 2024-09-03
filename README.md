# Camera Dirt in Roblox!

Imagine bringing your game to life with an immersive atmosphere that responds dynamically to player actions and environmental changes. This script elevates the visual fidelity of your Roblox games to a whole new level! This innovative graphics technology seen in Unreal Engine, and Unity combines seamlessly with volumetric lighting, adding a layer of cinematic realism that enhances the player's experience. It captures the interplay between light and particles on the camera lens, creating a dynamic and engaging visual that reacts to both static and moving light sources. Whether you're developing an intense action game or a serene cinematic landscape, This is the perfect tool to enrich your game environment and captivate your audience.

### Terms
`Static` lights are meant to be unmoving. This allows the script less processing power, because all the data is pre-computed. Please refrain from making light sources that do not move around `Dynamic` lights.

`Dynamic` lights do not store any pre-computed data. This means it has to query the data every frame. `Dynamic` lights should be used sparingly in a scene.

demonstration showing a blue `Dynamic` light moving around the scene

![md-demonstrate-lights-disabled](https://github.com/user-attachments/assets/04e1199a-6928-4f1a-9115-f2db087a763c)

demonstration of camera reacting to a `Static` light

![md-demonstrate-lights-movement](https://github.com/user-attachments/assets/846108f6-07fc-4621-a0bd-05b7cdf8bb67)

# How do I use this?
To start using this, follow these steps to set up and integrate it into your Roblox game. Begin by calling the `init` function to initialize the required components. Next, customize the behavior of the textures by writing your preferences into the script. Once your preferences are set, call the `draw` function to generate the initial dirt textures.

After setting up the textures, set the Parent of `gui_output` to an appropriate UI container within your game. Finally, implement the `step` function within your render loop to ensure that all lighting and texture updates are processed every frame, maintaining dynamic interaction with both static and dynamic light sources in your scene.

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

`draw` (): creates every dirt texture based on `dust_draw_count`.

`new_Dynamic` (Light): inserts a `Dynamic` Light into its registry.

`new_Static` (Light): inserts a `Static` Light into its registry.

`step` (): designed to run every frame, which does all of the processing.
