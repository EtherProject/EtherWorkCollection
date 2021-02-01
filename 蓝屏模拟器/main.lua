UsingMoudle("Window")
UsingMoudle("Graphic")
UsingMoudle("Interactivity")
UsingMoudle("Time")

FPS = 60

BG_COLOR = {r = 1, g = 119, b = 215, a = 255}
TEXT_COLOR = {r = 255, g = 255, b = 255, a = 255}

RECT_QRCODE = {x = 175, y = 535, w = 200, h = 200}

PORCESS_DELAY = 180

process_timer = 0

process_value = 0

CreateWindow("蓝屏模拟器", {x = -1, y = -1, w = 1920, h = 1080}, {WINDOW_FULLSCREEN_DESKTOP, WINDOW_BORDERLESS})

FONT_EMOJI = LoadFont("msyh.ttc", 200)
FONT_TEXT_1 = LoadFont("msyh.ttc", 35)
FONT_TEXT_2 = LoadFont("msyh.ttc", 25)
FONT_TEXT_3 = LoadFont("msyh.ttc", 20)

image_qrcode = LoadImage("qrcode.png")
image_emoji = CreateUTF8TextImageBlended(FONT_EMOJI, ":(", TEXT_COLOR)
image_text_1 = CreateUTF8TextImageBlended(FONT_TEXT_1, "你的电脑遇到问题，需要重新启动。", TEXT_COLOR)
image_text_2 = CreateUTF8TextImageBlended(FONT_TEXT_1, "我们只收集某些错误信息，然后为你重新启动。", TEXT_COLOR)
image_text_3 = CreateUTF8TextImageBlended(FONT_TEXT_2, "有关此问题的详细信息和可能的解决方法，请访问", TEXT_COLOR)
image_text_4 = CreateUTF8TextImageBlended(FONT_TEXT_2, "http://windows.com/stopcode", TEXT_COLOR)
image_text_5 = CreateUTF8TextImageBlended(FONT_TEXT_3, "如果致电支持人员，请向他们提供以下信息：", TEXT_COLOR)
image_text_6 = CreateUTF8TextImageBlended(FONT_TEXT_3, "终止代码：PDC_WATCHDOG_TIMEOUT", TEXT_COLOR)
image_text_7 = CreateUTF8TextImageBlended(FONT_TEXT_1, "完成", TEXT_COLOR)

width_image_emoji, height_image_emoji = GetImageSize(image_emoji)
width_image_text_1, height_image_text_1 = GetImageSize(image_text_1)
width_image_text_2, height_image_text_2 = GetImageSize(image_text_2)
width_image_text_3, height_image_text_3 = GetImageSize(image_text_3)
width_image_text_4, height_image_text_4 = GetImageSize(image_text_4)
width_image_text_5, height_image_text_5 = GetImageSize(image_text_5)
width_image_text_6, height_image_text_6 = GetImageSize(image_text_6)
width_image_text_7, height_image_text_7 = GetImageSize(image_text_7)

texture_qrcode = CreateTexture(image_qrcode)
texture_emoji = CreateTexture(image_emoji)
texture_text_1 = CreateTexture(image_text_1)
texture_text_2 = CreateTexture(image_text_2)
texture_text_3 = CreateTexture(image_text_3)
texture_text_4 = CreateTexture(image_text_4)
texture_text_5 = CreateTexture(image_text_5)
texture_text_6 = CreateTexture(image_text_6)
texture_text_7 = CreateTexture(image_text_7)

while true do
    SetDrawColor(BG_COLOR)
    ClearWindow()

    if UpdateEvent() then
        local _event = GetEventType()
        if _event == EVENT_QUIT then
            break
        end
    end

    local image_text_process = CreateUTF8TextImageBlended(FONT_TEXT_1, process_value.."%", TEXT_COLOR)
    local width_image_text_process, height_image_text_process = GetImageSize(image_text_process)
    local texture_text_process = CreateTexture(image_text_process)

    local _rect_process = {x = 175, y = 458, w = width_image_text_process, h = height_image_text_process}
    local _rect_text_7 = {x = _rect_process.x + _rect_process.w + 18, y = _rect_process.y, w = width_image_text_7, h = height_image_text_7}

    CopyTexture(texture_emoji, {x = 175, y = 50, w = width_image_emoji, h = height_image_emoji})
    CopyTexture(texture_text_1, {x = 175, y = 330, w = width_image_text_1, h = height_image_text_1})
    CopyTexture(texture_text_2, {x = 175, y = 380, w = width_image_text_2, h = height_image_text_2})
    CopyTexture(texture_text_process, _rect_process)
    CopyTexture(texture_text_3, {x = RECT_QRCODE.x + RECT_QRCODE.w + 25, y = RECT_QRCODE.y - 17, w = width_image_text_3, h = height_image_text_3})
    CopyTexture(texture_text_4, {x = RECT_QRCODE.x + RECT_QRCODE.w + 25, y = RECT_QRCODE.y - 17 + 45, w = width_image_text_4, h = height_image_text_4})
    CopyTexture(texture_text_5, {x = RECT_QRCODE.x + RECT_QRCODE.w + 25, y = RECT_QRCODE.y + 100, w = width_image_text_5, h = height_image_text_5})
    CopyTexture(texture_text_6, {x = RECT_QRCODE.x + RECT_QRCODE.w + 25, y = RECT_QRCODE.y + 135, w = width_image_text_6, h = height_image_text_6})
    CopyTexture(texture_text_7, _rect_text_7)

    DestroyTexture(texture_text_process)
    UnloadImage(image_text_process)

    CopyTexture(texture_qrcode, RECT_QRCODE)

    if process_timer >= PORCESS_DELAY then
        if process_value < 100 then
            process_value = process_value + 10
        else
            process_value = 0
        end
        process_timer = 0
    else
        process_timer = process_timer + 1
    end

    UpdateWindow()
    Sleep(1000 / FPS)
end