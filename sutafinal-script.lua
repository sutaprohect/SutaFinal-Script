--[[
    KING SUTA HUB - ULTIMATE BYPASS
    Name: King Suta
    Version: Decrypted-Style Bypass
]]--

-- 1. Setup Identitas King Suta
local CoreGui = game:GetService("CoreGui")
print("King Suta Hub: Memulai proses bypass...")

-- 2. Fungsi untuk mematikan UI Get Key secara paksa
local function DisableKeyUI()
    task.spawn(function()
        while task.wait(0.5) do
            -- Mencari elemen UI yang biasanya mengandung kata "Key" atau "Whitelist"
            for _, v in pairs(CoreGui:GetDescendants()) do
                if v:IsA("TextLabel") or v:IsA("TextBox") then
                    if v.Text:find("Key") or v.Text:find("Whitelist") or v.Text:find("Enter") then
                        local mainUI = v:FindFirstAncestorOfClass("ScreenGui")
                        if mainUI then
                            mainUI.Enabled = false
                            print("King Suta: GUI Key terdeteksi dan dimatikan.")
                        end
                    end
                end
            end
        end
    end)
end

-- 3. Hooking Function (Mencegah script berhenti saat key kosong)
if replaceclosure then
    local old; old = replaceclosure(print, function(...)
        local args = {...}
        if args[1] and type(args[1]) == "string" and args[1]:find("Key") then
            return -- Abaikan pesan error key
        end
        return old(...)
    end)
end

-- 4. Menjalankan Source Utama dengan Injeksi King Suta
local success, err = pcall(function()
    local raw_script = game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/refs/heads/main/drag%20drive")
    
    -- Menghapus baris kode yang memaksa pop-up key (jika polanya terbaca)
    raw_script = raw_script:gsub("getgenv%(%).Key.*=.*", "")
    
    local exec = loadstring(raw_script)
    exec()
end)

if success then
    DisableKeyUI()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "KING SUTA LOADED",
        Text = "Sistem Key telah di-bypass!",
        Duration = 5
    })
else
    warn("Gagal Dekripsi: " .. tostring(err))
end
