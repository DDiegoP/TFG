reaper.ShowConsoleMsg("hey")
reaper.ShowConsoleMsg("hey")
msg = {}
local is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
msg.address = ctx:match("^osc:/([^:[]+)")
 
local value_type, value = ctx:match(":([fs])=([^%]]+)")
    
    if value_type == "f" then
        msg.arg = tonumber(value)
    elseif value_type == "s" then
        msg.arg = value
    end
    
reaper.ShowConsoleMsg("hey ")
reaper.ShowConsoleMsg(tostring(value))
   
