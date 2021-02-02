UsingMoudle("All")

x_1 = 420
y_1 = 270
game = 1       --判断是否游戏结束
point = 0
I = 3
times = 1
x = 30         --x为蛇的左右方向
y = 0          --y为蛇的上下方向

snake = {}    --初始身长
snake[1] = {}
snake[2] = {}
snake[3] = {}
snake[1].x = x_1
snake[1].y = y_1
snake[2].x = 390
snake[2].y = 270
snake[3].x = 360
snake[3].y = 270

color = {}
color.r = 0
color.g = 0
color.b = 0
color.a = 255


color_2 = {}
color_2.r = 255
color_2.g = 255
color_2.b = 255
color_2.a = 255

CreateWindow("贪吃蛇",{x = WINDOW_POSITION_DEFAULT,y = WINDOW_POSITION_DEFAULT, w = 900, h = 600},{ })  --创建窗口

image_background = LoadImage("./background.png")
textrue_background = CreateTexture(image_background)

image_food = LoadImage("./food_2.png")
textrue_food = CreateTexture(image_food)

math.randomseed(os.time())    --获取食物位置
timenow = os.time()
food_x = math.random(1,29)
food_y = math.random(1,19)

while true do
    
    UpdateWindow()   --将缓存区纹理冲刷到屏幕

    while times == 2000 and game == 1 do
        
    CopyTexture(textrue_background,{x = 0,y = 0,w = 900,h = 600})
    CopyTexture(textrue_food,{x = 30 * food_x -20,y = 30 * food_y - 20,w = 45,h = 45})

    if UpdateEvent() then  --获取玩家操作
    local _event = GetEventType()

        if _event == EVENT_KEYDOWN_UP then    --判断蛇的行走
            x = 0
            y = - 30
        elseif _event == EVENT_KEYDOWN_DOWN then
            x = 0
            y = 30
        elseif _event == EVENT_KEYDOWN_LEFT then
            y = 0
            x = -30
        elseif _event == EVENT_KEYDOWN_RIGHT then
            y = 0
            x = 30
        end

    end

    for i = I, 1, -1 do    --贪吃蛇前进（将体节坐标变为前一体节坐标）
        if i == 1 then
            break
        end
        snake[i].x = snake[i-1].x
        snake[i].y = snake[i-1].y
    end

    x_1 = x_1 + x
    y_1 = y_1 + y
    
    snake[1] = {}  --变更第一体节坐标
    snake[1].x = x_1
    snake[1].y = y_1


    if (snake[1].x == 30 * food_x and snake[1].y == 30 * food_y) then    --是否吃到食物
        I = I + 1
        snake[I] = {}
        snake[I].x = snake[I-1].x - x
        snake[I].y = snake[I-1].y - y
        table.insert(snake,snake[I])
        math.randomseed(os.time())    --获取食物位置
        timenow = os.time()
        food_x = math.random(1,29)
        food_y = math.random(1,19)
        point = point + 1
    end

    for i = 2, I do    --判断是否吃到自身
        if snake[1].x == snake[i].x then
            if snake[1].y == snake[i].y then 
                game = 0 
                break
            end
        end
    end

    SetDrawColor(color)

    for i = 1, I do    --将蛇身坐标具象化
        FillCircle(snake[i], 15)
    end

    if (IfPointInRectStrict(snake[1],{x = 0,y = 0,w = 900,h = 600}) ~= true ) then     --判断是否撞墙
        game = 0
    end

    if game == 0 then  --判断是否死亡
        break
    end

    times = 1

    font = LoadFont("./font.ttf",60)
    image_font = CreateUTF8TextImageBlended(font,"你的得分为：" .. point,color_2)
    texture_font = CreateTexture(image_font)

end

times = times + 1

if game == 0 then
    CopyTexture(texture_font, {x = 300, y = 250, w = 300, h = 100})
    if UpdateEvent() then
        local _event = GetEventType()
        if _event == EVENT_QUIT then
            break
        end
    end
end

end

