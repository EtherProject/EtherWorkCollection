UsingMoudle("Window")
UsingMoudle("Graphic")
UsingMoudle("Interactivity")

_COLOR_BACK_ = {r = 125, g = 125, b = 200, a = 255}

CreateWindow("HelloWorld", {
        x = WINDOW_POSITION_DEFAULT,
        y = WINDOW_POSITION_DEFAULT,
        w = 640,
        h = 360
    },
    {
        WINDOW_RESIZABLE
    }
)

while true do

    SetDrawColor(_COLOR_BACK_)

    ClearWindow()

    if UpdateEvent() then

        local _event = GetEventType() 
        
        if _event == EVENT_QUIT then
            break
        end

    end

    UpdateWindow()

end