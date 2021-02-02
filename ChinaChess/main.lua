UsingMoudle("All")

CreateWindow("中国象棋", {x = WINDOW_POSITION_DEFAULT, y = WINDOW_POSITION_DEFAULT, w = 560, h = 636}, {})


SetDrawColor({r=195, g=195, b=195, a=255})

Red_B = 2
Red_C = 3
Red_J = 4
Red_M = 5
Red_P = 6
Red_S = 7
Red_X = 8
Blk_B = 9
Blk_C = 10
Blk_J = 11
Blk_M = 12
Blk_P = 13
Blk_S = 14
Blk_X = 15


font = LoadFont("font.ttf", 36)
Redwin = LoadImage("RedWin.png")
texture_redwin = CreateTexture(Redwin)
Blackwin = LoadImage("BlackWin.png")
texture_blackwin = CreateTexture(Blackwin)
Table = LoadImage("Table.png")
texture_table = CreateTexture(Table)
RIM = LoadImage("RIM.png")
texture_rim = CreateTexture(RIM)
Chess = LoadImage("Chess1.png")
texture_chess = CreateTexture(Chess)

image_x, image_y = GetImageSize(RIM)

Arr = {}
for i = 1, 9 do
    Arr[i] = {}
    for j = 1, 10 do
        Arr[i][j] = 1
    end
end

function New() --初始化
    over = 0
    --结束

    Chess_Rim = {x = 0, y = 0, t = 16} --选中 选中坐标
    Check = {r_y = 10, r_x = 5, b_y = 1, b_x = 5} --照将 两将坐标

    PlayerFlag = 1 --下棋方
    ChessFlag = 0 --是否选中
    CheckFlag = 1 --是否照将
    RunFlag = 0
    --是否符合移动规则

    for i = 1, 9 do --初始化棋子位置
        Arr[i] = {}
        for j = 1, 10 do
            Arr[i][j] = 1
        end
    end

    Arr[1][1] = Blk_C
    Arr[9][1] = Blk_C
    Arr[2][1] = Blk_M
    Arr[8][1] = Blk_M
    Arr[3][1] = Blk_X
    Arr[7][1] = Blk_X
    Arr[4][1] = Blk_S
    Arr[6][1] = Blk_S
    Arr[5][1] = Blk_J
    Arr[2][3] = Blk_P
    Arr[8][3] = Blk_P
    Arr[1][4] = Blk_B
    Arr[3][4] = Blk_B
    Arr[5][4] = Blk_B
    Arr[7][4] = Blk_B
    Arr[9][4] = Blk_B
    Arr[1][7] = Red_B
    Arr[3][7] = Red_B
    Arr[5][7] = Red_B
    Arr[7][7] = Red_B
    Arr[9][7] = Red_B
    Arr[2][8] = Red_P
    Arr[8][8] = Red_P
    Arr[5][10] = Red_J
    Arr[4][10] = Red_S
    Arr[6][10] = Red_S
    Arr[3][10] = Red_X
    Arr[7][10] = Red_X
    Arr[2][10] = Red_M
    Arr[8][10] = Red_M
    Arr[1][10] = Red_C
    Arr[9][10] = Red_C
end

