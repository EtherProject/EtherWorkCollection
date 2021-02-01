UsingMoudle("Window")
UsingMoudle("Graphic")
UsingMoudle("Interactivity")
UsingMoudle("Time")

-- 帧率
__FPS__ = 60

-- 程序是否运行标志
_RUNNING_ = true

-- 敌人移动帧间隔
_ENEMY_MOVE_DELAY_ = 30
-- 敌人移动定时器
timer_enemy_move = 0

-- 玩家位置
pos_player = nil
-- 敌人1、2位置
pos_enemy_1, pos_enemy_2 = nil, nil

-- 是否成功
isSuccess = false
-- 是否失败
isFailure = false

-- 玩家纹理旋转角度
angle_rotate_player = 0
-- 玩家纹理旋转方式
mode_rotate_player = {FLIP_NONE}

-- 地图数据
map = {}
-- 地图单元格数据表
map_cell_list = {}

-- 定义分割字符串函数
function split(str, reps)
    local resultStrList = {}
    string.gsub(str, '[^' .. reps .. ']+', function(w)
        table.insert(resultStrList, w)
    end)
    return resultStrList
end

-- 打开scene.txt文件并读取配置信息
file = io.open("scene.txt", "r")
string_meta_info = file:read()
meta_info = split(string_meta_info, ",")
pos_player = {row = tonumber(meta_info[1]), column = tonumber(meta_info[2])}
pos_enemy_1, pos_enemy_2 = {row = tonumber(meta_info[3]), column = tonumber(meta_info[4])}, {row = tonumber(meta_info[5]), column = tonumber(meta_info[6])}
for i = 1, 10 do
    local _line = file:read()
    local _temp = {}
    for j = 1, 10 do
        table.insert(_temp, tonumber(string.sub(_line, j, j)))
    end
    table.insert(map, _temp)
end
file:close()

-- 检查玩家或敌人是否处于空闲方格上
assert(
    map[pos_player.row][pos_player.column] == 0 and
    map[pos_enemy_1.row][pos_enemy_1.column] == 0 and
    map[pos_enemy_2.row][pos_enemy_2.column] == 0,
    "玩家或敌人的初始位置不能位于墙壁方格上"
)
-- 用以描述窗口位置和大小的矩形
_RECT_WINDOW_ = {x = WINDOW_POSITION_DEFAULT, y = WINDOW_POSITION_DEFAULT, w = 625, h = 480}
-- 用以描述游戏地图位置和大小的矩形
_RECT_MAP_ = {x = _RECT_WINDOW_.w / 2 - 200, y = _RECT_WINDOW_.h / 2 - 200 + 10, w = 400, h = 400}
-- 用以描述地图单元格位置和大小的矩形列表，为二维数组
_RECT_CELL_LIST_ = {}

-- 初始化地图单元格矩形列表
for i = 0, 9 do
    local _temp = {}
    for j = 0, 9 do
        table.insert(_temp, {
            x = _RECT_MAP_.x + _RECT_MAP_.w / 10 * j,
            y = _RECT_MAP_.y + _RECT_MAP_.h / 10 * i,
            w = _RECT_MAP_.w / 10,
            h = _RECT_MAP_.h / 10
        })
    end
    table.insert(_RECT_CELL_LIST_, _temp)
end

-- 生成地图单元格数据表
for row = 1, 10 do
    local _row_cell_list = {}
    for column = 1, 10 do
        table.insert(_row_cell_list, {
            rect = _RECT_CELL_LIST_[row][column],
            value = map[row][column],
            isEmpty = false
        })
    end
    table.insert(map_cell_list, _row_cell_list)
end

-- 将玩家所在单元格置空
map_cell_list[pos_player.row][pos_player.column].isEmpty = true

-- 创建指定标题的窗口
CreateWindow("吃豆人", _RECT_WINDOW_, {})

-- 加载玩家图片
image_player = LoadImage("player.png")
-- 创建玩家纹理
texture_player = CreateTexture(image_player)
-- 获取玩家图片尺寸
width_image_player, height_image_player = GetImageSize(image_player)

-- 加载字体文件
_FONT_ = LoadFont("SIMYOU.TTF", 20)
SetFontStyle(_FONT_, {FONT_STYLE_BOLD, FONT_STYLE_ITALIC})

-- 创建score单词文字图片
image_score_word_text = CreateUTF8TextImageBlended(_FONT_, "SCORE", {r = 255, g = 255, b = 255, a = 255})
-- 创建score单词文字纹理
texture_score_word_text = CreateTexture(image_score_word_text)
-- 获取score单词文字图片尺寸
width_image_score_word_text, height_image_score_word_text = GetImageSize(image_score_word_text)

-- 玩家得分
score = 0

