StartMenu = UsingModule("StartMenu")
Stage = UsingModule("Stage")
os.execute("chcp 65001")

local QuitGame = false

while not QuitGame do
    local StartMenuSign = StartMenu.Run()
    if StartMenuSign == 1 then
        local StageSign = Stage.Run()
        if StageSign == 1 then
            QuitGame = true
        elseif StageSign == 2 then
            QuitGame = true
        end
    elseif StartMenuSign == 2 then
        QuitGame = true
    end
end