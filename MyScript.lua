script_name("Test Auto Update")
script_author("Dimas")

-- [SERVER] INI VERSI BARU (YANG ADA DI GITHUB)
local my_version = 2.0 
script_version_number(my_version) 

local dlstatus = require('moonloader').download_status

-- Link RAW yang sudah diperbaiki (tanpa refs/heads)
local url_version = "https://raw.githubusercontent.com/kotkaaja/UpdateLua/main/version.txt"
local url_script = "https://raw.githubusercontent.com/kotkaaja/UpdateLua/main/MyScript.lua"

local update_path = getWorkingDirectory() .. "\\temp_version.txt"
local script_path = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampAddChatMessage("{00FFFF}[SYSTEM] {FFFFFF}Script berjalan di versi: " .. my_version, -1)
    
    -- Cek update (biar kalau ada v3.0 dia update lagi)
    cekUpdate()

    while true do
        wait(0)
        -- Fitur script lu disini...
    end
end

function cekUpdate()
    downloadUrlToFile(url_version, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local file = io.open(update_path, "r")
            if file then
                local remote_ver = file:read("*a")
                file:close()
                os.remove(update_path)
                remote_ver = tonumber(remote_ver)

                if remote_ver and remote_ver > my_version then
                    sampAddChatMessage("{00FF00}[UPDATE] {FFFFFF}Versi baru ("..remote_ver..") ditemukan! Memulai download...", -1)
                    lakukanUpdate()
                end
            end
        end
    end)
end

function lakukanUpdate()
    downloadUrlToFile(url_script, script_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            sampAddChatMessage("{00FF00}[SUKSES] {FFFFFF}Update berhasil! Merestart script...", -1)
            thisScript():reload()
        end
    end)
end
