# CASH UI & Emulator Optimization Upgrade

## UI
- CASH Black & Purple is now the default theme.
- Added animated black/purple accent line.
- Added expanded theme selector: CASH Black & Purple, Midnight Violet, Cyber Purple,
  AMOLED Purple, Purple Ice, Purple Dark, Dracula, Nord, Catppuccin, Tokyo Night,
  Gruvbox, and One Dark.
- Removed the visible Win11 Creator navigation button while keeping its underlying
  tab/functionality available in the codebase.
- Added a dedicated **Emulator Optimization** navigation bar.

## Emulator Optimization
The new panel targets MSI App Player / BlueStacks `HD-Player.exe` and includes:
- One-click optimization
- GPU preference / high-performance routing
- High-FPS engine configuration (when the installation exposes supported keys)
- High CPU process priority
- Fullscreen compatibility tuning
- MMCSS network responsiveness / throttling tuning
- Game Mode and background capture cleanup
- Virtual Machine Platform + Windows Hypervisor Platform
- Live running-process priority boost
- Emulator detection/status

The module avoids Realtime process priority and does not disable TCP autotuning;
it uses Windows' normal adaptive TCP mode.
