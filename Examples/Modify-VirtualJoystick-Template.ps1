# TEMPLATE ONLY: illustrates the C++ snippet from the original workflow.
# It does not edit a project file. Confirm the correct class/function and
# exact insertion point in your own project before constructing a patch.

$snippet = @'
UTouchInterface* BaseTouch =
    LoadObject<UTouchInterface>(
        nullptr,
        TEXT("/Engine/MobileResources/HUD/DefaultVirtualJoysticks.DefaultVirtualJoysticks"));

if (BaseTouch)
{
    UTouchInterface* TouchInterface =
        DuplicateObject<UTouchInterface>(BaseTouch, this);

    if (TouchInterface->Controls.Num() >= 2)
    {
        TouchInterface->Controls[0].VisualSize *= 0.80f;
        TouchInterface->Controls[0].ThumbSize  *= 0.80f;
        TouchInterface->Controls[0].Center.X += 0.03f;
        TouchInterface->Controls[0].Center.Y -= 0.03f;

        TouchInterface->Controls[1].VisualSize *= 0.80f;
        TouchInterface->Controls[1].ThumbSize  *= 0.80f;

        ActivateTouchInterface(TouchInterface);
    }
}
'@

Write-Host "Example joystick snippet loaded ($($snippet.Length) characters)."
Write-Host "No files were modified."
