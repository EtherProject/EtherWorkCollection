Scene = UsingModule("Scene")
Resource = UsingModule("Resource")
Window = UsingModule("Window")
Interactivity = UsingModule("Interactivity")

Menu = {}
Menu = Scene.BaseScene:New()

local Choice = 1

function Menu.Init()
    Graphic.SetDrawColor({r = 0, g = 0, b = 0, a = 255})
    Menu._startGame1 = Graphic.CreateUTF8TextImageBlended(Resource.simhei, "开始游戏", {r = 255, g = 255, b = 255, a = 255})
    Menu.startGame1 = Graphic.CreateTexture(Menu._startGame1)
    Menu._startGame2 = Graphic.CreateUTF8TextImageBlended(Resource.simhei, "开始游戏", {r = 234, g = 234, b = 21, a = 255})
    Menu.startGame2 = Graphic.CreateTexture(Menu._startGame2)
    
    Menu._quitGame1 = Graphic.CreateUTF8TextImageBlended(Resource.simhei, "退出游戏", {r = 255, g = 255, b = 255, a = 255})
    Menu.quitGame1 = Graphic.CreateTexture(Menu._quitGame1)
    Menu._quitGame2 = Graphic.CreateUTF8TextImageBlended(Resource.simhei, "退出游戏", {r = 234, g = 234, b = 21, a = 255})
    Menu.quitGame2 = Graphic.CreateTexture(Menu._quitGame2)
end

function Menu.Update()
    Window.ClearWindow()

    if Interactivity.UpdateEvent() then
        local event = Interactivity.GetEventType()
        if event == Interactivity.EVENT_KEYUP_UP and Choice ~= 1 then
            Choice = Choice - 1
        elseif event == Interactivity.EVENT_KEYUP_DOWN and Choice ~=2 then
            Choice = Choice + 1
        elseif event == Interactivity.EVENT_KEYUP_Z then
            Menu.nRtnValue = Choice
        elseif event == Interactivity.EVENT_QUIT then
            Menu.nRtnValue = -1
        end
    end

    if Choice == 1 then
        Graphic.CopyTexture(Menu.startGame2, {x = 1000, y = 100, w = 150, h = 50})
        Graphic.CopyTexture(Menu.quitGame1, {x = 1000, y = 200, w = 150, h = 50})
    elseif Choice == 2 then
        Graphic.CopyTexture(Menu.startGame1, {x = 1000, y = 100, w = 150, h = 50})
        Graphic.CopyTexture(Menu.quitGame2, {x = 1000, y = 200, w = 150, h = 50})
    end

    Window.UpdateWindow()
end

function Menu.Unload()
    Menu._startGame1 = nil
    Menu.startGame1 = nil
    Menu._startGame2 = nil
    Menu.startGame2 = nil

    Menu._quitGame1 = nil
    Menu.quitGame1 = nil
    Menu._quitGame2 = nil
    Menu.quitGame2 = nil
end

return Menu