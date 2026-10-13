local FFlags_Default = {
    ["DebugLimitMinTextureResolutionWhenSkipMips"] = "2147483647",
    ["DoNotSkipMipsBasedOnSystemMemoryPS"] = "True",
    ["TM2SkipMipsForUnstreamable2"] = "True",
    ["RenderUseTextureManager224"] = "False",
    ["DebugTextureManagerSkipMips"] = "8",
    ["EnablePowerTraceModule"] = "True",
    ["DisablePostFx"] = "True",
    ["FIntCameraMaxZoomDistance"] = "120",
    ["IncludePowerSaverMode"] = "True",
    ["DebugFRMQualityLevelOverride"] = "1",
    ["DFIntDebugDynamicRenderKiloPixels"] = "2000",
    ["DebugDisplayFPS"] = "True",
    ["DFIntDebugFRMQualityLevelOverride"] = "1",
    ["FFlagRenderNoLowFrmBloom"] = "False",
    ["FLogNetwork"] = "7",
    ["FFlagRenderNoParticleEmitter"] = "True",
    ["FFlagDisableParticleEmitter"] = "True",
    ["FIntRenderParticleEmitterMaxCount"] = "0",
    ["FFlagRenderNoTrail"] = "True",
    ["FFlagRenderNoBeam"] = "True",
    ["FFlagRenderNoSmoke"] = "True",
    ["FFlagRenderNoFire"] = "True",
    ["FFlagRenderNoSparkles"] = "True",
    ["FFlagRenderNoExplosion"] = "True",
    ["FFlagRenderNoDecal"] = "True",
    ["FFlagRenderNoTexture"] = "True",
    ["FFlagRenderNoHighlight"] = "True",
    ["FFlagDisableTextures"] = "True",
    ["FFlagDisableDecals"] = "True",
    ["FFlagDisableParticle"] = "True",
    ["FFlagDisableTrails"] = "True",
    ["DFIntParticleEmitterMaxCount"] = "0",
    ["DFIntTrailMaxCount"] = "0",
    ["DFIntBeamMaxCount"] = "0",
    ["DebugSkyGray"] = "True",
    ["FIntRenderShadowIntensity"] = "0",
}

local function applyFlags(tbl)
    local n = 0
    if setfflag then
        for k, v in pairs(tbl) do
            if pcall(setfflag, k, tostring(v)) then n = n + 1 end
        end
    end
    if n == 0 and getrawmetatable and setreadonly and newcclosure then
        pcall(function()
            local mt = getrawmetatable(game)
            if mt and mt.__index then
                local oldIndex = mt.__index
                setreadonly(mt, false)
                mt.__index = newcclosure(function(self, key)
                    if tbl[key] ~= nil then
                        local v = tbl[key]
                        if v == "True" then return true end
                        if v == "False" then return false end
                        return tonumber(v) or v
                    end
                    return oldIndex(self, key)
                end)
                setreadonly(mt, true)
                for _ in pairs(tbl) do n = n + 1 end
            end
        end)
    end
    if writefile then
        pcall(function()
            writefile("ClientAppSettings.json", game:GetService("HttpService"):JSONEncode(tbl))
        end)
    end
    return n
end

local function removeAllEffects()
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
                or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles")
                or v:IsA("Explosion") or v:IsA("Highlight") then
                v.Enabled = false
                pcall(function() v:Destroy() end)
            end
            if v:IsA("Texture") or v:IsA("Decal") then
                v.Transparency = 1
                pcall(function() v:Destroy() end)
            end
            if v:IsA("PostEffect") then
                v.Enabled = false
            end
            if v:IsA("Sound") then
                v.Volume = 0
            end
        end
    end)
    pcall(function()
        local L = game:GetService("Lighting")
        L.GlobalShadows = false
        L.FogEnd = 100000
        L.Brightness = 1
        L.EnvironmentDiffuseScale = 0
        L.EnvironmentSpecularScale = 0
        for _, v in ipairs(L:GetChildren()) do
            if v:IsA("PostEffect") then v.Enabled = false end
            if v:IsA("Atmosphere") then v.Density = 0 end
            if v:IsA("Sky") then
                v.SkyboxBk = "" v.SkyboxDn = "" v.SkyboxFt = ""
                v.SkyboxLf = "" v.SkyboxRt = "" v.SkyboxUp = ""
                v.StarCount = 0
            end
        end
    end)
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BinhFFlags_" .. tostring(math.random(1000, 9999))
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, 200)
main.Position = UDim2.new(0.5, -120, 0.4, -100)
main.BackgroundColor3 = Color3.fromRGB(30, 15, 45)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = screenGui

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 10)
mc.Parent = main

