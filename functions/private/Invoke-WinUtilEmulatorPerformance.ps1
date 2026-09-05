function Invoke-WinUtilEmulatorPerformance {
    <#
    .SYNOPSIS
        Dedicated MSI App Player / BlueStacks performance optimization suite.
    .DESCRIPTION
        Detects common HD-Player installations and applies reversible Windows-side
        scheduling, GPU, fullscreen, gaming, networking and virtualization settings.
        Emulator-internal settings are only changed when their known registry keys exist.
    .PARAMETER Mode
        Optimize, FPS, CPU, Network, Virtualization, Gaming, Input, Live, or Status.
    #>
    param(
        [ValidateSet("Optimize","FPS","CPU","Network","Virtualization","Gaming","Input","Live","Power","Cleanup","HAGS","Background","Status")]
        [string]$Mode = "Optimize"
    )

    $emulatorPaths = @(
        "C:\Program Files\BlueStacks_nxt\HD-Player.exe",
        "C:\Program Files\BlueStacks\HD-Player.exe",
        "C:\Program Files\MSI App Player\HD-Player.exe",
        "${env:ProgramFiles(x86)}\BlueStacks_nxt\HD-Player.exe",
        "${env:ProgramFiles(x86)}\MSI App Player\HD-Player.exe"
    ) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique

    $gpuPrefPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
    $compatPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
    $ifEOPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\HD-Player.exe\PerfOptions"
    $engineKeys = @(
        "HKLM:\SOFTWARE\BlueStacks_nxt\Guests\Android\Config",
        "HKLM:\SOFTWARE\MSI App Player\Guests\Android\Config",
        "HKLM:\SOFTWARE\WOW6432Node\BlueStacks_nxt\Guests\Android\Config",
        "HKLM:\SOFTWARE\WOW6432Node\MSI App Player\Guests\Android\Config"
    )

    function Ensure-Key([string]$Path) {
        if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    }

    function Set-EmulatorGpu {
        Ensure-Key $gpuPrefPath
        foreach ($path in $emulatorPaths) {
            Set-ItemProperty -Path $gpuPrefPath -Name $path -Type String -Value "GpuPreference=2;" -Force
        }
    }

    function Set-EmulatorFPS {
        foreach ($key in $engineKeys) {
            if (Test-Path $key) {
                # Existing installations vary in which engine keys they expose.
                Set-ItemProperty -Path $key -Name "HighFps" -Type DWord -Value 1 -Force -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $key -Name "Fps" -Type DWord -Value 240 -Force -ErrorAction SilentlyContinue
                Set-ItemProperty -Path $key -Name "GlType" -Type DWord -Value 1 -Force -ErrorAction SilentlyContinue
            }
        }
    }

    function Set-EmulatorCPU {
        Ensure-Key $ifEOPath
        # 3 = High priority. Do not use Realtime because it can starve Windows.
        Set-ItemProperty -Path $ifEOPath -Name "CpuPriorityClass" -Type DWord -Value 3 -Force
        Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue | ForEach-Object {
            try { $_.PriorityClass = "High" } catch {}
        }
    }

    function Set-EmulatorInput {
        Ensure-Key $compatPath
        foreach ($path in $emulatorPaths) {
            Set-ItemProperty -Path $compatPath -Name $path -Type String -Value "~ DISABLEDXMAXIMIZEDWINDOWEDMODE HIGHDPIAWARE" -Force
        }
        # Reduce the classic menu delay without changing mouse acceleration.
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type String -Value "0" -Force
    }

    function Set-EmulatorNetwork {
        $mmcss = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        Ensure-Key $mmcss
        Set-ItemProperty -Path $mmcss -Name "NetworkThrottlingIndex" -Type DWord -Value 4294967295 -Force
        Set-ItemProperty -Path $mmcss -Name "SystemResponsiveness" -Type DWord -Value 0 -Force
        # Keep TCP autotuning at Microsoft's normal adaptive mode rather than disabling it.
        & netsh.exe int tcp set global autotuninglevel=normal | Out-Null
    }

    function Set-EmulatorGaming {
        $gameConfig = "HKCU:\Software\Microsoft\GameBar"
        $capture = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"
        Ensure-Key $gameConfig; Ensure-Key $capture
        Set-ItemProperty -Path $gameConfig -Name "AllowAutoGameMode" -Type DWord -Value 1 -Force
        Set-ItemProperty -Path $gameConfig -Name "AutoGameModeEnabled" -Type DWord -Value 1 -Force
        Set-ItemProperty -Path $capture -Name "AppCaptureEnabled" -Type DWord -Value 0 -Force
        Set-ItemProperty -Path $gameConfig -Name "ShowStartupPanel" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
    }

    function Set-EmulatorVirtualization {
        Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform" -NoRestart -ErrorAction SilentlyContinue | Out-Null
        Enable-WindowsOptionalFeature -Online -FeatureName "HypervisorPlatform" -NoRestart -ErrorAction SilentlyContinue | Out-Null
    }

    function Set-EmulatorLive {
        Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $_.PriorityClass = "High"
                if ($_.Responding) { Write-Host "Boosted HD-Player PID $($_.Id)" -ForegroundColor Green }
            } catch {}
        }
    }


    function Set-EmulatorPower {
        & powercfg.exe -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        & powercfg.exe /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
        Write-Host "Ultimate Performance power plan requested." -ForegroundColor Green
    }

    function Set-EmulatorCleanup {
        $dirs = @(
            "$env:TEMP\BlueStacks*", "$env:TEMP\MSI App Player*",
            "$env:LOCALAPPDATA\BlueStacks*\Logs", "$env:LOCALAPPDATA\MSI App Player*\Logs"
        )
        foreach ($pattern in $dirs) {
            Get-Item $pattern -ErrorAction SilentlyContinue | ForEach-Object {
                Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        Write-Host "Safe emulator log/temp cleanup completed." -ForegroundColor Green
    }

    function Set-EmulatorHAGS {
        $path = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
        Ensure-Key $path
        Set-ItemProperty -Path $path -Name "HwSchMode" -Type DWord -Value 2 -Force
        Write-Host "Hardware-accelerated GPU scheduling enabled where supported." -ForegroundColor Green
    }

    function Set-EmulatorBackground {
        $capture = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"
        $gameBar = "HKCU:\Software\Microsoft\GameBar"
        Ensure-Key $capture; Ensure-Key $gameBar
        Set-ItemProperty -Path $capture -Name "AppCaptureEnabled" -Type DWord -Value 0 -Force
        Set-ItemProperty -Path $gameBar -Name "ShowStartupPanel" -Type DWord -Value 0 -Force -ErrorAction SilentlyContinue
        Write-Host "Background capture overhead reduced." -ForegroundColor Green
    }

    Write-Host "CASH Emulator Optimization: $Mode" -ForegroundColor Magenta

    switch ($Mode) {
        "Optimize" {
            Set-EmulatorGpu
            Set-EmulatorFPS
            Set-EmulatorCPU
            Set-EmulatorInput
            Set-EmulatorNetwork
            Set-EmulatorGaming
            Set-EmulatorVirtualization
            Set-EmulatorLive
            Set-EmulatorPower
            Set-EmulatorHAGS
            Set-EmulatorBackground
            Write-Host "Full MSI App Player / BlueStacks optimization applied. A reboot may be required for virtualization changes." -ForegroundColor Green
        }
        "FPS" { Set-EmulatorGpu; Set-EmulatorFPS; Write-Host "GPU and high-FPS engine settings applied." -ForegroundColor Green }
        "CPU" { Set-EmulatorCPU; Write-Host "High CPU priority applied." -ForegroundColor Green }
        "Network" { Set-EmulatorNetwork; Write-Host "Network/MMCSS latency settings applied." -ForegroundColor Green }
        "Virtualization" { Set-EmulatorVirtualization; Write-Host "Virtualization platform features enabled where supported. Reboot Windows to complete." -ForegroundColor Green }
        "Gaming" { Set-EmulatorGaming; Write-Host "Windows gaming/background capture settings optimized." -ForegroundColor Green }
        "Input" { Set-EmulatorInput; Write-Host "Fullscreen/input compatibility settings applied." -ForegroundColor Green }
        "Live" { Set-EmulatorLive; Write-Host "Running emulator processes boosted." -ForegroundColor Green }
        "Power" { Set-EmulatorPower }
        "Cleanup" { Set-EmulatorCleanup }
        "HAGS" { Set-EmulatorHAGS }
        "Background" { Set-EmulatorBackground }
        "Status" {
            if ($emulatorPaths.Count -eq 0) {
                Write-Host "No standard BlueStacks/MSI App Player installation was detected." -ForegroundColor Yellow
            } else {
                $emulatorPaths | ForEach-Object { Write-Host "Detected: $_" -ForegroundColor Green }
            }
            $running = @(Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue)
            Write-Host "Running HD-Player processes: $($running.Count)" -ForegroundColor Cyan
        }
    }
}
