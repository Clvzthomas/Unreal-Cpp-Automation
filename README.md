# Unreal C++ Automation Pipeline

A PowerShell toolkit for making controlled, repeatable edits to Unreal Engine C++ projects, verifying changes, backing up files, and running Unreal builds.

## Features

- Configurable Unreal project and engine paths
- Exact-text patching with duplicate-match protection
- Idempotency checks (safe to rerun)
- Automatic timestamped backups
- Marker verification
- Unreal Build Tool wrapper
- AI-assisted patch workflow with a strict review-before-write pattern

## Requirements

- Windows 10/11
- Windows PowerShell 5.1 or PowerShell 7+
- Unreal Engine installed locally
- A C++ Unreal project

No Unreal plugin is required. The toolkit edits source files on disk and invokes the engine's build script.

## Quick start

1. Extract this repository somewhere outside your Unreal project.
2. Copy `Config/ProjectConfig.example.psd1` to `Config/ProjectConfig.psd1`.
3. Edit the paths and build settings in `ProjectConfig.psd1`.
4. Open PowerShell in the repository folder.
5. Run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Examples\Test-Pipeline.ps1
```

The test example only reads and reports configuration. It does not modify project files.

## Applying a patch

Use `Modules/Invoke-ExactTextPatch.ps1` for a precise replacement. The old text must occur exactly once. If the new text is already present and the old text is absent, the tool reports `ALREADY APPLIED`. If the old text is missing or occurs more than once, it stops without writing.

Example:

```powershell
. .\Modules\Invoke-ExactTextPatch.ps1

Invoke-ExactTextPatch `
  -Path (Join-Path $ProjectConfig.ProjectRoot "Source/MyGame/MyActor.cpp") `
  -OldText @'
Old code goes here
'@ `
  -NewText @'
New code goes here
'@ `
  -BackupRoot $ProjectConfig.BackupRoot `
  -WhatIf
```

Remove `-WhatIf` only after reviewing the proposed change. The script creates a backup before writing.

## Build

```powershell
.\Modules\Build-UnrealProject.ps1 -ConfigPath .\Config\ProjectConfig.psd1
```

The build wrapper uses the configured `Build.bat`, project file, target, platform, and configuration. It returns the actual build exit code.

## AI-assisted workflow

1. Ask your coding assistant to inspect the relevant function or code block.
2. Have it propose a minimal patch and identify exact old/new text.
3. Review the patch yourself.
4. Run the patch with `-WhatIf`.
5. Inspect the diff or file contents.
6. Run again without `-WhatIf` to apply.
7. Run marker checks and build.
8. Test in Unreal Editor and in the target platform.

AI-generated code is not automatically trusted. Always review patches and keep backups.

## Safety model

- No broad regex replacement by default.
- Exact old text must match once.
- A missing or ambiguous match causes a no-write failure.
- A backup is created before a write.
- `-WhatIf` previews without modifying the target.
- Build failures are reported via the process exit code.

This is a starter toolkit, not a substitute for Git commits, code review, or testing. Commit or stash your work before applying significant patches.

## Repository layout

```text
Config/
  ProjectConfig.example.psd1
Modules/
  Invoke-ExactTextPatch.ps1
  Test-FileMarkers.ps1
  Build-UnrealProject.ps1
Examples/
  Test-Pipeline.ps1
  Remove-DebugCone-Template.ps1
  Modify-VirtualJoystick-Template.ps1
.gitignore
LICENSE
README.md
```

## License

MIT. See `LICENSE`.
