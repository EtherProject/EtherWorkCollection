Debug = UsingModule("Debug")
Scene = UsingModule("Scene")
Resource = UsingModule("Resource")
Window = UsingModule("Window")
Interactivity = UsingModule("Interactivity")
Algorithm = UsingModule("Algorithm")

TheWorld = {}
TheWorld = Scene.BaseScene:New()

--背景天空相关变量
local BackgroundRect = {x = 0, y = 0, w = Global.WINDOWSIZE_W, h = 300}
local BackgroundShape = {x = 0, y = 0, w = Global.WINDOWSIZE_W, h = 300}
local Background2Rect = {x = Global.WINDOWSIZE_W, y = 0, w = 0, h = 300}
local Background2Shape = {x = 0, y = 0, w = 0, h = 300}

--背景山相关变量
local MountainRect = {x = 0, y = 0, w = 1600, h = Global.WINDOWSIZE_H}
local Mountain2Rect = {x = 1600, y = 0, w = 1600, h = Global.WINDOWSIZE_H}

--破坏方块相关变量
local BreakingBlock = 0
local Position2 = {x = 0, y = 0}
local tempHardness = 0
local crackRect = {x = 0, y = 0, w = 30, h = 30}
local isBreaking = false

--背包模块相关变量
local isKnapsackOpen = false
local selectItem = 1
local isFound = false
local leftButtonUp = false

function TheWorld.Init()
    TheWorld.sky = Graphic.CreateTexture(Resource.sky)
    TheWorld.mountain = Graphic.CreateTexture(Resource.mountain)
    TheWorld.cracks = Graphic.CreateTexture(Resource.cracks)
    Resource.CreateWorld()
    Resource.Leader.Layer = 1
    table.insert(Resource.vObjectTable, 1, Resource.Leader)
    Resource.Camera.Init(Resource.Leader)
    Resource.KnapsackInit()
end

--键盘上的某些键位是否按下
local _KeyboardState = {one = false, two = false, three = false, four = false, five = false, six = false, seven = false, eight = false, nine = false}
--鼠标是否按下
local _CursorState = {left = false, right = false, middle = false}
--玩家目前按下的某个方向的键
local _Direction = {left = false, right = false, up = false}
--角色正在朝向移动的方向
local _MoveState = {left = false, right = false, up = false, down = false}
--判断是否有方块阻挡玩家移动
local function canMove()
    if _MoveState.left then
        local CollisionY1 = math.ceil((Resource.Leader.Rect.y + 90) / 30)
        local CollisionY2 = math.ceil((Resource.Leader.Rect.y + 60) / 30)
        local CollisionY3 = math.ceil((Resource.Leader.Rect.y + 30) / 30)
        local CollisionX = math.floor((Resource.Leader.Rect.x + Resource.Leader.xSpeed + 2) / 30) + 1
        if Resource.Map[CollisionY1][CollisionX] == 0 and Resource.Map[CollisionY2][CollisionX] == 0 and Resource.Map[CollisionY3][CollisionX] == 0 then
            return true
        else
            _MoveState.left = false
            Resource.Leader.xSpeed = 0
            return false
        end
    elseif _MoveState.right then
        local CollisionY1 = math.ceil((Resource.Leader.Rect.y + 90) / 30)
        local CollisionY2 = math.ceil((Resource.Leader.Rect.y + 60) / 30)
        local CollisionY3 = math.ceil((Resource.Leader.Rect.y + 30) / 30)
        local CollisionX = math.floor((Resource.Leader.Rect.x + Resource.Leader.xSpeed + 28) / 30) + 1
        if Resource.Map[CollisionY1][CollisionX] == 0 and Resource.Map[CollisionY2][CollisionX] == 0 and Resource.Map[CollisionY3][CollisionX] == 0 then
            return true
        else
            _MoveState.right = false
            Resource.Leader.xSpeed = 0
            return false
        end
    end
end

