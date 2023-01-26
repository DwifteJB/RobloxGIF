local ContentProvider = game:GetService("ContentProvider")

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
	"rbxassetid://12251262758",
	"rbxassetid://12251136147",
	"rbxassetid://12251135771",
	"rbxassetid://12251135501",
	"rbxassetid://12251135226",
	"rbxassetid://12251134889",
	"rbxassetid://12251134597",
	"rbxassetid://12251134329",
	"rbxassetid://12251134075"
}

local preload = {}
for _, ImageID in Images do
    local i = Instance.new("ImageLabel")
    i.Image = ImageID
    i.Parent = script
    table.insert(preload,i)
end

ContentProvider:PreloadAsync(preload)

for _, Asset in preload do
    Asset:Destroy()
end