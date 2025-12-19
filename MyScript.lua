script_name("Test Auto Update")
script_author("kotkaaja")
script_version_number(2.0) -- Versi Lokal (Sengaja kita buat lebih rendah dari GitHub)

local dlstatus = require('moonloader').download_status

-- ================= KONFIGURASI =================
-- Ganti 2 Link ini dengan Link RAW GitHub lu sendiri!
local url_version = "https://raw.githubusercontent.com/kotkaaja/UpdateLua/refs/heads/main/version.txt"
local url_script = "https://raw.githubusercontent.com/kotkaaja/UpdateLua/refs/heads/main/MyScript.lua"
-- ===============================================

local update_path = getWorkingDirectory() .. "\\temp_version.txt"
local script_path = thisScript().path

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampAddChatMessage("{00FFFF}[SYSTEM] {FFFFFF}Script berjalan di versi: " .. script_version_number(), -1)
    
    -- Cek update saat script baru jalan
    cekUpdate()

    -- Main Loop
    while true do
        wait(0)
        -- Fitur script lu disini
    end
end

function cekUpdate()
    sampAddChatMessage("{00FFFF}[UPDATE] {FFFFFF}Sedang memeriksa update...", -1)
    
    -- Download file version.txt
    downloadUrlToFile(url_version, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            local file = io.open(update_path, "r")
            if file then
                local remote_ver = file:read("*a")
                file:close()
                os.remove(update_path) -- Hapus file temp

                -- Bersihkan string dari spasi/enter
                remote_ver = tonumber(remote_ver)

                if remote_ver then
                    if remote_ver > script_version_number() then
                        sampAddChatMessage("{00FF00}[UPDATE] {FFFFFF}Versi baru ("..remote_ver..") ditemukan! Memulai download...", -1)
                        lakukanUpdate()
                    else
                        sampAddChatMessage("{FFFF00}[INFO] {FFFFFF}Tidak ada update. Versi kamu sudah terbaru.", -1)
                    end
                else
                     sampAddChatMessage("{FF0000}[ERROR] {FFFFFF}Gagal membaca versi server.", -1)
                end
            end
        end
    end)
end

function lakukanUpdate()
    -- Download script utama dan timpa file ini
    downloadUrlToFile(url_script, script_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            sampAddChatMessage("{00FF00}[SUKSES] {FFFFFF}Update berhasil! Merestart script...", -1)
            thisScript():reload() -- Reload otomatis
        end
    end)
end
