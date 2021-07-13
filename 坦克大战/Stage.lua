Graphic = UsingModule("Graphic")
Interactivity = UsingModule("Interactivity")
Window = UsingModule("Window")
Time = UsingModule("Time")
Resource = UsingModule("Resource")
Algorithm = UsingModule("Algorithm")

Stage = {}

local QuitScene = 0

--[[
地图方块
0表示无方块
1表示可破坏的砖块
2表示不可破坏的瓷砖
3表示水
4表示树叶
--]]
local Map = 
{
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 0, 0, 0},
    {0, 0, 0, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 0, 0, 0},
    {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
    {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 2, 2, 2, 2, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 2, 2, 2, 2, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 2, 2, 2, 2, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 2, 2, 2, 2, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 5, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 5, 5, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
}

--操纵坦克移动
--为了和图片资源里的坦克方向对应
--direction的值 1对应上,2对应左,3对应下,4对应右

--在坦克的正前方面上设置了3个点
--左顶点,中点和右顶点
--该函数判断这三个点前方是空气或树叶才能通行
function Move(tank, direction)
    if direction == 1 then
        tank.Direction = 1
        local CollisionY = math.modf((tank.Rect.y - tank.Speed) / 15) + 1
        local CollisionX1 = math.modf(tank.Rect.x / 15) + 1
        local CollisionX2 = math.modf((tank.Rect.x + 25) / 15) + 1
        local CollisionX3 = math.modf((tank.Rect.x + 12) / 15) + 1
        if (Map[CollisionY][CollisionX1] == 0 or Map[CollisionY][CollisionX1] == 4) and
        (Map[CollisionY][CollisionX2] == 0 or Map[CollisionY][CollisionX2] == 4) and
        (Map[CollisionY][CollisionX3] == 0 or Map[CollisionY][CollisionX3] == 4) then
            tank.Rect.y = Algorithm.Clamp(tank.Rect.y, 0, 575)
            tank.Rect.y = tank.Rect.y - tank.Speed
        end
    elseif direction == 2 then
        tank.Direction = 2
        local CollisionX = math.modf((tank.Rect.x - tank.Speed) / 15) + 1
        local CollisionY1 = math.modf(tank.Rect.y / 15) + 1
        local CollisionY2 = math.modf((tank.Rect.y + 25) / 15) + 1
        local CollisionY3 = math.modf((tank.Rect.y + 12) / 15) + 1
        if (Map[CollisionY1][CollisionX] == 0 or Map[CollisionY1][CollisionX] == 4) and 
        (Map[CollisionY2][CollisionX] == 0 or Map[CollisionY2][CollisionX] == 4) and 
        (Map[CollisionY3][CollisionX] == 0 or Map[CollisionY3][CollisionX] == 4) then
            tank.Rect.x = Algorithm.Clamp(tank.Rect.x, 0, 575)
            tank.Rect.x = tank.Rect.x - tank.Speed
        end
    elseif direction == 3 then
        tank.Direction = 3
        local CollisionY = math.modf((tank.Rect.y + 25 + tank.Speed) / 15) + 1
        local CollisionX1 = math.modf(tank.Rect.x / 15) + 1
        local CollisionX2 = math.modf((tank.Rect.x + 25) / 15) + 1
        local CollisionX3 = math.modf((tank.Rect.x + 12) / 15) + 1
        --由于要加上Speed,索引可能超出边界,加此特判
        if CollisionY <= 40 then
            if (Map[CollisionY][CollisionX1] == 0 or Map[CollisionY][CollisionX1] == 4) and
            (Map[CollisionY][CollisionX2] == 0 or Map[CollisionY][CollisionX2] == 4) and 
            (Map[CollisionY][CollisionX3] == 0 or Map[CollisionY][CollisionX3] == 4) then
                tank.Rect.y = Algorithm.Clamp(tank.Rect.y, 0, 575)
                tank.Rect.y = tank.Rect.y + tank.Speed
            end
        end
    elseif direction == 4 then
        tank.Direction = 4
        local CollisionX = math.modf((tank.Rect.x + 25 + tank.Speed) / 15) + 1
        local CollisionY1 = math.modf(tank.Rect.y / 15) + 1
        local CollisionY2 = math.modf((tank.Rect.y + 25) / 15) + 1
        local CollisionY3 = math.modf((tank.Rect.y + 12) / 15) + 1
        if (Map[CollisionY1][CollisionX] == 0 or Map[CollisionY1][CollisionX] == 4) and
        (Map[CollisionY2][CollisionX] == 0 or Map[CollisionY2][CollisionX] == 4) and
        (Map[CollisionY3][CollisionX] == 0 or Map[CollisionY3][CollisionX] == 4) then
            tank.Rect.x = Algorithm.Clamp(tank.Rect.x, 0, 575)
            tank.Rect.x = tank.Rect.x + tank.Speed
        end
    end
end

--本关敌方坦克数量
local StageOneAmount = 15

--初始化随机数种子
math.randomseed(os.time())

function EnemyAction(tank)
    RandomAction = math.random(1, 5)
    if RandomAction == 1 then
        tank.MoveDirection = 1
    elseif RandomAction == 2 then
        tank.MoveDirection = 2
    elseif RandomAction == 3 then
        tank.MoveDirection = 3
    elseif RandomAction == 4 then
        tank.MoveDirection = 4
    else tank.MoveDirection = 0
    end
end

function Stage.Run()
    --_state对应着四个方向键的状态
    Media.PlayMusic(Resource.BattleCity, 1)
    local _state = {false, false, false, false}
    local Timing = 0
    local isEnd = false
    local theEnd = 0

    --音乐播放函数在循坏里边,确保该函数只运行一次
    local MusicHasPlay = false

    while QuitScene == 0 do
        local nStartTime = Time.GetInitTime()
        Graphic.SetDrawColor({r = 0, g = 0, b = 0, a = 255})
        Window.ClearWindow()

        if Interactivity.UpdateEvent() then
            local _event = Interactivity.GetEventType()

            if _event == Interactivity.EVENT_QUIT then
                return
            elseif _event == Interactivity.EVENT_KEYDOWN_UP then
                _state[1] = true
            elseif _event == Interactivity.EVENT_KEYUP_UP then
                _state[1] = false
            elseif _event == Interactivity.EVENT_KEYDOWN_LEFT then
                _state[2] = true
            elseif _event == Interactivity.EVENT_KEYUP_LEFT then
                _state[2] = false
            elseif _event == Interactivity.EVENT_KEYDOWN_DOWN then
                _state[3] = true
            elseif _event == Interactivity.EVENT_KEYUP_DOWN then
                _state[3] = false
            elseif _event == Interactivity.EVENT_KEYDOWN_RIGHT then
                _state[4] = true
            elseif _event == Interactivity.EVENT_KEYUP_RIGHT then
                _state[4] = false
            elseif _event == Interactivity.EVENT_KEYDOWN_Z and not isEnd then
                Resource.Bullet:New(Resource.PlayerTank, 15, 1)
                Resource.ShotSound:Play(0)
            end
        end

        --这里因为向上的方向写在最上面
        --即使按住了←→↓,后手按↑依旧会覆盖掉←→↓状态
        --更好的写法还在研究当中
        if _state[1] and not isEnd then
            Move(Resource.PlayerTank, 1)
        elseif _state[2] and not isEnd then
            Move(Resource.PlayerTank, 2)
        elseif _state[3] and not isEnd then
            Move(Resource.PlayerTank, 3)
        elseif _state[4] and not isEnd then
            Move(Resource.PlayerTank, 4)
        end

        --随机生成敌方坦克,第一关设置15辆坦克
        EnemyType = math.random(1, 3)
        if EnemyType == 1 and StageOneAmount > 0 and Resource.Amount < 5 then
            StageOneAmount = StageOneAmount - 1
            Resource.EnemyMiddle:New()
        elseif EnemyType == 2 and StageOneAmount > 0 and Resource.Amount < 5 then
            StageOneAmount = StageOneAmount - 1
            Resource.EnemyHeavy:New()
        elseif EnemyType == 3 and StageOneAmount > 0 and Resource.Amount < 5 then
            StageOneAmount = StageOneAmount - 1
            Resource.EnemyLight:New()
        end

        --绘制坦克
        if Resource.PlayerTank.Health >= 0 then
            Resource.DrawTank(Resource.PlayerTank)
        end
        for k, v in ipairs(Resource.AllEnemy) do
            if Resource.AllEnemy[k].MoveDirection ~= 0 then
                Move(Resource.AllEnemy[k], Resource.AllEnemy[k].MoveDirection)
            end
            Resource.DrawTank(Resource.AllEnemy[k])
            --对每一个坦克进行一个开炮判定
            if math.random(1, 40) == 1 and not isEnd then
                Resource.Bullet:New(Resource.AllEnemy[k], 15, 2)
            end
        end

        --每秒AI坦克随机选择一次方向
        Timing = Timing + 1
        if Timing % 60 == 0 and not isEnd then
            for k, v in ipairs(Resource.AllEnemy) do
                EnemyAction(Resource.AllEnemy[k])
            end
            Timing = 0
        end


        --绘制地图
        for i = 1, 40 do
            for j = 1, 40 do
                if Map[i][j] ~= 0 and Map[i][j] ~= 5 then
                    Graphic.CopyReshapeTexture(
                        Resource.Blocks,
                        Resource.Material[Map[i][j]].Rect,
                        {x = (j - 1) * 15, y = (i - 1) * 15, w = 15, h = 15}
                    )
                end
            end
        end

        if Resource.Home.State == 1 then
            Graphic.CopyReshapeTexture(Resource.Home.Graph, {x = 0, y = 0, w = 30, h = 30}, Resource.Home.Rect)
        elseif Resource.Home.State == 2 then
            Graphic.CopyReshapeTexture(Resource.Home.Graph, {x = 30, y = 30, w = 30, h = 30}, Resource.Home.Rect)
        end

        --操作着炮弹的坐标并绘制炮弹
        --并判定炮弹与其他物体的碰撞
        for i, v in ipairs(Resource.AllBullet) do
            --该部分控制炮弹的位移,并检测与建筑的碰撞
            if Resource.AllBullet[i].Direction == 1 then
                Resource.AllBullet[i].y = Resource.AllBullet[i].y - Resource.AllBullet[i].Speed
                local CollisionY = math.modf((Resource.AllBullet[i].y - Resource.AllBullet[i].Speed) / 15) + 1
                local CollisionX = math.modf((Resource.AllBullet[i].x + 3) / 15) + 1
                if CollisionY >= 1 then
                    if Map[CollisionY][CollisionX] == 1 then
                        Map[CollisionY][CollisionX] = 0
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                    if Map[CollisionY][CollisionX] == 2 then
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                end
            elseif Resource.AllBullet[i].Direction == 2 then
                Resource.AllBullet[i].x = Resource.AllBullet[i].x - Resource.AllBullet[i].Speed
                local CollisionX = math.modf((Resource.AllBullet[i].x - Resource.AllBullet[i].Speed) / 15) + 1
                local CollisionY = math.modf((Resource.AllBullet[i].y + 3) / 15) + 1
                if CollisionX >= 1 then
                    if Map[CollisionY][CollisionX] == 1 then
                        Map[CollisionY][CollisionX] = 0
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                    if Map[CollisionY][CollisionX] == 2 then
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                end
            elseif Resource.AllBullet[i].Direction == 3 then
                Resource.AllBullet[i].y = Resource.AllBullet[i].y + Resource.AllBullet[i].Speed
                local CollisionY = math.modf((Resource.AllBullet[i].y + Resource.AllBullet[i].Speed + 6) / 15) + 1
                local CollisionX = math.modf((Resource.AllBullet[i].x + 3) / 15) + 1
                if CollisionY <= 40 then
                    if Map[CollisionY][CollisionX] == 1 then
                        Map[CollisionY][CollisionX] = 0
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                    if Map[CollisionY][CollisionX] == 2 then
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                end
            elseif Resource.AllBullet[i].Direction == 4 then
                Resource.AllBullet[i].x = Resource.AllBullet[i].x + Resource.AllBullet[i].Speed
                local CollisionX = math.modf((Resource.AllBullet[i].x - Resource.AllBullet[i].Speed + 6) / 15) + 1
                local CollisionY = math.modf((Resource.AllBullet[i].y + 3) / 15) + 1
                if CollisionX <= 40 then
                    if Map[CollisionY][CollisionX] == 1 then
                        Map[CollisionY][CollisionX] = 0
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                    if Map[CollisionY][CollisionX] == 2 then
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                end
            end

            --如果是玩家射出的炮弹,则将该炮弹与所有敌方坦克遍历检测
            if Resource.AllBullet[i].Type == 1 then
                for k, v in ipairs(Resource.AllEnemy) do
                    local hit = Algorithm.CheckRectsOverlap(Resource.AllEnemy[k].Rect,
                        {
                            x = Resource.AllBullet[i].x,
                            y = Resource.AllBullet[i].y,
                            w = 6,
                            h = 6
                        }
                    )
                    if hit then
                        Resource.AllEnemy[k].Health = Resource.AllEnemy[k].Health - 1
                        table.remove(Resource.AllBullet, i)
                        Resource.Number = Resource.Number - 1
                        goto continue
                    end
                end
            --如果是敌方坦克射出的炮弹,则将该炮弹与玩家和老巢进行碰撞箱检测
            elseif Resource.AllBullet[i].Type == 2 then
                local hit = Algorithm.CheckRectsOverlap(Resource.PlayerTank.Rect,
                        {
                            x = Resource.AllBullet[i].x,
                            y = Resource.AllBullet[i].y,
                            w = 6,
                            h = 6
                        }
                    )
                if hit then
                    Resource.PlayerTank.Health = Resource.PlayerTank.Health - 1
                    table.remove(Resource.AllBullet, i)
                    Resource.Number = Resource.Number - 1
                    goto continue
                end

                local hithome = Algorithm.CheckRectsOverlap(Resource.Home.Rect,
                        {
                            x = Resource.AllBullet[i].x,
                            y = Resource.AllBullet[i].y,
                            w = 6,
                            h = 6
                        }
                    )
                if hithome then
                    Resource.BlastSound:Play(0)
                    Resource.Home.State = 2
                    table.remove(Resource.AllBullet, i)
                    Resource.Number = Resource.Number - 1
                    goto continue
                end
            end

            Graphic.CopyReshapeTexture(
                Resource.Bullet.Graph,
                {x = (Resource.AllBullet[i].Direction - 1) * 6, y = 0, w = 6, h = 6},
                {x = Resource.AllBullet[i].x, y = Resource.AllBullet[i].y, w = 6, h = 6}
            )
            --超出边界的炮弹直接删除
            if Resource.AllBullet[i].x < -6 or Resource.AllBullet[i].x > 600 or
                Resource.AllBullet[i].y < -6 or Resource.AllBullet[i].y > 600 then
                    table.remove(Resource.AllBullet, i)
                    Resource.Number = Resource.Number - 1
            end
            ::continue::
        end

        --判断敌我方坦克阵亡与游戏胜利
        for k, v in ipairs(Resource.AllEnemy) do
            if Resource.AllEnemy[k].Health <= 0 then
                Resource.BlastSound:Play(0)
                table.remove(Resource.AllEnemy, k)
                Resource.Amount = Resource.Amount - 1
            end
        end

        if (Resource.PlayerTank.Health <= 0 or Resource.Home.State == 2) and isEnd == false then
            Resource.BlastSound:Play(0)
            isEnd = true
            theEnd = 2
        end
        if StageOneAmount <= 0 and Resource.Amount <= 0 and isEnd == false then
            isEnd = true
            theEnd = 1
        end

        --绘制信息表
        Font = Graphic.LoadFontFromFile("Resource/Font/simhei.ttf", 50)

        local _Title = Graphic.CreateUTF8TextImageBlended(Font, "坦克大战", {r = 156, g = 74, b = 0, a = 255})
        local Title = Graphic.CreateTexture(_Title)
        local _Subtitle = Graphic.CreateUTF8TextImageBlended(Font, "~EtherEngine试验作~", {r = 163, g = 54, b = 182, a = 255})
        local Subtitle = Graphic.CreateTexture(_Subtitle)
        local _Health = Graphic.CreateUTF8TextImageBlended(Font, "[友方生命值]"..Resource.PlayerTank.Health, {r = 0, g = 255, b = 0, a = 255})
        local Health = Graphic.CreateTexture(_Health)
        local _TheAmount = Graphic.CreateUTF8TextImageBlended(Font, "[敌机剩余数]"..StageOneAmount + Resource.Amount, {r = 255, g = 0, b = 0, a = 255})
        local TheAmount = Graphic.CreateTexture(_TheAmount)
        

        Graphic.SetDrawColor({r = 192, g = 192, b = 192, a = 255})
        Graphic.FillRectangle({x = 601, y = 0, w = 300, h = 600})
        Graphic.CopyTexture(Title, {x = 610, y = 10, w = 280, h = 100})
        Graphic.CopyTexture(Subtitle, {x = 610, y = 120, w = 280, h = 30})
        Graphic.CopyTexture(Health, {x = 630, y = 180, w = 240, h = 40})
        Graphic.CopyTexture(TheAmount, {x = 630, y = 240, w = 240, h = 40})
        Graphic.CopyTexture(Resource.Tips, {x = 610, y = 400, w = 280, h = 131})


        --绘制结局字样,因为图层关系当然是最后一个绘制
        if theEnd == 1 then
            local _MissionSuccess = Graphic.CreateUTF8TextImageBlended(Font, "任务成功!你歼灭了所有敌方坦克", {r = 0, g = 255, b = 0, a = 255})
            local MissionSuccess = Graphic.CreateTexture(_MissionSuccess)
            Graphic.CopyTexture(MissionSuccess, {x = 100, y = 270, w = 700, h = 60})
        elseif theEnd == 2 then
            if not MusicHasPlay then
                Media.PlayMusic(Resource.GameOver, -1)
                MusicHasPlay = true
            end
            local _MissionFail = Graphic.CreateUTF8TextImageBlended(Font, "任务失败!没有成功守护住我们的家园", {r = 255, g = 0, b = 0, a = 255})
            local MissionFail = Graphic.CreateTexture(_MissionFail)
            Graphic.CopyTexture(MissionFail, {x = 100, y = 270, w = 700, h = 60})
        end

        Window.UpdateWindow()
        Time.DynamicSleep(1000 / 60, Time.GetInitTime() - nStartTime)
    end
    QuitScene = isEnd
    return QuitScene
end

return Stage