local ms = Instance.new("UIStroke")
ms.Color = Color3.fromRGB(160, 80, 220)
ms.Thickness = 2
ms.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundColor3 = Color3.fromRGB(45, 20, 65)
title.Text = "  BINH FFLAGS"
title.TextColor3 = Color3.fromRGB(200, 140, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = main

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 10)
tc.Parent = title

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 160)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.BorderSizePixel = 0
closeBtn.Parent = title

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 6)
cc.Parent = closeBtn

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 24)
status.Position = UDim2.new(0, 10, 0, 42)
status.BackgroundTransparency = 1
status.Text = "Status: not running"
status.TextColor3 = Color3.fromRGB(180, 160, 200)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.Code
status.TextSize = 10
status.Parent = main

local function makeButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 34)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local defaultBtn = makeButton("USE DEFAULT FFLAGS", 72, Color3.fromRGB(120, 60, 180), function()
    local n = applyFlags(FFlags_Default)
    removeAllEffects()
    if n > 0 then
        status.Text = "Applied " .. n .. " flags + effects removed"
        status.TextColor3 = Color3.fromRGB(180, 255, 180)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "BINH FFLAGS",
            Text = "Applied " .. n .. " flags. Rejoin to take effect!",
            Duration = 5,
        })
    else
        status.Text = "Executor does not support setfflag"
        status.TextColor3 = Color3.fromRGB(255, 120, 120)
    end
end)

local customBtn = makeButton("USE CUSTOM FFLAGS", 114, Color3.fromRGB(80, 40, 140), function()
    local prompt = Instance.new("TextBox")
    prompt.Size = UDim2.new(0, 300, 0, 100)
    prompt.Position = UDim2.new(0.5, -150, 0.5, -50)
    prompt.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    prompt.TextColor3 = Color3.fromRGB(200, 140, 255)
    prompt.Font = Enum.Font.Code
    prompt.TextSize = 11
    prompt.Text = '{"FFlagName": "True"}'
    prompt.MultiLine = true
    prompt.ClearTextOnFocus = false
    prompt.Parent = screenGui

    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 8)
    pc.Parent = prompt

    local ps = Instance.new("UIStroke")
    ps.Color = Color3.fromRGB(160, 80, 220)
    ps.Parent = prompt

    local okBtn = Instance.new("TextButton")
    okBtn.Size = UDim2.new(0, 100, 0, 30)
    okBtn.Position = UDim2.new(0.5, -50, 0.5, 60)
    okBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 180)
    okBtn.Text = "APPLY"
    okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    okBtn.Font = Enum.Font.GothamBold
    okBtn.TextSize = 12
    okBtn.Parent = screenGui

    local okc = Instance.new("UICorner")
    okc.CornerRadius = UDim.new(0, 6)
    okc.Parent = okBtn

    okBtn.MouseButton1Click:Connect(function()
        local success, parsed = pcall(function()
            return game:GetService("HttpService"):JSONDecode(prompt.Text)
        end)
        if success and type(parsed) == "table" then
            local n = applyFlags(parsed)
            status.Text = "Custom: " .. n .. " flags applied"
            status.TextColor3 = Color3.fromRGB(180, 255, 180)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "BINH FFLAGS",
                Text = "Custom " .. n .. " flags. Rejoin!",
                Duration = 5,
            })
        else
            status.Text = "Invalid JSON"
            status.TextColor3 = Color3.fromRGB(255, 120, 120)
        end
        prompt:Destroy()
        okBtn:Destroy()
    end)
end)

local rejoinBtn = makeButton("REJOIN", 156, Color3.fromRGB(80, 30, 60), function()
    status.Text = "Rejoining..."
    task.wait(0.3)
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

task.spawn(function()
    while task.wait(2) do
        removeAllEffects()
    end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    removeAllEffects()
end)

print("[BINH FFLAGS] Loaded. RightShift toggle.")