-- 绘制计分板函数
function DrawScorePanel()
    -- 创建分数数字图片
    local image_score_num_text = CreateUTF8TextImageBlended(_FONT_, score, {r = 255, g = 255, b = 255, a = 255})
    -- 创建分数数字纹理
    local texture_score_num_text = CreateTexture(image_score_num_text)
    -- 获取分数数字图片尺寸
    local width_image_num_word_text, height_image_num_word_text = GetImageSize(image_score_num_text)
    -- 将score单词和分数数字图片渲染到屏幕上
    CopyTexture(texture_score_word_text, {
        x = _RECT_WINDOW_.w / 2 - width_image_score_word_text / 2 - 40,
        y = 15,
        w = width_image_score_word_text,
        h = height_image_score_word_text
    })
    CopyTexture(texture_score_num_text, {
        x = _RECT_WINDOW_.w / 2 - width_image_score_word_text / 2 + 40,
        y = 15,
        w = width_image_num_word_text,
        h = height_image_num_word_text
    })
    -- 释放分数数字图片和纹理的内存
    DestroyTexture(texture_score_num_text)
    UnloadImage(image_score_num_text)
end

-- 绘制地图函数
function DrawMapPanel()
    -- 绘制地图区域底色和外边框
    SetDrawColor({r = 128, g = 152, b = 155, a = 255})
    FillRectangle(_RECT_MAP_)
    -- 绘制地图单元格
    for _, row in ipairs(map_cell_list) do
        for __, cell in ipairs(row) do
            -- 绘制单元格外边框
            SetDrawColor({r = 141, g = 100, b = 73, a = 255})
            Rectangle(cell.rect)
            -- 绘制单元格底色和金豆
            if cell.value == 0 then
                SetDrawColor({r = 255, g = 255, b = 255, a = 255})
                FillRectangle(cell.rect)
                if not cell.isEmpty then
                    SetDrawColor({r = 250, g = 191, b = 20, a = 255})
                    FillCircle({x = cell.rect.x + cell.rect.w / 2, y = cell.rect.y + cell.rect.h / 2}, 8)
                end
            end
        end
    end
end

-- 绘制玩家和敌人函数
function DrawPlayerAndEnemies()
    -- 绘制玩家
    local _temp_rect = map_cell_list[pos_player.row][pos_player.column].rect
    CopyRotateTexture(texture_player,
        angle_rotate_player,
        {x = width_image_player / 2 / 6, y = height_image_player / 2 / 6},
        mode_rotate_player,
        {x = _temp_rect.x + _temp_rect.w / 2 - 15, y = _temp_rect.y + _temp_rect.h / 2 - 15, w = 30, h = 30})
    -- 绘制敌人1和2
    SetDrawColor({r = 22, g = 74, b = 132, a = 255})
    _temp_rect = map_cell_list[pos_enemy_1.row][pos_enemy_1.column].rect
    FillRectangle({x = _temp_rect.x + _temp_rect.w / 2 - 12, y = _temp_rect.y + _temp_rect.h / 2 - 12, w = 24, h = 24})
    _temp_rect = map_cell_list[pos_enemy_2.row][pos_enemy_2.column].rect
    FillRectangle({x = _temp_rect.x + _temp_rect.w / 2 - 12, y = _temp_rect.y + _temp_rect.h / 2 - 12, w = 24, h = 24})
end

-- 处理数据函数
function ProcessData()
    -- 判断是否失败：碰触到怪物
    if (pos_player.row == pos_enemy_1.row and pos_player.column == pos_enemy_1.column)
        or (pos_player.row == pos_enemy_2.row and pos_player.column == pos_enemy_2.column)
    then
        isFailure = true
        _RUNNING_ = false
        return
    end
    -- 判断是否成功：吃完全部金豆
    local _isAllEmpty = true
    for _, row in ipairs(map_cell_list) do
        for __, cell in ipairs(row) do
            if cell.value == 0 and not cell.isEmpty then _isAllEmpty = false end
        end
    end
    if _isAllEmpty then
        isSuccess = true
        _RUNNING_ = false
        return
    end
    -- 如果当前玩家所在的单元格存在金豆，则分数增加并将此单元格置空
    if not map_cell_list[pos_player.row][pos_player.column].isEmpty then
        score = score + 1
        map_cell_list[pos_player.row][pos_player.column].isEmpty = true
    end
end