function TheWorld.Update()
    Window.ClearWindow()

    while Interactivity.UpdateEvent() do
        local event = Interactivity.GetEventType()
        if event == Interactivity.EVENT_QUIT then
            TheWorld.nRtnValue = -1
        elseif event == Interactivity.EVENT_KEYDOWN_A then
            _Direction.left = true
        elseif event == Interactivity.EVENT_KEYUP_A then
            _Direction.left = false
        elseif event == Interactivity.EVENT_KEYDOWN_D then
            _Direction.right = true
        elseif event == Interactivity.EVENT_KEYUP_D then
            _Direction.right = false
        elseif event == Interactivity.EVENT_KEYDOWN_W then
            _Direction.up = true
        elseif event == Interactivity.EVENT_KEYUP_W then
            _Direction.up = false
        elseif event == Interactivity.EVENT_MOUSEBTNDOWN_LEFT then
            _CursorState.left = true
        elseif event == Interactivity.EVENT_MOUSEBTNDOWN_RIGHT then
            _CursorState.right = true
        elseif event == Interactivity.EVENT_MOUSEBTNDOWN_MIDDLE then
            _CursorState.middle = true
        elseif event == Interactivity.EVENT_MOUSEBTNUP_LEFT then
            _CursorState.left = false
            leftButtonUp = true
        elseif event == Interactivity.EVENT_MOUSEBTNUP_RIGHT then
            _CursorState.right = false
        elseif event == Interactivity.EVENT_MOUSEBTNUP_MIDDLE then
            _CursorState.middle = false
        elseif event == Interactivity.EVENT_KEYUP_E then
            isKnapsackOpen = not isKnapsackOpen
        elseif event == Interactivity.EVENT_KEYDOWN_1 then
            _KeyboardState.one = true
        elseif event == Interactivity.EVENT_KEYUP_1 then
            _KeyboardState.one = false
        elseif event == Interactivity.EVENT_KEYDOWN_2 then
            _KeyboardState.two = true
        elseif event == Interactivity.EVENT_KEYUP_2 then
            _KeyboardState.two = false
        elseif event == Interactivity.EVENT_KEYDOWN_3 then
            _KeyboardState.three = true
        elseif event == Interactivity.EVENT_KEYUP_3 then
            _KeyboardState.three = false
        elseif event == Interactivity.EVENT_KEYDOWN_4 then
            _KeyboardState.four = true
        elseif event == Interactivity.EVENT_KEYUP_4 then
            _KeyboardState.four = false
        elseif event == Interactivity.EVENT_KEYDOWN_5 then
            _KeyboardState.five = true
        elseif event == Interactivity.EVENT_KEYUP_5 then
            _KeyboardState.five = false
        elseif event == Interactivity.EVENT_KEYDOWN_6 then
            _KeyboardState.six = true
        elseif event == Interactivity.EVENT_KEYUP_6 then
            _KeyboardState.six = false
        elseif event == Interactivity.EVENT_KEYDOWN_7 then
            _KeyboardState.seven = true
        elseif event == Interactivity.EVENT_KEYUP_7 then
            _KeyboardState.seven = false
        elseif event == Interactivity.EVENT_KEYDOWN_8 then
            _KeyboardState.eight = true
        elseif event == Interactivity.EVENT_KEYUP_8 then
            _KeyboardState.eight = false
        elseif event == Interactivity.EVENT_KEYDOWN_9 then
            _KeyboardState.nine = true
        elseif event == Interactivity.EVENT_KEYUP_9 then
            _KeyboardState.nine = false
        end
    end

    --如果开始移动,则将玩家的速度加上加速度的值直到达到最大速度
    if Resource.Leader.xSpeed == 0 and _Direction.left and _Direction.right == false and _MoveState.left == false then
        _MoveState.left = true
    end
    --如果当前速度小于最大速度且玩家依旧命令角色移动,则继续增加
    if _MoveState.left and _Direction.left and math.abs(Resource.Leader.xSpeed) < Resource.Leader.xMaxSpeed then
        Resource.Leader.xSpeed = Resource.Leader.xSpeed - Resource.Leader.Acceleration
    end
    --如果当前速度超过了最大速度,则强制赋值为最大速度
    if math.abs(Resource.Leader.xSpeed) >= Resource.Leader.xMaxSpeed and _MoveState.left and _Direction.left then
        Resource.Leader.xSpeed = 0 - Resource.Leader.xMaxSpeed
    end
    --如果玩家没有命令角色移动,则慢慢减速
    if _MoveState.left and _Direction.left == false then
        Resource.Leader.xSpeed = Resource.Leader.xSpeed + Resource.Leader.Acceleration
    end
    --如果玩家减速过头,则强制赋值速度为0,且取消角色向左移动的状态
    if _MoveState.left and Resource.Leader.xSpeed >= 0 then
        Resource.Leader.xSpeed = 0
        _MoveState.left = false
    end

    --[下列为向右的情况]
    if Resource.Leader.xSpeed == 0 and _Direction.right and _Direction.left == false and _MoveState.right == false then
        _MoveState.right = true
    end
    if _MoveState.right and _Direction.right and Resource.Leader.xSpeed < Resource.Leader.xMaxSpeed then
        Resource.Leader.xSpeed = Resource.Leader.xSpeed + Resource.Leader.Acceleration
    end
    if Resource.Leader.xSpeed >= Resource.Leader.xMaxSpeed and _MoveState.right and _Direction.right then
        Resource.Leader.xSpeed = Resource.Leader.xMaxSpeed
    end
    if _MoveState.right and _Direction.right == false then
        Resource.Leader.xSpeed = Resource.Leader.xSpeed - Resource.Leader.Acceleration
    end
    if _MoveState.right and Resource.Leader.xSpeed <= 0 then
        Resource.Leader.xSpeed = 0
        _MoveState.right = false
    end

    --跳跃的情况,以及下落
    local tempCollisionX1 = math.floor((Resource.Leader.Rect.x + 2) / 30) + 1
    local tempCollisionX2 = math.floor((Resource.Leader.Rect.x + 28) / 30) + 1
    local tempCollisionY1 = math.floor((Resource.Leader.Rect.y + Resource.Leader.ySpeed + 90) / 30) + 1
    local tempCollisionY2 = math.floor((Resource.Leader.Rect.y + Resource.Leader.ySpeed + 30) / 30) + 1
    --如果玩家脚下没有方块,那么他将自由落体
    if Resource.Map[tempCollisionY1][tempCollisionX1] == 0 and Resource.Map[tempCollisionY1][tempCollisionX2] == 0 then
        if Resource.Leader.ySpeed < 0 and _MoveState.up == false then
            _MoveState.up = true
        elseif Resource.Leader.ySpeed < 0 and _MoveState.up then
            Resource.Leader.ySpeed = Resource.Leader.ySpeed + Global.GRAVITY
        elseif Resource.Leader.ySpeed >= 0 and _MoveState.up then
            _MoveState.up = false
            _MoveState.down = true
        elseif Resource.Leader.ySpeed >= 0 and Resource.Leader.ySpeed < Resource.Leader.yMaxSpeed and _MoveState.down then
            Resource.Leader.ySpeed = Resource.Leader.ySpeed + Global.GRAVITY
        elseif Resource.Leader.ySpeed >= Resource.Leader.yMaxSpeed and _MoveState.down then
            Resource.Leader.ySpeed = Resource.Leader.yMaxSpeed
        end
        if Resource.Leader.ySpeed == 0 and _MoveState.down == false and _MoveState.up == false then
            _MoveState.down = true
            Resource.Leader.ySpeed = Resource.Leader.ySpeed + Global.GRAVITY
        end
    --如果玩家脚下有方块,那么玩家将瞬间静止
    elseif Resource.Map[tempCollisionY1][tempCollisionX1] ~= 0 or Resource.Map[tempCollisionY1][tempCollisionX2] ~= 0 then
        if _MoveState.down then
            Resource.Leader.ySpeed = 0
            Resource.Leader.Rect.y = tempCollisionY1 * 30 - 120
            _MoveState.down = false
        end
        if _Direction.up then
            Resource.Leader.ySpeed = 0 - Resource.Leader.JumpAbility
        end
    end
    --如果玩家头顶有方块阻挡,则玩家瞬间速度为0,且开始下落
    if (Resource.Map[tempCollisionY2][tempCollisionX1] ~= 0 or Resource.Map[tempCollisionY2][tempCollisionX2] ~= 0) and _MoveState.up then
        _MoveState.up = false
        _MoveState.down = true
        Resource.Leader.ySpeed = 0
    end

    --每帧更新玩家的位置
    if canMove() then
        Resource.Leader.Rect.x = Resource.Leader.Rect.x + Resource.Leader.xSpeed
    end
    --每帧更新玩家Y轴的位置
    Resource.Leader.Rect.y = Resource.Leader.Rect.y + Resource.Leader.ySpeed

    --绘制背景的山,两张图片循环进行,且根据玩家的移动来移动
    if _MoveState.left and _MoveState.right == false and Resource.Camera.Rect.x ~= 0 and (Resource.Camera.Rect.x + Resource.Camera.Rect.w) ~= 2000 * 30 and canMove() then
        if MountainRect.x > 0 then
            Mountain2Rect.x = MountainRect.x
            MountainRect.x = Mountain2Rect.x - 1600
            Graphic.CopyTexture(TheWorld.mountain, MountainRect)
            Graphic.CopyTexture(TheWorld.mountain, Mountain2Rect)
        elseif MountainRect.x <= 0 then
            MountainRect.x = MountainRect.x + math.abs(Resource.Leader.xSpeed / 5)
            Mountain2Rect.x = MountainRect.x + 1600
            Graphic.CopyTexture(TheWorld.mountain, MountainRect)
            Graphic.CopyTexture(TheWorld.mountain, Mountain2Rect)
        end
    elseif _MoveState.right and _MoveState.left == false and(Resource.Camera.Rect.x + Resource.Camera.Rect.w) ~= 2000 * 30 and Resource.Camera.Rect.x ~= 0 and canMove() then
        if Mountain2Rect.x < 0 then
            MountainRect.x = Mountain2Rect.x
            Mountain2Rect.x = MountainRect.x + 1600
            Graphic.CopyTexture(TheWorld.mountain, MountainRect)
            Graphic.CopyTexture(TheWorld.mountain, Mountain2Rect)
        elseif Mountain2Rect.x >= 0 then
            MountainRect.x = MountainRect.x - math.abs(Resource.Leader.xSpeed / 5)
            Mountain2Rect.x = MountainRect.x + 1600
            Graphic.CopyTexture(TheWorld.mountain, MountainRect)
            Graphic.CopyTexture(TheWorld.mountain, Mountain2Rect)
        end
    else
        Graphic.CopyTexture(TheWorld.mountain, MountainRect)
        Graphic.CopyTexture(TheWorld.mountain, Mountain2Rect)
    end

    --绘制背景,两张天空图片循环进行
    if BackgroundShape.x <= 400 then
        Graphic.CopyReshapeTexture(TheWorld.sky, BackgroundShape, BackgroundRect)
        BackgroundShape.x = BackgroundShape.x + 1
     elseif BackgroundShape.x > 400 and BackgroundShape.x <= 1600 then
         Graphic.CopyReshapeTexture(TheWorld.sky, BackgroundShape, BackgroundRect)
         BackgroundShape.x = BackgroundShape.x + 1
         BackgroundShape.w = BackgroundShape.w - 1
         BackgroundRect.w = BackgroundRect.w - 1
         Graphic.CopyReshapeTexture(TheWorld.sky, Background2Shape, Background2Rect)
         Background2Rect.x = BackgroundRect.w
         Background2Rect.w = Global.WINDOWSIZE_W - BackgroundRect.w
         Background2Shape.w = Global.WINDOWSIZE_W - BackgroundRect.w
     elseif BackgroundShape.x > 1600 then
         Graphic.CopyReshapeTexture(TheWorld.sky, Background2Shape, Background2Rect)
         BackgroundShape.x = 0
         BackgroundShape.w = Global.WINDOWSIZE_W
         BackgroundRect.w = Global.WINDOWSIZE_W
         Background2Rect.x = Global.WINDOWSIZE_W
         Background2Rect.w = 0
         Background2Shape.w = 0
     end

    --摄像机输出
    Resource.Camera.Output()

    --当方块在人物6格范围内且左键按下他即可破坏掉他
    --如果鼠标对准的方块不是上一帧对准的方块则破坏重置
    --如果背包打开也不能破坏方块
    local CursorPosition = Interactivity.GetCursorPosition()
    local PlayerPosition = {x = Resource.Leader.Rect.x + Resource.Leader.Rect.w / 2, y = Resource.Leader.Rect.y + Resource.Leader.Rect.h / 2}
    local CursorPositionW = {x = CursorPosition.x + Resource.Camera.Rect.x, y = CursorPosition.y + Resource.Camera.Rect.y}
    local Position1 = {x = math.ceil(CursorPositionW.x / 30), y = math.ceil(CursorPositionW.y / 30)}
    if _CursorState.left and Algorithm.GetPointsDistance(CursorPositionW, PlayerPosition) <= 120
    and Position2.x == Position1.x and Position2.y == Position1.y and not isKnapsackOpen then
        --检测鼠标位置是否大于0的原因在于,鼠标在上面的边框时也会获取位置,这有可能导致超出边界
        if Position1.y > 0 and isBreaking == false then
            if Resource.Map[Position1.y][Position1.x] ~= 0 then
                isBreaking = true
                tempHardness = Resource.Hardness[Resource.Map[Position1.y][Position1.x]]
                BreakingBlock = tempHardness
            end
        elseif isBreaking == true and BreakingBlock > 0 then
            crackRect.x, crackRect.y = (Position1.x - 1) * 30 - Resource.Camera.Rect.x, (Position1.y - 1) * 30 - Resource.Camera.Rect.y
            BreakingBlock = BreakingBlock - 1
            local progress = BreakingBlock / tempHardness
            if progress >= 0.75 and progress < 1 then
                Graphic.CopyReshapeTexture(TheWorld.cracks, Resource.arrayCracks[1].Rect, crackRect)
            elseif progress >= 0.5 and progress < 0.75 then
                Graphic.CopyReshapeTexture(TheWorld.cracks, Resource.arrayCracks[2].Rect, crackRect)
            elseif progress >= 0.25 and progress < 0.5 then
                Graphic.CopyReshapeTexture(TheWorld.cracks, Resource.arrayCracks[3].Rect, crackRect)
            elseif progress > 0 and progress < 0.25 then
                Graphic.CopyReshapeTexture(TheWorld.cracks, Resource.arrayCracks[4].Rect, crackRect)
            end
        elseif BreakingBlock <= 0 then
            local theBlank = 0
            --先在物品栏里寻找有没有相同的方块,并记录下空的格子为下步操作做准备,找到就将isFound记录为true不再在背包中寻找
            for i = 1, 9 do
                if Resource.Leader.ItemColumn[i].Material == Resource.Map[Position1.y][Position1.x] then
                    Resource.Leader.ItemColumn[i].Amount = Resource.Leader.ItemColumn[i].Amount + 1
                    isFound = true
                    break
                elseif theBlank == 0 and Resource.Leader.ItemColumn[i].Material == 0 and not isFound then
                    theBlank = i
                end
            end
            --如果没找到,则继续在背包里面找找有没有
            if isFound == false then
                for i = 1, 3 do
                    for j = 1, 9 do
                        if Resource.Leader.Knapsack[i][j].Material == Resource.Map[Position1.y][Position1.x] then
                            Resource.Leader.Knapsack[i][j].Amount = Resource.Leader.Knapsack[i][j].Amount + 1
                            isFound = true
                            break
                        elseif theBlank == 0 and Resource.Leader.Knapsack[i][j].Material == 0 and not isFound then
                            theBlank = i
                        end
                    end
                end
            end
            if theBlank ~= 0 and not isFound then
                Resource.Leader.ItemColumn[theBlank].Material = Resource.Map[Position1.y][Position1.x]
                Resource.Leader.ItemColumn[theBlank].Amount = 1
                theBlank = 0
            end
            Resource.Map[Position1.y][Position1.x] = 0
            BreakingBlock = 0
            isBreaking = false
            isFound = false
        end
    elseif Position2.x ~= Position1.x or Position2.y ~= Position1.y or _CursorState.left == false then
        isBreaking = false
        BreakingBlock = 0
    end
    Position2.x, Position2.y = Position1.x, Position1.y

    --背包和物品栏模块

    --选择物品栏的某个物品
    if _KeyboardState.one then
        selectItem = 1
    elseif _KeyboardState.two then
        selectItem = 2
    elseif _KeyboardState.three then
        selectItem = 3
    elseif _KeyboardState.four then
        selectItem = 4
    elseif _KeyboardState.five then
        selectItem = 5
    elseif _KeyboardState.six then
        selectItem = 6
    elseif _KeyboardState.seven then
        selectItem = 7
    elseif _KeyboardState.eight then
        selectItem = 8
    elseif _KeyboardState.nine then
        selectItem = 9
    end

    --打开/关闭背包直接写在了上方的事件交互中

    --绘制物品栏和背包和物品
    Resource.ColumnOutput(isKnapsackOpen, selectItem)

    --放置方块
    if Resource.Leader.ItemColumn[selectItem].Material ~= 0 and Resource.Map[Position1.y][Position1.x] == 0 and _CursorState.right and not isKnapsackOpen 
    and Algorithm.GetPointsDistance(CursorPositionW, PlayerPosition) <= 120 then
        Resource.Map[Position1.y][Position1.x] = Resource.Leader.ItemColumn[selectItem].Material
        Resource.Leader.ItemColumn[selectItem].Amount = Resource.Leader.ItemColumn[selectItem].Amount - 1
        if Resource.Leader.ItemColumn[selectItem].Amount <= 0 then
            Resource.Leader.ItemColumn[selectItem].Amount = 0
            Resource.Leader.ItemColumn[selectItem].Material = 0
        end
    end

    --检测左键弹起

    --背包内移动物品模块
    if isKnapsackOpen then
        Resource.KnapsackMove(CursorPosition, leftButtonUp)
    end
    leftButtonUp = false

    --如果按下中键,则返回鼠标信息
    --if _CursorState.middle then
    --    Debug.ConsoleLog(string.format("当前鼠标在屏幕位置(%d, %d)", math.floor(CursorPosition.x), math.floor(CursorPosition.y)))
    --    Debug.ConsoleLog(string.format("当前鼠标在世界位置(%d, %d)", math.floor(CursorPositionW.x), math.floor(CursorPositionW.y)))
    --end

    Window.UpdateWindow()
end

function TheWorld.Unload()
    TheWorld.sky = nil
    TheWorld.mountain = nil
    TheWorld.cracks = nil
end

return TheWorld