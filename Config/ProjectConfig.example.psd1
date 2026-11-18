@{
    # Absolute path to the Unreal project folder (the folder containing the .uproject).
    ProjectRoot = "D:\UnrealProjects\MyGame"

    # Project file name, relative to ProjectRoot.
    ProjectFile = "MyGame.uproject"

    # Absolute path to the Unreal Engine Build.bat.
    # Example: "C:\Program Files\Epic Games\UE_5.8\Engine\Build\BatchFiles\Build.bat"
    BuildBatch = "C:\Program Files\Epic Games\UE_5.8\Engine\Build\BatchFiles\Build.bat"

    # Build target is commonly <ProjectName>Editor for editor builds.
    Target = "MyGameEditor"
    Platform = "Win64"
    Configuration = "Development"

    # Backups are stored outside Source by default.
    BackupRoot = "D:\UnrealProjects\MyGame_AutomationBackups"

    # Optional extra arguments passed to Build.bat.
    ExtraBuildArguments = @("-waitmutex")
}