function Show() --绘制棋盘
    CopyTexture(texture_table, {x=0,y= 0,w= 560,h= 636})
    for i = 1, 9 do
        for j = 1, 10 do
            if Arr[i][j] > 1 then
                if Arr[i][j] == 2 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=300, y=50, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3, y=(j - 1) * 67.3 - 3,w= 36,h= 36}
                    )
                elseif Arr[i][j] == 3 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=200, y=50, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3, w=36,h= 36}
                    )
                elseif Arr[i][j] == 4 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=0, y=50, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3, w=36, h=36}
                    )
                elseif Arr[i][j] == 5 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=150, y=50, w=50,h=50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 6 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=250, y=50, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 7 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=50,y= 50, w=50,h= 50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 8 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=100,y= 50, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3, y=(j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 9 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=300,y= 0, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 10 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=200, y=0, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3, y=(j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 11 then
                    CopyReshapeTexture(texture_chess, {x=0, y=0, w=50,h= 50}, {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36})
                elseif Arr[i][j] == 12 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=150, y=0, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3, y=(j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 13 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=250, y=0, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 14 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=50,y= 0, w=50, h=50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                elseif Arr[i][j] == 15 then
                    CopyReshapeTexture(
                        texture_chess,
                        {x=100,y= 0,w= 50,h= 50},
                        {x=(i - 1) * 66.25 - 3,y= (j - 1) * 67.3 - 3,w= 36, h=36}
                    )
                end
            end
        end
    end
    if Chess_Rim.x ~= 0 and Chess_Rim.y ~= 0 then
        CopyReshapeTexture(
            texture_rim,
            {x=0, y=0, w=image_x / 2, h=image_y},
            {x=(Chess_Rim.x - 1) * 66.25 - 10, y=(Chess_Rim.y - 1) * 67.33 - 10, w=50,h= 50}
        )
    end
    UpdateWindow()
    return 0
end

function CheckChess() -- 检测照将
    if Check.r_x == Check.b_x and Chess_Rim.x == Check.r_x and (Check.b_y < Chess_Rim.y and Chess_Rim.y < Check.r_y) then
        if (b < Check.b_y or b > Check.r_y or Chess_Rim.x ~= a) then --照将
            CheckFlag = 0
            for i = Check.b_y + 1, Check.r_y - 1 do
                if Arr[Chess_Rim.x][i] ~= 1 and i ~= Chess_Rim.y then
                    CheckFlag = 1
                    break
                end
            end
        end
    end
    if (Chess_Rim.t == Red_J and Check.b_x == a) then
        CheckFlag = 0
        for i = Check.b_y + 1, b - 1 do
            if Arr[a][i] ~= 1 and i ~= Chess_Rim.y then
                CheckFlag = 1
                break
            end
        end
    elseif (Chess_Rim.t == Blk_J and Check.r_x == a) then
        CheckFlag = 0
        for i = b + 1, Check.r_y - 1 do
            if Arr[a][i] ~= 1 and i ~= Chess_Rim.y then
                CheckFlag = 1
                break
            end
        end
    end
    if CheckFlag == 1 then --移子
        if Arr[a][b] == Red_J then
            over = 1
        elseif Arr[a][b] == Blk_J then
            over = 2
        end
        Arr[a][b] = Chess_Rim.t
        Arr[Chess_Rim.x][Chess_Rim.y] = 1
        ChessFlag = 0
        if Chess_Rim.t == Red_J then
            Check.r_x = a
            Check.r_y = b
        elseif Chess_Rim.t == Blk_J then
            Check.b_x = a
            Check.b_y = b
        end
        PlayerFlag = (PlayerFlag + 1) % 2
    end
end

function CheckWin() --检测胜利
    if over == 1 then
        CopyTexture(texture_blackwin, {x=0,y= 200, w=560,h= 249})
        UpdateWindow()
        Sleep(1000)
        New()
    elseif over == 2 then
        CopyTexture(texture_redwin, {x=0,y= 200,w= 560,h= 249})
        UpdateWindow()
        Sleep(1000)
        New()
    end
end

New()
Show()
while true do --主循环
    Show()
    CheckWin()
    if UpdateEvent()  then
        if GetEventType() == EVENT_MOUSEBTNDOWN_LEFT then
            if ChessFlag ~= 1 then --选中棋子
                rect = GetCursorPosition()
                a, b = (rect.x + 18.125) // 66.25 + 1, (rect.y + 18.67) // 67.33 + 1
                if
                    (2 <= Arr[a][b] and Arr[a][b] <= 8 and PlayerFlag == 1) or
                        (9 <= Arr[a][b] and Arr[a][b] <= 15 and PlayerFlag == 0)
                 then
                    Chess_Rim.x = a
                    Chess_Rim.y = b
                    Chess_Rim.t = Arr[a][b]
                    ChessFlag = 1
                end
            else --下棋
                rect = GetCursorPosition()
                a, b = (rect.x + 18.125) // 66.25 + 1, (rect.y + 18.67) // 67.33 + 1
                if
                    ((Blk_B <= Arr[a][b] and Arr[a][b] <= Blk_X) and (Red_B <= Chess_Rim.t and Chess_Rim.t <= Red_X)) or
                        ((Red_B <= Arr[a][b] and Arr[a][b] <= Red_X) and (Blk_B <= Chess_Rim.t and Chess_Rim.t <= Blk_X)) or
                        Arr[a][b] == 1
                 then
                    if Chess_Rim.t == Red_B then --红兵
                        if
                            (a == Chess_Rim.x and b == Chess_Rim.y - 1) or --直行
                                ((a == Chess_Rim.x - 1 or a == Chess_Rim.x + 1) and b == Chess_Rim.y and b <= 5)
                         then --过河横行
                            CheckChess()
                        end
                    elseif Chess_Rim.t == Blk_B then --黑兵
                        if
                            (a == Chess_Rim.x and b == Chess_Rim.y + 1) or --直行
                                ((a == Chess_Rim.x - 1 or a == Chess_Rim.x + 1) and b == Chess_Rim.y and b >= 6)
                         then --过河横行
                            CheckChess()
                        end
                    elseif Chess_Rim.t == Red_C or Chess_Rim.t == Blk_C then --车
                        RunFlag = 0
                        if a == Chess_Rim.x then
                            if b > Chess_Rim.y then
                                p, t = b, Chess_Rim.y
                            else
                                t, p = b, Chess_Rim.y
                            end
                            for i = t + 1, p - 1 do
                                if Arr[Chess_Rim.x][i] ~= 1 then
                                    RunFlag = 1
                                    break
                                end
                            end
                            if RunFlag == 0 then
                                CheckChess()
                            end
                        elseif b == Chess_Rim.y then
                            if a > Chess_Rim.x then
                                p, t = a, Chess_Rim.x
                            else
                                t, p = a, Chess_Rim.x
                            end
                            for i = t + 1, p - 1 do
                                if Arr[i][Chess_Rim.y] ~= 1 then
                                    RunFlag = 1
                                    break
                                end
                            end
                            if RunFlag == 0 then
                                CheckChess()
                            end
                        end
                    elseif Chess_Rim.t == Red_J then --红将
                        if
                            (4 <= a and a <= 6) and (8 <= b and b <= 10) and
                                (((a == Chess_Rim.x - 1 or a == Chess_Rim.x + 1) and b == Chess_Rim.y) or
                                    ((b == Chess_Rim.y - 1 or b == Chess_Rim.y + 1) and a == Chess_Rim.x))
                         then
                            CheckChess()
                        end
                    elseif Chess_Rim.t == Blk_J then --黑将
                        if
                            (4 <= a and a <= 6) and (1 <= b and b <= 3) and
                                (((a == Chess_Rim.x - 1 or a == Chess_Rim.x + 1) and b == Chess_Rim.y) or
                                    ((b == Chess_Rim.y - 1 or b == Chess_Rim.y + 1) and a == Chess_Rim.x))
                         then
                            CheckChess()
                        end
                    elseif Chess_Rim.t == Red_M or Chess_Rim.t == Blk_M then --马
                        if
                            (a == Chess_Rim.x - 1 and b == Chess_Rim.y - 2 and Arr[Chess_Rim.x][Chess_Rim.y - 1] == 1) or
                                (a == Chess_Rim.x + 1 and b == Chess_Rim.y - 2 and
                                    Arr[Chess_Rim.x][Chess_Rim.y - 1] == 1) or
                                (a == Chess_Rim.x - 2 and b == Chess_Rim.y - 1 and
                                    Arr[Chess_Rim.x - 1][Chess_Rim.y] == 1) or
                                (a == Chess_Rim.x - 2 and b == Chess_Rim.y + 1 and
                                    Arr[Chess_Rim.x - 1][Chess_Rim.y] == 1) or
                                (a == Chess_Rim.x - 1 and b == Chess_Rim.y + 2 and
                                    Arr[Chess_Rim.x][Chess_Rim.y + 1] == 1) or
                                (a == Chess_Rim.x + 1 and b == Chess_Rim.y + 2 and
                                    Arr[Chess_Rim.x][Chess_Rim.y + 1] == 1) or
                                (a == Chess_Rim.x + 2 and b == Chess_Rim.y + 1 and
                                    Arr[Chess_Rim.x + 1][Chess_Rim.y] == 1) or
                                (a == Chess_Rim.x + 2 and b == Chess_Rim.y - 1 and
                                    Arr[Chess_Rim.x + 1][Chess_Rim.y] == 1)
                         then
                            CheckChess()
                        end
                    elseif Chess_Rim.t == Red_P or Chess_Rim.t == Blk_P then --炮
                        RunFlag = 0
                        if a == Chess_Rim.x then
                            if b > Chess_Rim.y then
                                p, t = b, Chess_Rim.y
                            else
                                t, p = b, Chess_Rim.y
                            end
                            for i = t + 1, p - 1 do
                                if Arr[Chess_Rim.x][i] ~= 1 then
                                    RunFlag = RunFlag + 1
                                end
                            end
                            if RunFlag == 1 or (RunFlag == 0 and Arr[a][b] == 1) then
                                CheckChess()
                            end
                        elseif b == Chess_Rim.y then
                            if a > Chess_Rim.x then
                                p, t = a, Chess_Rim.x
                            else
                                t, p = a, Chess_Rim.x
                            end
                            for i = t + 1, p - 1 do
                                if Arr[i][Chess_Rim.y] ~= 1 then
                                    RunFlag = RunFlag + 1
                                end
                            end
                            if RunFlag == 1 or (RunFlag == 0 and Arr[a][b] == 1) then
                                CheckChess()
                            end
                        end
                    elseif Chess_Rim.t == Red_X or Chess_Rim.t == Blk_X then --相
                        if
                            ((a == Chess_Rim.x - 2 and b == Chess_Rim.y - 2 and
                                Arr[Chess_Rim.x - 1][Chess_Rim.y - 1] == 1) or
                                (a == Chess_Rim.x - 2 and b == Chess_Rim.y + 2 and
                                    Arr[Chess_Rim.x - 1][Chess_Rim.y + 1] == 1) or
                                (a == Chess_Rim.x + 2 and b == Chess_Rim.y + 2 and
                                    Arr[Chess_Rim.x + 1][Chess_Rim.y + 1] == 1) or
                                (a == Chess_Rim.x + 2 and b == Chess_Rim.y - 2 and
                                    Arr[Chess_Rim.x + 1][Chess_Rim.y - 1] == 1)) and
                                (b ~= 4 and b ~= 7)
                         then
                            CheckChess()
                        end
                    elseif Chess_Rim.t == Red_S then --红士
                        if
                            (4 <= a and a <= 6) and (8 <= b and b <= 10) and
                                ((a == Chess_Rim.x - 1 and b == Chess_Rim.y - 1) or
                                    (a == Chess_Rim.x - 1 and b == Chess_Rim.y + 1) or
                                    (a == Chess_Rim.x + 1 and b == Chess_Rim.y - 1) or
                                    (a == Chess_Rim.x + 1 and b == Chess_Rim.y + 1))
                         then
                            CheckChess()
                        end
                    elseif Chess_Rim.t == Blk_S then --黑士
                        if
                            (4 <= a and a <= 6) and (1 <= b and b <= 3) and
                                ((a == Chess_Rim.x - 1 and b == Chess_Rim.y - 1) or
                                    (a == Chess_Rim.x - 1 and b == Chess_Rim.y + 1) or
                                    (a == Chess_Rim.x + 1 and b == Chess_Rim.y - 1) or
                                    (a == Chess_Rim.x + 1 and b == Chess_Rim.y + 1))
                         then
                            CheckChess()
                        end
                    end
                    CheckFlag = 1
                end
                Chess_Rim.x = 0
                Chess_Rim.y = 0
                ChessFlag = 0
            end
        elseif GetEventType() == EVENT_QUIT then
            break
        end
    end
end
