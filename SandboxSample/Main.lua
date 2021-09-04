Window = UsingModule("Window")
Time = UsingModule("Time")
Scene = UsingModule("Scene")
GlobalData = UsingModule("Global")
os.execute("chcp 65001")

Window.CreateWindow(
    "玩法示例",
    {
        x = Window.WINDOW_POSITION_DEFAULT,
        y = Window.WINDOW_POSITION_DEFAULT,
        w = Global.WINDOWSIZE_W,
        h = Global.WINDOWSIZE_H
    },
    {}
)
Menu = UsingModule("Menu")
TheWorld = UsingModule("TheWorld")

Menu.vSceneList[1] = TheWorld

--现在正在执行的场景
--初始场景Menu
local currentScene = Menu

while currentScene ~= nil do
    currentScene.Init()

    while currentScene.nRtnValue == 0 do
        local nStartTime = Time.GetInitTime()
        currentScene.Update()
        Time.DynamicSleep(1000 / 60, Time.GetInitTime() - nStartTime)
    end

    currentScene.Unload()
    if #currentScene.vSceneList > 0 and currentScene.vSceneList[currentScene.nRtnValue] ~= nil then
        currentScene = currentScene.vSceneList[currentScene.nRtnValue]
    else
        currentScene = nil
    end
end