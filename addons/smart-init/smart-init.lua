addon.name = 'smart-init'
addon.author = 'ChristopherJTrent'
addon.version = '1.0'
addon.desc = 'Initializes a complete Smart.LAC compatible JOB.lua file'
addon.link = 'https://github.com/ChristopherJTrent/smart-init'

local settingsLib = require('settings')

function getInstallationPath(job) 
    if settingsLib.logged_in then
        return ('%s\\config\\addons\\%s\\%s_%d\\%s.lua'):fmt(AshitaCore:GetInstallPath(), 'luashitacast', settingsLib.name, settingsLib.server_id, job)
    end
end

function writeNewProfile() 
    local f = io.open(getInstallationPath(AshitaCore:GetMemoryManager():GetPlayer():GetMainJob()), 'w+')
    if (f == nil) then
        return false
    end
    f:write([[
    local smart = gFunc.LoadFile("Smart.LAC/smart.lua")
    local modes = gFunc.LoadFile("Smart.LAC/modes.lua")
    if not smart then return nil end
    if not modes then return nil end
    local sets = T{
        general = T{
            Idle = T{
                -- idle gear goes here
            },
            Engaged = T{
                -- TP set goes here
            }
        },
        weaponskill = T{
            default = T{
                -- any gear that should be equipped for all weaponskills goes here
                -- E.G. Ear1 = "Moonshade Earring"
            },
            -- add additional sets below.
            -- ["Leaden Salute"] = T{
            --    Head = "Pixie Hairpin +1"
            -- }
            -- or
            -- Upheaval = T{
            --    Hands = "Boii Mufflers +3"
            -- }
            -- as examples.
        },
        precast = T{
            default = T{
                -- precast gear goes here.
            }
        },
        midcast = T{
            default = T{
                -- midcast gear goes here
                -- e.g. Conserve MP gear
            }
        },
        preshot = T{
            default = T{
                -- preshot gear goes here, i.e. snapshot/rapid shot
            },
            buffs = T{
                ["Triple Shot"] = T{
                    -- triple shot gear goes here, for example.
                }
            }
        },
        midshot = T{
            default = T{
                -- midshot gear goes here, i.e. TP set
            }
        },
        item = T{
            default = T{
                -- item use set goes here, if you have one.
            }
        },
        ability = T{
            default = T{
                -- ability set goes here
            }
        }
    }
    ]])
    f:close()
end

ashita.events.register('command', 'command_cb', function(e) 
    if string.lower(string.sub(e.command, 1, 11)) == '/smart init' then
        e.blocked = true
        writeNewProfile()
    end
end)