-- 随机移动敌人
function MoveEnemies()
    -- 敌人在当前位置可移动的方向列表
    local _available_direction_list = {}
    -- 分别判断敌人1的上下左右方向是否可以移动，并且添加到列表中
    if map_cell_list[pos_enemy_1.row - 1][pos_enemy_1.column].value == 0 then
        table.insert(_available_direction_list, {row = -1, column = 0})
    end
    if map_cell_list[pos_enemy_1.row + 1][pos_enemy_1.column].value == 0 then
        table.insert(_available_direction_list, {row = 1, column = 0})
    end
    if map_cell_list[pos_enemy_1.row][pos_enemy_1.column - 1].value == 0 then
        table.insert(_available_direction_list, {row = 0, column = -1})
    end
    if map_cell_list[pos_enemy_1.row][pos_enemy_1.column + 1].value == 0 then
        table.insert(_available_direction_list, {row = 0, column = 1})
    end
    -- 随机方向
    local _random_direction = _available_direction_list[math.random(1, #_available_direction_list)]
    -- 根据获取到的随机方向移动敌人1
    pos_enemy_1 = {row = pos_enemy_1.row + _random_direction.row, column = pos_enemy_1.column + _random_direction.column}
    -- 对敌人2进行相同的处理过程
    _available_direction_list = {}
    if map_cell_list[pos_enemy_2.row - 1][pos_enemy_2.column].value == 0 then
        table.insert(_available_direction_list, {row = -1, column = 0})
    end
    if map_cell_list[pos_enemy_2.row + 1][pos_enemy_2.column].value == 0 then
        table.insert(_available_direction_list, {row = 1, column = 0})
    end
    if map_cell_list[pos_enemy_2.row][pos_enemy_2.column - 1].value == 0 then
        table.insert(_available_direction_list, {row = 0, column = -1})
    end
    if map_cell_list[pos_enemy_2.row][pos_enemy_2.column + 1].value == 0 then
        table.insert(_available_direction_list, {row = 0, column = 1})
    end
    _random_direction = _available_direction_list[math.random(1, #_available_direction_list)]
    pos_enemy_2 = {row = pos_enemy_2.row + _random_direction.row, column = pos_enemy_2.column + _random_direction.column}
end

-- 显示游戏结果函数
function ShowResult(content, color)
    local _font = LoadFont("SIMYOU.TTF", 50)
    SetFontStyle(_font, {FONT_STYLE_UNDERLINE})
    local _image = CreateUTF8TextImageBlended(_font, content, color)
    local _texture = CreateTexture(_image)
    local _width_image, _height_image = GetImageSize(_image)
    local _rect_panel = {x = _RECT_WINDOW_.w / 2 - 275, y = _RECT_WINDOW_.h / 2 - 50, w = 550, h = 100}
    SetDrawColor({r = 112, g = 91, b = 103, a = 235})
    Rectangle({x = _rect_panel.x - 3, y = _rect_panel.y - 3, w = _rect_panel.w + 6, h = _rect_panel.h + 6})
    SetDrawColor({r = 113, g = 104, b = 108, a = 235})
    FillRectangle(_rect_panel)
    CopyTexture(_texture, {x = _rect_panel.x + _rect_panel.w / 2 - _width_image / 2, y = _rect_panel.y + _rect_panel.h / 2 - _height_image / 2, w = _width_image, h = _height_image})
end

-- 循环渲染，保持窗口
while _RUNNING_ do
    -- 记录得到当前帧开始时间
    local _frame_start_time = GetInitTime()
    
    -- 清空屏幕
    SetDrawColor({r = 75, g = 166, b = 167, a = 255})
    ClearWindow()
    
    -- 如果当前事件队列中有未处理事件
    if UpdateEvent() then
        -- 获取未处理事件类型
        local _event = GetEventType()
        -- 如果是退出事件则退出渲染循环
        if _event == EVENT_QUIT then
            break
        -- 根据键盘事件对玩家图片显示方向进行调整并尝试移动到新位置
        elseif _event == EVENT_KEYDOWN_UP then
            angle_rotate_player = 270
            mode_rotate_player = {FLIP_NONE}
            if map_cell_list[pos_player.row - 1][pos_player.column].value == 0 then
                pos_player.row = pos_player.row - 1
            end
        elseif _event == EVENT_KEYDOWN_DOWN then
            angle_rotate_player = 90
            mode_rotate_player = {FLIP_NONE}
            if map_cell_list[pos_player.row + 1][pos_player.column].value == 0 then
                pos_player.row = pos_player.row + 1
            end
        elseif _event == EVENT_KEYDOWN_LEFT then
            angle_rotate_player = 0
            mode_rotate_player = {FLIP_HORIZONTAL}
            if map_cell_list[pos_player.row][pos_player.column - 1].value == 0 then
                pos_player.column = pos_player.column - 1
            end
        elseif _event == EVENT_KEYDOWN_RIGHT then
            angle_rotate_player = 0
            mode_rotate_player = {FLIP_NONE}
            if map_cell_list[pos_player.row][pos_player.column + 1].value == 0 then
                pos_player.column = pos_player.column + 1
            end
        end
    end
    
    DrawMapPanel()
    DrawScorePanel()
    
    if timer_enemy_move >= _ENEMY_MOVE_DELAY_ then
        MoveEnemies()
        timer_enemy_move = 0
    else
        timer_enemy_move = timer_enemy_move + 1
    end
    
    DrawPlayerAndEnemies()
    
    ProcessData()

    if isSuccess then
        ShowResult("游 戏 成 功", {r = 162, g = 32, b = 65, a = 255})
    elseif isFailure then
        ShowResult("游 戏 失 败", {r = 15, g = 35, b = 80, a = 255})
    end
    
    UpdateWindow()

    if not _RUNNING_ then Sleep(2500) end
    
    -- 记录得到当前帧结束时间
    local _frame_end_time = GetInitTime()
    -- 结束时间与开始时间作差得到当前帧渲染耗时
    local _frame_delay = _frame_end_time - _frame_start_time
    -- 如果当前帧渲染耗时小于帧率要求，则进行适当的延时
    if _frame_delay < 1000 / __FPS__ then
        Sleep(1000 / __FPS__ - _frame_delay)
    end
end
