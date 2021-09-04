Compress = UsingModule("Compress")

local _module = {
    INFO = 0,
    WARNING = 1,
    ERROR = 2
}

local _show_info_type = true

local _show_time = true

local _show_caller_info = true

local _output_file = nil

local function _gen_log_str(content, type)
    content = content or ""

    -- if _show_caller_info then
    --     local _debug_info = debug.getinfo(3)
    --     content = string.format(
    --         "[%s[%s]:%s]",
    --         _debug_info.short_src,
    --         _debug_info.currentline,
    --         _debug_info.name
    --     )..content
    -- end

    -- if _show_time then
    --     content = string.format(
    --         "[%s]",
    --         os.date("%y-%m-%d %H:%M:%S")
    --     )..content
    -- end

    -- if _show_info_type then
    --     if type == _module.INFO then
    --         content = "[INFO]"..content
    --     elseif type == _module.WARNING then
    --         content = "[WARN]"..content
    --     elseif type == _module.ERROR then
    --         content = "[ERROR]"..content
    --     else
    --         content = "[INFO]"..content
    --     end
    -- end

    -- return content

    local _debug_info = debug.getinfo(3)
    
    return string.format(
        "[INFO][%s][%s[%s]:%s]%s", 
        os.date("%y-%m-%d %H:%M:%S"),  
        _debug_info.short_src,
        _debug_info.currentline,
        _debug_info.name,
        content
    )
end

--[[
    描述：
        将调试信息输出至控制台
    参数：
        - content   [string]    调试信息
        - type      [number]    信息类型，默认为 Debug.INFO
    返回值：
        [无]
    示例：
        Debug.ConsoleLog("HelloWorld", Debug.WARNING)
        可能的输出为：[WARN][21-08-12 09:24:37][./scripts/VisualConsole.lua[21]:PushText]HelloWorld
--]]
_module.ConsoleLog = function(content, type)
    print(_gen_log_str(content, type))
end

--[[
    描述：
        设置输出内容中是否包含信息类型
    参数：
        - flag  [boolean]   是否包含信息类型
    返回值：
        [无]
    示例：
        默认包含信息类型的情况下可能输出：[INFO][21-08-12 09:24:37][./scripts/VisualConsole.lua[21]:PushText]HelloWorld
        关闭信息类型后的输出：[21-08-12 09:24:37][./scripts/VisualConsole.lua[21]:PushText]HelloWorld
--]]
_module.SetInfoTypeShow = function(flag)
    _show_info_type = flag
end

--[[
    描述：
        设置输出内容中是否包含时间信息
    参数：
        - flag  [boolean]   是否包含时间信息
    返回值：
        [无]
    示例：
        默认包含时间信息的情况下可能输出：[INFO][21-08-12 09:24:37][./scripts/VisualConsole.lua[21]:PushText]HelloWorld
        关闭时间信息后的输出：[INFO][./scripts/VisualConsole.lua[21]:PushText]HelloWorld
--]]
_module.SetTimeShow = function(flag)
    _show_time = flag
end

--[[
    描述：
        设置输出内容中是否包含调用者信息
    参数：
        - flag  [boolean]   是否包含调用者信息
    返回值：
        [无]
    示例：
        默认包含调用者信息的情况下可能输出：[INFO][21-08-12 09:24:37][./scripts/VisualConsole.lua[21]:PushText]HelloWorld
        关闭调用者信息后的输出：[INFO][21-08-12 09:24:37]HelloWorld
--]]
_module.SetCallerInfoShow = function(flag)
    _show_caller_info = flag
end

--[[
    描述：
        设置调试信息输出文件
    参数：
        - path  [string]    日志文件路径
    返回值：
        [无]
    备注：
        若文件存在则将清空文件内容；若文件不存在则尝试创建文件，创建失败则报错
--]]
_module.SetOutputFile = function(path)
    if _output_file then _output_file:close() end
    _output_file = io.open(path, "w+")
    assert(_output_file, "open file failed")
end

--[[
    描述：
        将调试信息输出至预先指定的文件中
    参数：
        - content   [string]    调试信息
        - type      [number]    信息类型，默认为 Debug.INFO
    返回值：
        [无]
    示例：
        同 ConsoleLog
--]]
_module.FileLog = function(content, type)
    assert(_output_file, "no output file specified")
    _output_file:write(_gen_log_str(content, type).."\n")
end

--[[
    描述：
        压缩当前日志文件到指定路径
    参数：
        - path  [string]    压缩数据存储路径
    返回值：
        [无]
    示例：
        若指定路径文件存在则将清空文件内容，否则将尝试创建文件；
        未指定当前调试信息输出文件或创建文件失败都将报错
--]]
_module.CompressLogFile = function(path)
    assert(_output_file, "no output file specified")
    local _current_pos = _output_file:seek()
    local _dst_file = io.open(path, "wb")
    assert(_output_file, "open file failed")
    _output_file:seek("set")
    _dst_file:write(Compress.CompressData(_output_file:read("*a")))
    _dst_file:close()
    _output_file:seek("set", _current_pos)
end

return _module