Scene = {}

--场景基类,所有场景继承于该场景
Scene.BaseScene = {}
--场景返回值,用于让Director得知下一个场景的索引值,0表示暂未选择下一个场景
Scene.BaseScene.nRtnValue = 0
--场景列表,最后在Main给出赋值,让Director知道下一个场景是谁
Scene.BaseScene.vSceneList = {}

--场景初始化函数
function Scene.BaseScene:Init() end

--场景更新函数(每帧执行一次)
function Scene.BaseScene:Update() end

--场景垃圾回收函数
function Scene.BaseScene:Unload() end

function Scene.BaseScene:New()
    local o = 
    {
        nRtnValue = 0,
        vSceneList = {}
    }
    setmetatable(o, {__index = self})
    return o
end

return Scene