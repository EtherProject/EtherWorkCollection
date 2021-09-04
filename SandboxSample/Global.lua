Time = UsingModule("Time")

Global = {}

Global.WINDOWSIZE_W = 1200
Global.WINDOWSIZE_H = 900

Global.GRAVITY = 1

--计时器模块

local TimerList = {}

function Global.AddTimer(delay, callback, params)
    table.insert(TimerList, {
        delay = Time.GetInitTime() + delay,
        callback = callback,
        params = params
    })
end

function Global.UpdateTimer()
    local currentTime = Time.GetInitTime()
    for i = #TimerList, 1, -1 do
        local _timer = TimerList[i]
        if _timer.delay <= currentTime then
            _timer.callback(_timer.params)
            table.remove(TimerList, i)
        end
    end
end

function Global.ClearAll()
    TimerList = {}
end


return Global