Debug = UsingModule("Debug")
Graphic = UsingModule("Graphic")

Resource = {}

Resource.simhei = Graphic.LoadFontFromFile("Resource/Font/simhei.ttf", 50)
Resource.block = Graphic.LoadImageFromFile("Resource/Image/block.png")
Resource.sky = Graphic.LoadImageFromFile("Resource/Image/Sky.png")
Resource.mountain = Graphic.LoadImageFromFile("Resource/Image/Mountain.png")
Resource.cracks = Graphic.LoadImageFromFile("Resource/Image/Crack.png")
Resource._itemColumn = Graphic.LoadImageFromFile("Resource/Image/ItemColumn.png")
Resource._select = Graphic.LoadImageFromFile("Resource/Image/Select.png")
Resource._knapsack = Graphic.LoadImageFromFile("Resource/Image/Knapsack.png")

local block = Graphic.CreateTexture(Resource.block)
local itemColumn = Graphic.CreateTexture(Resource._itemColumn)
local select = Graphic.CreateTexture(Resource._select)
local knapsack = Graphic.CreateTexture(Resource._knapsack)

--绿幕贴图
Resource.CharacterImage = Graphic.LoadImageFromFile("Resource/Image/Character.png")
Resource.CharacterImage:SetColorKey(true, {r = 0, g = 255, b = 0, a = 255})

--初始主角信息
Resource.Leader =
{
    Rect = {x = 1950 * 30, y = 195 * 30, w = 30, h = 90},
    Image = Graphic.CreateTexture(Resource.CharacterImage),
    layer = nil,
    xSpeed = 0,
    ySpeed = 0,
    xMaxSpeed = 8,
    yMaxSpeed = 15,
    Acceleration = 0.8,
    JumpAbility = 10,
    ItemColumn = {},
    Knapsack = {}
    --Health = 20,
    --Hunger = 100,
}

local Material = {}
--方块在素材中的矩形位置
for i = 1, 7 do
    Material[i] = 
    {
        Rect = {
            x = (i - 1) * 100,
            y = 0,
            w = 100,
            h = 100
        }
    }
end

--4种裂缝依次排序
Resource.arrayCracks = {}
for i = 1, 4 do
    Resource.arrayCracks[i] = 
    {
        Rect = {
            x = (i - 1) * 100,
            y = 0,
            w = 100,
            h = 100
        }
    }
end

--所有方块的硬度
Resource.Hardness = {40, 40, 100, 100, 100, 60, 20}

--生成一个400格高,2000格宽的世界(规模有点大呢)
Resource.Map = {}
function Resource.CreateWorld()
    local treeAmount = math.random(60, 80)
    local mineralAmount = math.random(2000, 2500)
    for i = 1, 400 do
        Resource.Map[i] = {}
    end
    for i = 1, 199 do
        for j = 1, 2000 do
            Resource.Map[i][j] = 0
        end
    end
    Debug.ConsoleLog("正在生成泥土,5%")
    for i = 200, 210 do
        for j = 1, 2000 do
            Resource.Map[i][j] = 1
        end
    end
    for j = 1, 2000 do
        Resource.Map[200][j] = 2
    end
    Debug.ConsoleLog("正在生成石块,20%")
    for i = 211, 400 do
        for j = 1, 2000 do
            Resource.Map[i][j] = 3
        end
    end
    Debug.ConsoleLog("正在生成矿石,60%")
    for j = 1, mineralAmount do
        local xPosition = math.random(1, 2000)
        local yPosition = math.random(211, 400)
        Resource.Map[yPosition][xPosition] = math.random(4, 5)
    end
    Debug.ConsoleLog("正在生成树,80%")
    for j = 1, treeAmount do
        local nPosition = math.random(1, 2000)
        local nHeight = math.random(5, 7)
        for i = 199, 199 - nHeight, -1 do
            Resource.Map[i][nPosition] = 6
        end
        --生成树叶(暂时用比较固定的生成方法)(顶部按531的顺序排上去...)
        for i = 1, 5 do
            Resource.Map[199 - nHeight][nPosition - 3 + i] = 7
        end
        for i = 1, 3 do
            Resource.Map[199 - nHeight - 1][nPosition - 2 + i] = 7
        end
        Resource.Map[199 - nHeight - 2][nPosition] = 7
    end
    Debug.ConsoleLog("超平坦世界生成完毕,100%")
