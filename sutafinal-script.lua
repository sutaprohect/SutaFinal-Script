local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SutaDarkSc", "DarkTheme")

-- Variabel Kontrol
_G.AutoOffice = false
_G.AutoQuest = false
_G.SafeMode = true

-- Anti-AFK (Menjaga koneksi tetap aktif)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Tab Utama
local Main = Window:NewTab("Main")
local Section = Main:NewSection("Automation")

-- Auto Farm Office
Section:NewToggle("Auto Farm Office", "Kerja kantor otomatis (Anti-Kick)", function(state)
    _G.AutoOffice = state
    spawn(function()
        while _G.AutoOffice do
            local waitTime = _G.SafeMode and math.random(2, 4) or 0.7
            task.wait(waitTime)
            
            pcall(function()
                local playerHRP = game.Players.LocalPlayer.Character.HumanoidRootPart
                -- Pastikan path lokasi kerja di bawah ini sesuai dengan workspace game
                local officePoint = workspace:FindFirstChild("OfficeArea") or workspace:FindFirstChild("JobLocation")
                
                if officePoint then
                    playerHRP.CFrame = officePoint.CFrame * CFrame.new(0, 3, 0)
                    -- Trigger event pekerjaan
                    local workEvent = game:GetService("ReplicatedStorage"):FindFirstChild("WorkRemote")
                    if workEvent then
                        workEvent:FireServer()
                    end
                end
            end)
        end
    end)
end)

-- Auto Quest
Section:NewToggle("Auto Quest", "Otomatis ambil misi terdekat", function(state)
    _G.AutoQuest = state
    spawn(function()
        while _G.AutoQuest do
            task.wait(2)
            pcall(function()
                -- Logika untuk memicu remote quest
                local questEvent = game:GetService("ReplicatedStorage"):FindFirstChild("QuestRemote")
                if questEvent then
                    questEvent:FireServer("Claim")
                end
            end)
        end
    end)
end)

-- Tab Pengaturan & Keamanan
local Settings = Window:NewTab("Settings")
local SecSection = Settings:NewSection("Security & Misc")

SecSection:NewToggle("Safe Mode (Random Delay)", "Mencegah deteksi pola bot", function(state)
    _G.SafeMode = state
end)

SecSection:NewSlider("WalkSpeed", "Atur kecepatan lari", 100, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

SecSection:NewButton("Destroy UI", "Menghapus SutaDarkSc dari layar", function()
    game:GetService("CoreGui"):FindFirstChild("SutaDarkSc"):Destroy()
end)
