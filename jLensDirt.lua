

--github/8ava/jCameraDust
--2024/09/03


--[[
README.md

# How do I use this?
To start using this, follow these steps to set up and integrate it into your Roblox game. Begin by calling the `init` function to initialize the required components. 
Next, customize the behavior of the textures by writing your preferences into the script. Once your preferences are set, call the `draw` function to generate the initial dust textures.
After setting up the textures, set the Parent of `gui_output` to an appropriate UI container within your game. Finally, implement the `step` function within your render loop to 
ensure that all lighting and texture updates are processed every frame, maintaining dynamic interaction with both static and dynamic light sources in your scene.

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

]]


-- static: less cpu usage, resulting in higher framerates, more ram usage
-- dynamic: more cpu usage, resulting in lower framerates, less ram usage




local class = {
	preferences = {
		size_min = 1 / 70,
		size_max = 1 / 3,

		light_dist_divisor = 100 * 4,
		influence_mult = 40,
		light_z_depth_mult = 1,

		dust_draw_count = 66,
	},

	lens_texture_addresses = {
		126463915771820,
		116567901295079,
		111634370612032,
		87015599302128,
		117148922121678,
		89262209947676,
		80782871562627
	},
	
	gui_output = nil
}


local white = Color3.new(1, 1, 1)

local clamp = math.clamp
local random = Random.new()

local function lerp(v0, v1, t)
	return v0 + t * (v1 - v0);
end


local r_dynamic = {}
local r_static = {}

local draw = {}


local gui_output
local texture_uninitialized




-- METHODS


function class.init()
	gui_output = Instance.new('ScreenGui')
	gui_output.ScreenInsets = Enum.ScreenInsets.None
	class.gui_output = gui_output

	texture_uninitialized = Instance.new('ImageLabel')
	texture_uninitialized.BackgroundTransparency = 1
	texture_uninitialized.ScaleType = Enum.ScaleType.Fit
end


function class.draw()
	if #draw > 0 then -- clean existing
		for _, a in draw do
			a:Destroy()
		end

		table.clear(draw)
	end

	for a = 1, class.preferences.dust_draw_count do
		local instance = Instance.fromExisting(texture_uninitialized)

		local function get_size() -- okay this is processed at initialization, so im not worried about performance, but this is terrible practice
			local aspect = random:NextNumber(class.preferences.size_min, class.preferences.size_max)

			return UDim2.fromScale(aspect, aspect)
		end

		for a, b in { -- endgame luau syntax
			Size = get_size(),
			Position = UDim2.fromScale(random:NextNumber(0, 1), random:NextNumber(0, 1)),
			Rotation = random:NextNumber(-360, 360),
			Image = `rbxassetid://{class.lens_texture_addresses[random:NextInteger(1, #class.lens_texture_addresses)]}`,
			Parent = gui_output
			} do
			instance[a] = b
		end

		table.insert(draw, instance)
	end
end



function class.new_Dynamic(a: light_instance)
	table.insert(r_dynamic, a)
end

function class.new_Static(a: light_instance)
	table.insert(r_static, {a.Parent.CFrame.Position, a.Brightness, a.Color})
end


function class.step()
	local source_ct = #r_dynamic + #r_static

	for _, a in draw do
		local base_influence = 1 / source_ct

		local output_color = white
		local output_transparency = 1


		-- dynamic light sources
		for _, b in r_dynamic do
			local world_conversion: Vector3, n1 = game.Workspace.CurrentCamera:WorldToViewportPoint(b.Parent.CFrame.Position)

			if not n1 then -- if the light is behind camera, we dont need it, genius to make me use extra processing power to flip the bool, thanks roblox
				continue
			end

			local brightness = b.Brightness

			if brightness <= 0 then -- light is not visible
				continue
			end

			local gui_position = a.AbsolutePosition
			local screen_dist = (Vector3.new(gui_position.X, gui_position.Y) - world_conversion).Magnitude / class.preferences.light_dist_divisor -- would rather convert the vec2 into a vec3, since vec2 isnt optimized

			local s_dist_c = clamp(screen_dist, 0, 1)
			local influence = (base_influence * brightness * class.preferences.influence_mult) / (world_conversion.Z * class.preferences.light_z_depth_mult)


			output_transparency = lerp(output_transparency, s_dist_c, influence)
			output_color = output_color:Lerp(b.Color, clamp(1 - s_dist_c, 0, 1))
		end

		-- static light sources
		for _, b in r_static do
			local world_conversion: Vector3, n1 = game.Workspace.CurrentCamera:WorldToViewportPoint(b[1])

			if not n1 then
				continue
			end

			if b[2] <= 0 then
				continue
			end

			local gui_position = a.AbsolutePosition
			local screen_dist = (Vector3.new(gui_position.X, gui_position.Y) - world_conversion).Magnitude / class.preferences.light_dist_divisor

			local s_dist_c = clamp(screen_dist, 0, 1)
			local influence = (base_influence * b[2] * class.preferences.influence_mult) / (world_conversion.Z * class.preferences.light_z_depth_mult)


			output_transparency = lerp(output_transparency, s_dist_c, influence)
			output_color = output_color:Lerp(b[3], clamp(1 - s_dist_c, 0, 1))
		end

		a.ImageColor3 = output_color
		a.ImageTransparency = output_transparency
	end
end


-- DATATYPES

type light_instance = {Parent: BasePart} & Light


return class
