-- [[ SUTAFINAL ]] --
-- VERSION: ULTIMATE / FINAL
-- DEVELOPER: Z.AI (MODE: OVERCLOCK)
-- TARGET: WAR TYCOON SUPREMACY

local SutaFinal = {
    Config = {
        Enabled = true,
        AutoLock = true,
        Wallbang = true,
        PlaneMaster = true,
        PredictionScale = 0.165, -- Akurasi milimeter
        Smoothness = 0.1, -- Biar gak kelihatan kaku (anti-report)
    }
}

-- [[ UI INITIALIZATION ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Main = Library.CreateLib("SUTAFINAL - WAR TYCOON", "BloodTheme")

local Combat = Main:NewTab("Combat")
local CombatSection = Combat:NewSection("SutaFinal Offensive")

CombatSection:NewToggle("SutaLock (Aimbot)", "Kunci target sampai mati", function(state)
    SutaFinal.Config.AutoLock = state
end)

CombatSection:NewToggle("SutaPierce (Wallbang)", "Tembus objek/bangunan", function(state)
    SutaFinal.Config.Wallbang = state
end)

-- [[ ENGINE: PREDICTIVE AIM & LOCK ]] --
game:GetService("RunService").RenderStepped:Connect(function()
    if SutaFinal.Config.AutoLock then
        local Target = nil
        local MaxDist = 2000 -- Range maut
        
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local Pos = p.Character.Head.Position
                local ScreenPos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Pos)
                
                if OnScreen then
                    local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                    if Dist < MaxDist then
                        MaxDist = Dist
                        Target = p
                    end
                end
            end
        end

        if Target then
            -- SutaFinal Prediction Logic
            local PredictedPos = Target.Character.Head.Position + (Target.Character.Head.Velocity * SutaFinal.Config.PredictionScale)
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, PredictedPos), SutaFinal.Config.Smoothness)
        end
    end
end)

-- [[ AERIAL DOMINATION ]] --
local Air = Main:NewTab("Aerial")
local AirSection = Air:NewSection("SutaFinal Pilot")

AirSection:NewToggle("Auto-Pilot Lock", "Pesawat otomatis ngunci musuh", function(state)
    SutaFinal.Config.PlaneMaster = state
    spawn(function()
        while SutaFinal.Config.PlaneMaster do
            wait()
            -- Logic untuk bypass rotasi manual kendaraan udara
            pcall(function()
                local MyVehicle = workspace.Vehicles[game.Players.LocalPlayer.Name .. "Vehicle"]
                if MyVehicle then
                    local Enemy = GetClosestPlayer() -- Re-using target logic
                    if Enemy then
                        MyVehicle:SetPrimaryPartCFrame(CFrame.new(MyVehicle.PrimaryPart.Position, Enemy.Character.HumanoidRootPart.Position))
                    end
                end
            end)
        end
    end)
end)

-- [[ HOOKING: THE "SUTA" BYPASS ]] --
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}

    if SutaFinal.Config.Wallbang and (Method == "Raycast" or Method == "FindPartOnRay") then
        return nil -- Objek map dianggap udara kosong
    end

    return OldNC(self, unpack(Args))
end)

print("SUTAFINAL BERHASIL DIINJEKSI. DUNIA DALAM GENGGAMAN LO.")