end

--对象表,每个对象应当拥有Rect(绘制矩形),Image(纹理数据),layer(图层)
Resource.vObjectTable = {}

Resource.Camera = 
{
    --摄像机拍摄的范围(一般是跟随玩家)
    Rect = {x = 0, y = 0, w = Global.WINDOWSIZE_W, h = Global.WINDOWSIZE_H},
    --摄像机跟随的速度
    Speed = 10,
    --摄像机跟随的对象
    Object = nil
}

--选取摄像机跟随的对象并初始化
function Resource.Camera.Init(object)
    Resource.Camera.Object = object
    table.sort(Resource.vObjectTable, function (a, b)
        if a ~= nil and b ~= nil then
            return (a.Layer < b.Layer)
        end
    end)
    Resource.Camera.Rect.x = Resource.Camera.Object.Rect.x - Global.WINDOWSIZE_W / 2
    Resource.Camera.Rect.y = Resource.Camera.Object.Rect.y - Global.WINDOWSIZE_H / 1.5
end

--将摄像机拍摄到的图像打印在屏幕上
local _tempRect = {x = 0, y = 0, w = 0, h = 0}
function Resource.Camera.Output()
    if Resource.Camera.Rect.x >= 0 and Resource.Camera.Rect.y >= 0 and Resource.Camera.Rect.x <= 2000 * 30 and Resource.Camera.Rect.y <= 400 * 30 then
        Resource.Camera.Rect.x = Resource.Camera.Object.Rect.x - Global.WINDOWSIZE_W / 2
        Resource.Camera.Rect.y = Resource.Camera.Object.Rect.y - Global.WINDOWSIZE_H / 1.5
    end
    if Resource.Camera.Rect.x < 0 then
        Resource.Camera.Rect.x = 0
    elseif Resource.Camera.Rect.x + Resource.Camera.Rect.w > 2000 * 30 then
        Resource.Camera.Rect.x = 2000 * 30 - Resource.Camera.Rect.w
    elseif Resource.Camera.Rect.y < 0 then
        Resource.Camera.Rect.y = 0
    elseif Resource.Camera.Rect.y + Resource.Camera.Rect.h > 400 * 30 then
        Resource.Camera.Rect.y = 400 * 30 - Resource.Camera.Rect.h
    end
    _tempRect.w, _tempRect.h = 30, 30
    for i = math.floor(Resource.Camera.Rect.x / 30) + 1, math.ceil((Resource.Camera.Rect.x + Resource.Camera.Rect.w) / 30) do
        for j = math.floor(Resource.Camera.Rect.y / 30) + 1, math.ceil((Resource.Camera.Rect.y + Resource.Camera.Rect.h) / 30) do
            _tempRect.x, _tempRect.y = (i - 1) * 30 - Resource.Camera.Rect.x, (j - 1) * 30 - Resource.Camera.Rect.y
            if Resource.Map[j][i] ~= 0 then
                Graphic.CopyReshapeTexture(block, Material[Resource.Map[j][i]].Rect, _tempRect)
            end
        end
    end
    for k, v in ipairs(Resource.vObjectTable) do
        _tempRect.x, _tempRect.y = v.Rect.x - Resource.Camera.Rect.x, v.Rect.y - Resource.Camera.Rect.y
        _tempRect.w, _tempRect.h = v.Rect.w, v.Rect.h
        Graphic.CopyTexture(v.Image, _tempRect)
    end
end

--背包,物品栏模块
local _columnRect = {x = 30, y = 30, w = 450, h = 50}
local _itemRect = {x = 0, y = 40, w = 30, h = 30}
local _amountRect = {x = 0, y = 60, w = 20 , h = 20}
local whiteRGB = {r = 255, g = 255, b = 255, a = 255}
local _selectRect = {x = 30, y = 30, w = 50, h = 50}
local _knapsackRect = {x = 30, y = 100, w = 450, h = 300}
local _characterRect = {x = 40, y = 130, w = 30, h = 90}

--初始化物品栏和背包
function Resource.KnapsackInit()
    for i = 1, 9 do
        Resource.Leader.ItemColumn[i] =
        {
            Material = 0,
            Amount = 0
        }
    end
    for i = 1, 3 do
        Resource.Leader.Knapsack[i] = {}
        for j = 1, 9 do
            Resource.Leader.Knapsack[i][j] =
            {
                Material = 0,
                Amount = 0
            }
        end
    end
