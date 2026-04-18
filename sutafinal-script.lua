local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SutaDarkSc", "DarkTheme")

-- Variabel Kontrol
_G.AutoOffice = false
_G.AutoQuest = false
_G.SafeMode = true

-- Fitur Pop-up (Tombol Sembunyi/Muncul)
-- Tekan "RightControl" di Keyboard untuk menutup/membuka menu
Library:ToggleUI() 

-- Anti-AFK Stealth
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- TAB UTAMA
local Main = Window:NewTab("Main")
local Section = Main:NewSection("Auto Farming")

-- Fungsi mencari Remote secara otomatis
local function GetRemote(name)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find(name:lower()) then
            return v
        end
    end
    return nil
end

-- AUTO OFFICE
Section:NewToggle("Auto Farm Office", "Otomatis Kerja & Teleport", function(state)
    _G.AutoOffice = state
    task.spawn(function()
        while _G.AutoOffice do
            local delay = _G.SafeMode and math.random(2, 5) or 1
            task.wait(delay)
            
            pcall(function()
                -- Mencari lokasi kantor secara dinamis di workspace
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:find("Office") or v.Name:find("Work") then
                        if v:IsA("BasePart") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 3, 0)
                            break
                        end
                    end
                end
                
                -- Mencari Remote Kerja dan memicunya
                local r = GetRemote("Work") or GetRemote("Job")
                if r then r:FireServer() end
            end)
        end
    end)
end)

-- AUTO QUEST
Section:NewToggle("Auto Quest", "Otomatis Ambil Quest", function(state)
    _G.AutoQuest = state
    task.spawn(function()
        while _G.AutoQuest do
            task.wait(3)
            pcall(function()
                local q = GetRemote("Quest") or GetRemote("Mission")
                if q then q:FireServer("Accept") end
            end)
        end
    end)
end)

-- TAB PENGATURAN
local Config = Window:NewTab("Settings")
local ConfSec = Config:NewSection("GUI & Control")

-- Tombol Pop-up Manual (Jika tidak pakai keyboard)
ConfSec:NewButton("Show/Hide Menu", "Klik untuk menyembunyikan GUI", function()
    Library:ToggleUI()
end)

ConfSec:NewKeybind("Toggle Key", "Tekan tombol ini untuk sembunyi/muncul", Enum.KeyCode.RightControl, function()
	Library:ToggleUI()
end)

local PlayerSec = Config:NewSection("Player Mods")
PlayerSec:NewSlider("WalkSpeed", "Atur kecepatan", 100, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

PlayerSec:NewButton("Anti-Kick Rejoin", "Otomatis masuk kembali jika terputus", function()
    local ts = game:GetService("TeleportService")
    local p = game:GetService("Players").LocalPlayer
    ts:Teleport(game.PlaceId, p)
end)
