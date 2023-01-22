# RobloxGIF

## Usage:

Convert Gif to Spritesheet <a href="https://jacklehamster.github.io/utils/gif2sprite/">here</a>

Create ImageLabel, set size and put that image on it

    local GIF = require(script.Parent.GIF_PLAYER)
     
    -- GIF:New(ImageLabel Instance, SpriteSheet Width, SpriteSheet Height, Columns, Rows, NumberOfFrames, FrameRate, Optional Options)
    local y = GIF:New(script.Parent.ImageLabel,2560,2880,4,2,8,25,{
        Repeat=false,
        PauseOn={
            ["4"]=25; -- pause on frame 4 for 10 frames
        }
    })

    -- if FastSignal is found

    y.FrameUpdate:Connect(function(frame)
        print("Frame update:",frame)
    end)

    y.Finished:Connect(function()
        print("FINISHED GIF")
    end)