end

function Resource.ColumnOutput(isKnapsackOpen, selectItem)
    Graphic.CopyTexture(itemColumn, _columnRect)
    for i = 1, 9 do
        if Resource.Leader.ItemColumn[i].Material ~= 0 and Resource.Leader.ItemColumn[i].Amount ~= 0 then
            _itemRect.x = _columnRect.x + (i - 1) * 50 + 10
            Graphic.CopyReshapeTexture(block, Material[Resource.Leader.ItemColumn[i].Material].Rect, _itemRect)
            if Resource.Leader.ItemColumn[i].Amount ~= 1 then
                local _amount = Graphic.CreateUTF8TextImageBlended(Resource.simhei, Resource.Leader.ItemColumn[i].Amount, whiteRGB)
                local amount = Graphic.CreateTexture(_amount)
                _amountRect.x = _itemRect.x + 20
                Graphic.CopyTexture(amount, _amountRect)
            end
        end
        if i == selectItem then
            _selectRect.x = (i - 1) * 50 + 30
            Graphic.CopyTexture(select, _selectRect)
        end
    end
    if isKnapsackOpen then
        Graphic.CopyTexture(knapsack, _knapsackRect)
        Graphic.CopyTexture(Resource.Leader.Image, _characterRect)
        for i = 1, 3 do
            for j = 1, 9 do
                if Resource.Leader.Knapsack[i][j].Material ~= 0 and Resource.Leader.Knapsack[i][j].Amount ~= 0 then
                    _itemRect.x = _knapsackRect.x + (j - 1) * 50 + 10
                    _itemRect.y = _knapsackRect.y + (i - 1) * 50 + 160
                    Graphic.CopyReshapeTexture(block, Material[Resource.Leader.Knapsack[i][j].Material].Rect, _itemRect)
                    if Resource.Leader.Knapsack[i][j].Amount ~= 1 then
                        local _amount = Graphic.CreateUTF8TextImageBlended(Resource.simhei, Resource.Leader.Knapsack[i][j].Amount, whiteRGB)
                        local amount = Graphic.CreateTexture(_amount)
                        _amountRect.x = _itemRect.x + 20
                        _amountRect.y = _itemRect.y + 20
                        Graphic.CopyTexture(amount, _amountRect)
                    end
                end
            end
        end
    end
    _amountRect.y = 60
    _itemRect.y = 40
end

