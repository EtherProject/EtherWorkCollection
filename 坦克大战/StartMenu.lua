Graphic = UsingModule("Graphic")
Interactivity = UsingModule("Interactivity")
Window = UsingModule("Window")
Time = UsingModule("Time")
OS = UsingModule("OS")

Window.CreateWindow(
    "坦克大战",
    {
        x = Window.WINDOW_POSITION_DEFAULT,
        y = Window.WINDOW_POSITION_DEFAULT,
        w = 900, h = 600
    },
    {}
)

Resource = UsingModule("Resource")

----------变量声明----------
StartMenu = {}
local QuitScene = 0
local Choice = 1
local Font = Graphic.LoadFontFromFile("Resource/Font/simhei.ttf", 50)

local Start_W = Graphic.CreateUTF8TextImageBlended(Font, "开始游戏", {r = 255, g = 255, b = 255, a = 255})
local StartW = Graphic.CreateTexture(Start_W)
local Start_Y = Graphic.CreateUTF8TextImageBlended(Font, "开始游戏", {r = 255, g = 255, b = 0, a = 255})
local StartY = Graphic.CreateTexture(Start_Y)

local Quit_W = Graphic.CreateUTF8TextImageBlended(Font, "退出游戏", {r = 255, g = 255, b = 255, a = 255})
local QuitW = Graphic.CreateTexture(Quit_W)
local Quit_Y = Graphic.CreateUTF8TextImageBlended(Font, "退出游戏", {r = 255, g = 255, b = 0, a = 255})
local QuitY = Graphic.CreateTexture(Quit_Y)

_YellowTank1 = Graphic.CreateTexture(Resource.YellowTank_1)

function StartMenu.Run()
    while QuitScene == 0 do
        local nStartTime = Time.GetInitTime()
        Graphic.SetDrawColor({r = 0, g = 0, b = 0, a = 255})
        Window.ClearWindow()

        if Interactivity.UpdateEvent() then
            local Event = Interactivity.GetEventType()
            if Event == Interactivity.EVENT_KEYUP_UP and Choice ~= 1 then
                Choice = Choice - 1
            elseif Event == Interactivity.EVENT_KEYUP_DOWN and Choice ~=2 then
                Choice = Choice + 1
            elseif Event == Interactivity.EVENT_KEYUP_Z then
                QuitScene = Choice
            end
        end

        if Choice == 1 then
            Graphic.CopyTexture(StartY, {x = 420, y = 200, w = 150, h = 50})
            Graphic.CopyTexture(QuitW, {x = 420, y = 300, w = 150, h = 50})
            Graphic.CopyReshapeTexture(_YellowTank1, Resource.YellowTank1[4][1].Rect, {x = 300, y = 200, w = 52, h = 52})
        elseif Choice == 2 then
            Graphic.CopyTexture(StartW, {x = 420, y = 200, w = 150, h = 50})
            Graphic.CopyTexture(QuitY, {x = 420, y = 300, w = 150, h = 50})
            Graphic.CopyReshapeTexture(_YellowTank1, Resource.YellowTank1[4][1].Rect, {x = 300, y = 300, w = 52, h = 52})
        end
        
        Window.UpdateWindow()
        Time.DynamicSleep(1000 / 60, Time.GetInitTime() - nStartTime)
    end
    return QuitScene
end

return StartMenu