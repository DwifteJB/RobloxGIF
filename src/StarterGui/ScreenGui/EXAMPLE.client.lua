local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GIF = require(ReplicatedStorage:WaitForChild("GIF_PLAYER"))

local CRIT_IMAGE = script.Parent.ImageLabel
local MULTI_IMG = script.Parent:WaitForChild("MULTI_IMG")

local Images = {
	"rbxassetid://12251133846",
	"rbxassetid://12251133569",
	"rbxassetid://12251133336",
	"rbxassetid://12251133060",
	"rbxassetid://12251132754",
	"rbxassetid://12251132518",
	"rbxassetid://12251132297",
	"rbxassetid://12251132021",
	"rbxassetid://12251131777", 
	"rbxassetid://12251248606",
	"rbxassetid://12251262758", -- repeat 11
	"rbxassetid://12251136147",
	"rbxassetid://12251135771",
	"rbxassetid://12251135501",
	"rbxassetid://12251135226",
	"rbxassetid://12251134889",
	"rbxassetid://12251134597",
	"rbxassetid://12251134329",
	"rbxassetid://12251134075"
}


MULTI_IMG.MouseButton1Click:Connect(function()
	if not CRIT_IMAGE.Visible then
		MULTI_IMG.Text = "PLAYING"
		CRIT_IMAGE.Image = ""
		CRIT_IMAGE.Visible = true
		local x = GIF.Image:New(CRIT_IMAGE, Images, 45, {
			Repeat=false, -- if you want it to repeat forever
			PauseOn={
				["11"]=6 -- pauses frame 11 for 6 frames
			}
		})

		-- If FastSignal or GoodSignal is required in the module:

		x.FrameUpdate:Connect(function(frameNumber)
			-- Frame number
			print("Frame:",frameNumber)
			MULTI_IMG.Text = `FRAME: {frameNumber}`
		end)
		x.Finished:Connect(function()
			-- GIF is finished playing
			CRIT_IMAGE.Visible = false
			MULTI_IMG.Text = "PLAY GIF"
		end)
	end
end)