local theHold =
{
    Material = 0,
    Amount = 0,
    Rect = {x = 0, y = 0, w = 30, h = 30},
    AmountRect = {x = 0, y = 0, w = 20, h = 20}
}
function Resource.KnapsackMove(CursorPosition, leftButtonUp)
    --检测鼠标是否在物品栏的矩形范围内,如果玩家左键点击且还没有选择物品
    if CursorPosition.x >= _columnRect.x and CursorPosition.x <= _columnRect.x + _columnRect.w
    and CursorPosition.y >= _columnRect.y and CursorPosition.y <= _columnRect.y + _columnRect.h and leftButtonUp and theHold.Material == 0 then
        local thePosition = math.floor((CursorPosition.x + 20) / 50)
        if Resource.Leader.ItemColumn[thePosition].Material ~= 0 then
            theHold.Material = Resource.Leader.ItemColumn[thePosition].Material
            theHold.Amount = Resource.Leader.ItemColumn[thePosition].Amount
            Resource.Leader.ItemColumn[thePosition].Material = 0
            Resource.Leader.ItemColumn[thePosition].Amount = 0
        end
        --检测鼠标是否在背包的矩形范围内,如果玩家左键点击且还没有选择物品
    elseif CursorPosition.x >= _knapsackRect.x and CursorPosition.x <= _knapsackRect.x + _knapsackRect.w
    and CursorPosition.y >= _knapsackRect.y + 150 and CursorPosition.y <= _knapsackRect.y + _knapsackRect.h + 150 and leftButtonUp and theHold.Material == 0 then
        local thePositionX = math.floor((CursorPosition.x + 20) / 50)
        local thePositionY = math.floor((CursorPosition.y - 200) / 50)
        if Resource.Leader.Knapsack[thePositionY][thePositionX].Material ~= 0 then
            theHold.Material = Resource.Leader.Knapsack[thePositionY][thePositionX].Material
            theHold.Amount = Resource.Leader.Knapsack[thePositionY][thePositionX].Amount
            Resource.Leader.Knapsack[thePositionY][thePositionX].Material = 0
            Resource.Leader.Knapsack[thePositionY][thePositionX].Amount = 0
        end
    --再次点击即可把物品放在物品栏里
    elseif CursorPosition.x >= _columnRect.x and CursorPosition.x <= _columnRect.x + _columnRect.w
    and CursorPosition.y >= _columnRect.y and CursorPosition.y <= _columnRect.y + _columnRect.h and leftButtonUp and theHold.Material ~= 0 then
        local thePosition = math.floor((CursorPosition.x + 20) / 50)
        --如果该格物品栏已经有东西就互相交换,没有就直接放上去
        if Resource.Leader.ItemColumn[thePosition].Material ~= 0 and Resource.Leader.Knapsack[thePosition].Material ~= theHold.Material then
            local tempMaterial = theHold.Material
            local tempAmount = theHold.Amount
            theHold.Material = Resource.Leader.ItemColumn[thePosition].Material
            theHold.Amount = Resource.Leader.ItemColumn[thePosition].Amount
            Resource.Leader.ItemColumn[thePosition].Material = tempMaterial
            Resource.Leader.ItemColumn[thePosition].Amount = tempAmount
        elseif Resource.Leader.ItemColumn[thePosition].Material == theHold.Material then
            Resource.Leader.ItemColumn[thePosition].Amount = Resource.Leader.ItemColumn[thePosition].Amount + theHold.Amount
            theHold.Material = 0
            theHold.Amount = 0
        else
            Resource.Leader.ItemColumn[thePosition].Material = theHold.Material
            Resource.Leader.ItemColumn[thePosition].Amount = theHold.Amount
            theHold.Material = 0
            theHold.Amount = 0
        end
    elseif CursorPosition.x >= _knapsackRect.x and CursorPosition.x <= _knapsackRect.x + _knapsackRect.w
    and CursorPosition.y >= _knapsackRect.y + 150 and CursorPosition.y <= _knapsackRect.y + _knapsackRect.h + 150 and leftButtonUp and theHold.Material ~= 0 then
        local thePositionX = math.floor((CursorPosition.x + 20) / 50)
        local thePositionY = math.floor((CursorPosition.y - 200) / 50)
        --如果该格物品栏已经有东西就互相交换,如果一样就合并,没有就直接放上去
        if Resource.Leader.Knapsack[thePositionY][thePositionX].Material ~= 0 and Resource.Leader.Knapsack[thePositionY][thePositionX].Material ~= theHold.Material then
            local tempMaterial = theHold.Material
            local tempAmount = theHold.Amount
            theHold.Material = Resource.Leader.Knapsack[thePositionY][thePositionX].Material
            theHold.Amount = Resource.Leader.Knapsack[thePositionY][thePositionX].Amount
            Resource.Leader.Knapsack[thePositionY][thePositionX].Material = tempMaterial
            Resource.Leader.Knapsack[thePositionY][thePositionX].Amount = tempAmount
        elseif Resource.Leader.Knapsack[thePositionY][thePositionX].Material == theHold.Material then
            Resource.Leader.Knapsack[thePositionY][thePositionX].Amount = Resource.Leader.Knapsack[thePositionY][thePositionX].Amount + theHold.Amount
            theHold.Material = 0
            theHold.Amount = 0
        else
            Resource.Leader.Knapsack[thePositionY][thePositionX].Material = theHold.Material
            Resource.Leader.Knapsack[thePositionY][thePositionX].Amount = theHold.Amount
            theHold.Material = 0
            theHold.Amount = 0
        end
    end
    if theHold.Material ~= 0 then
        theHold.Rect.x = CursorPosition.x - theHold.Rect.w
        theHold.Rect.y = CursorPosition.y - theHold.Rect.h
        Graphic.CopyReshapeTexture(block, Material[theHold.Material].Rect, theHold.Rect)
        if theHold.Amount ~= 0 then
            local _amount = Graphic.CreateUTF8TextImageBlended(Resource.simhei, theHold.Amount, whiteRGB)
            local amount = Graphic.CreateTexture(_amount)
            theHold.AmountRect.x = theHold.Rect.x + 20
            theHold.AmountRect.y = theHold.Rect.y + 20
            Graphic.CopyTexture(amount, theHold.AmountRect)
        end
    end
end

return Resource