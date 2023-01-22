--[[
		GIF_PLAYER
		WRITTEN BY DWIFTE
]]

local RunService = game:GetService("RunService")
local FastSignal

pcall(function()
	FastSignal = require(script.FastSignal)
end)

if not FastSignal then
	warn(`[{script.Name}]: FastSignal not found. GIF.Finished will not work.`)
end

local RobloxMaxImageSize = 1024

local GIF = {}
GIF.__index = GIF
local ToUpdate = {}

function GIF:New(ImageLabel:ImageLabel, ImageWidth:number, ImageHeight:number, Rows:number, Columns:number, NumberOfFrames:number, Framerate:number, options)
	self = setmetatable({}, GIF)

	self.ImageLabel = ImageLabel
	self.Width = ImageWidth
	self.Height = ImageHeight
	self.Rows = Rows
	self.Columns = Columns
	self.NumberOfFrames = NumberOfFrames
	self.Framerate = Framerate
	
	self.Options = options or {}
	self.Repeated = {}
	
	self.lastFrameTick = 0
	self.Index = 0
	
	if FastSignal then
		self.Finished = FastSignal.new()
		self.FrameUpdate = FastSignal.new()
	end
	
	-- Configure ImageLabel
	self:Configure()
	
	table.insert(ToUpdate,self)
	
	return self
	
end

function GIF:Configure()
	if math.max(self.Width,self.Height) > RobloxMaxImageSize then -- Compensate roblox size

		local Longest = self.Width > self.Height and "Width" or "Height"

		if Longest == "Width" then
			self.RealWidth = RobloxMaxImageSize
			self.RealHeight = (self.RealWidth / self.Width) * self.Height
		elseif Longest == "Height" then
			self.RealHeight = RobloxMaxImageSize
			self.RealWidth = (self.RealHeight / self.Height) * self.Width
		end
	else
		self.RealWidth = self.Width
		self.RealHeight = self.Height
	end

	local FrameSize = Vector2.new(self.RealWidth/self.Columns,self.RealHeight/self.Rows)
	self.ImageLabel.ImageRectSize = FrameSize
	
		local CurrentRow, CurrentColumn = 0,0
		self.Offsets = {}
		for i = 1,self.NumberOfFrames do

			local CurrentX = CurrentColumn * FrameSize.X
			local CurrentY = CurrentRow * FrameSize.Y

			table.insert(self.Offsets,Vector2.new(CurrentX,CurrentY))

			CurrentColumn += 1

			if CurrentColumn >= self.Columns then
				CurrentColumn = 0
				CurrentRow += 1
			end
		end
end

function GIF:Update()
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
			self.ImageLabel.ImageRectOffset = self.Offsets[self.Index]
			
			if FastSignal then
				self.FrameUpdate:Fire(self.Index)
			end
			
			if self.Options.PauseOn and self.Options.PauseOn[tostring(self.Index)] then
				print("Pausing on frame", self.Index)
				self.Repeated[self.Index] = 0
			end

			if self.Index >= self.NumberOfFrames then
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

function GIF:Destroy()
	table.remove(ToUpdate,table.find(ToUpdate,self))
	
	if FastSignal then
		self.Finished:DisconnectAll()
		self.FrameUpdate:DisconnectAll()
	end
	
	self = nil
end

RunService.Heartbeat:Connect(function(dt)
	for _, Frame in ToUpdate do
		if not Frame or not Frame.ImageLabel or not Frame.ImageLabel:IsDescendantOf(game) then
			table.remove(ToUpdate,table.find(ToUpdate,Frame))
		else
			Frame:Update()
		end
	end
end)

return GIF
