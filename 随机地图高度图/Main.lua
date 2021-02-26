UsingMoudle("Window")
UsingMoudle("Graphic")
UsingMoudle("Algorithm")
UsingMoudle("Interactivity")
UsingMoudle("Time")

_FPS_ = 60

_RECT_WINDOW_ = {
    x = WINDOW_POSITION_DEFAULT,
    y = WINDOW_POSITION_DEFAULT,
    w = 1280,
    h = 720
}

CreateWindow("地图演示", _RECT_WINDOW_, {})

-- 地图中最高点个数的最大值和最小值
_NUM_HP_MAX_, _NUM_HP_MIN_ = 5, 1

-- 地图中最低点个数的最大值和最小值
_NUM_LP_MAX_, _NUM_LP_MIN_ = 10, 5

-- 地图中最高点高度的最大值和最小值
_ALT_HP_MAX_, _ALT_HP_MIN_ = 1000, 800

-- 地图中最低点高度的最大值和最小值
_ALT_LP_MAX_, _ALT_LP_MIN_ = 200, 0

-- 地图中影响点坐标和高度对象
AffectPointList = {}

-- 初始化地图中的最高点列表
for i = 1, math.random(_NUM_HP_MIN_, _NUM_HP_MAX_) do
    table.insert(
        AffectPointList,
        {
            x = math.random(0, _RECT_WINDOW_.w),            -- x 方向坐标
            y = math.random(0, _RECT_WINDOW_.h),            -- y 方向坐标
            alt = math.random(_ALT_HP_MIN_, _ALT_HP_MAX_)   -- 高度
        }   -- 地图中的最高点对象
    )
end

-- 初始化地图中的最低点列表
for i = 1, math.random(_NUM_LP_MIN_, _NUM_LP_MAX_) do
    table.insert(
        AffectPointList,
        {
            x = math.random(0, _RECT_WINDOW_.w),            -- x 方向坐标
            y = math.random(0, _RECT_WINDOW_.h),            -- y 方向坐标
            alt = math.random(_ALT_LP_MIN_, _ALT_LP_MAX_)   -- 高度
        }   -- 地图中的最低点对象
    )
end

-- 输出地图中影响点个数
print("Affection Point Number: "..#AffectPointList)

-- 地图中所有点坐标和高度对象
MapPointList = {}

-- 初始化地图中所有点列表
for X = 0, _RECT_WINDOW_.w do       -- 遍历地图的每一列
    local _RowPointList = {}        -- 地图每一列中的点对象列表
    for Y = 0, _RECT_WINDOW_.h do   -- 遍历每一列中的每一行

        -- 第一次计算地图高度
        local _altitude_1 = 0     -- 当前点高度
        local _totalDist = 0    -- 当前点距离地图上所有影响点的距离总和
        for _, afp in ipairs(AffectPointList) do     -- 遍历每个影响点计算当前点距离地图上所有影响点的距离总和
            local _dist = math.sqrt((X - afp.x) ^ 2 + (Y - afp.y) ^ 2)
            _totalDist = _totalDist + _dist
        end
        for _, afp in ipairs(AffectPointList) do    -- 遍历每个影响点计算当前点高度
            local _dist = math.sqrt((X - afp.x) ^ 2 + (Y - afp.y) ^ 2)
            _altitude_1 = _altitude_1 + (1 - _dist / _totalDist) * afp.alt / (#AffectPointList - 1)
        end

        -- 第二次计算地图高度
        local _altitude_2 = 0
        local _totalRecip = 0   -- 当前点距离地图上所有影响点距离的倒数总和
        for _, afp in ipairs(AffectPointList) do     -- 遍历每个影响点计算当前点距离地图上所有影响点距离的倒数总和
            local _dist = math.sqrt((X - afp.x) ^ 2 + (Y - afp.y) ^ 2)
            _totalRecip = _totalRecip + 1 / _dist
        end
        for _, afp in ipairs(AffectPointList) do    -- 遍历每个影响点计算当前点高度
            local _dist = math.sqrt((X - afp.x) ^ 2 + (Y - afp.y) ^ 2)
            _altitude_2 = _altitude_2 + 1 / _dist / _totalRecip * afp.alt
        end

        table.insert(
            _RowPointList,
            {
                x = X,
                y = Y,
                alt = _altitude_1 * 0.9925 + _altitude_2 * 0.0075     -- 合并两次地图高度生成的权重和
            }
        )
    end
    table.insert(MapPointList, _RowPointList)
end

-- 地图上最高点高度和最低点高度
MaxAlt, MinAlt = 0, 1000

-- 获取地图上最高点高度和最低点高度
for _, RowPointList in ipairs(MapPointList) do
    for _, point in ipairs(RowPointList) do
        if point.alt > MaxAlt then MaxAlt = point.alt end
        if point.alt < MinAlt then MinAlt = point.alt end
    end
end

-- 将地图上的点高度归一化后将高度范围调整为 0 ~ 1000
for _, RowPointList in ipairs(MapPointList) do
    for _, point in ipairs(RowPointList) do
        point.alt = (point.alt - MinAlt) / (MaxAlt- MinAlt) * 1000
    end
end

-- 为地图上的点着色
for _, RowPointList in ipairs(MapPointList) do
    for _, point in ipairs(RowPointList) do
        SetDrawColor(HSLAToRGBA({h = (1 - point.alt / 1000) * 240, s = 1, l = 0.35, a = 1}))
        Point(point)
    end
end

-- 绘制影响点中心
for _, afp in ipairs(AffectPointList) do
    SetDrawColor({r = 255, g = 255, b = 255, a = 215})
    FillRectangle(
        {
            x = afp.x - 2.5,
            y = afp.y - 2.5,
            w = 5,
            h = 5
        }
    )
end

while true do 
    local _start = GetInitTime()
    if UpdateEvent() then
        local _event = GetEventType()
        if _event == EVENT_QUIT then
            break
        end
    end
    UpdateWindow()
    local _end = GetInitTime()
    DynamicSleep(1000 / _FPS_, _end - _start)
end