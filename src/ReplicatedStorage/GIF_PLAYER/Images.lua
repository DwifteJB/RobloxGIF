--[[
		GIF_PLAYER
		WRITTEN BY DWIFTE
]]

local RunService = game:GetService("RunService")
local FastSignal

pcall(function()
	FastSignal = require(script.Parent.FastSignal)
end)

if not FastSignal then
	warn(`[{script.Name}]: FastSignal not found. Signals disabled.`)
end

local IMAGE = {}
IMAGE.__index = IMAGE

local toUpdate = {}

function IMAGE:New(ImageLabel:ImageLabel, Images, Framerate:number, options)
	self = setmetatable({}, IMAGE)
	
	self.ImageLabel = ImageLabel
	self.Frames = Images

	self.Options = options or {}
	self.Repeated = {}
	
	self.Framerate = Framerate
	
	self.lastFrameTick = 0
	self.Index = 0

	if FastSignal then
		self.Finished = FastSignal.new()
		self.FrameUpdate = FastSignal.new()
	end

	-- Configure ImageLabel

	table.insert(toUpdate,self)

	return self

end

function IMAGE:Update()
	if tick()-self.lastFrameTick >= 1/self.Framerate then
		
		if self.Repeated[self.Index] then
			if self.Repeated[self.Index] < self.Options.PauseOn[tostring(self.Index)] then
				self.Repeated[self.Index] += 1
			else
				print("Finished pausing for", self.Index)
				self.Repeated[self.Index] = nil
			end
		else

			self.Index += 1
			self.ImageLabel.Image = self.Frames[self.Index]

			if FastSignal then
				self.FrameUpdate:Fire(self.Index)
			end

			if self.Options.PauseOn and self.Options.PauseOn[tostring(self.Index)] then
				print("Pausing on frame", self.Index)
				self.Repeated[self.Index] = 0
			end

			if self.Index >= #self.Frames then
				if self.Options.Repeat then
					self.Index = 0
				else
					if FastSignal then
						self.Finished:Fire()
					end

					self:Destroy()
				end
			end

		end

		self.lastFrameTick = tick()
	end
end

function IMAGE:Destroy()
	table.remove(toUpdate,table.find(toUpdate,self))

	if FastSignal then
		self.Finished:DisconnectAll()
		self.FrameUpdate:DisconnectAll()
	end

	self = nil
end

RunService.Heartbeat:Connect(function()
	for _, Frame in toUpdate do
		if not Frame or not Frame.ImageLabel or not Frame.ImageLabel:IsDescendantOf(game) then
			table.remove(toUpdate,table.find(toUpdate,Frame))
		else
			Frame:Update()
		end
	end
end)

return IMAGE
