Dim shell, cmd, result
Set shell = CreateObject("WScript.Shell")

cmd = "powershell.exe -ExecutionPolicy Bypass -Command """ & _
    "$src = '" & shell.ExpandEnvironmentStrings("%USERPROFILE%") & "\MBPS agency hub\moyo-crm-agent'; " & _
    "$out = '" & shell.ExpandEnvironmentStrings("%USERPROFILE%") & "\MBPS agency hub\moyo-crm-agent.plugin'; " & _
    "if (Test-Path $out) { Remove-Item $out -Force }; " & _
    "Compress-Archive -Path ($src + '\*') -DestinationPath $out -Force; " & _
    "if (Test-Path $out) { Write-Host 'SUCCESS' } else { Write-Host 'FAILED' }" & _
    """"

result = shell.Run(cmd, 1, True)

Dim outFile
outFile = shell.ExpandEnvironmentStrings("%USERPROFILE%") & "\MBPS agency hub\moyo-crm-agent.plugin"

If shell.FileExists(outFile) Then
    MsgBox "SUCCESS!" & vbCrLf & vbCrLf & "moyo-crm-agent.plugin has been created in your MBPS agency hub folder." & vbCrLf & vbCrLf & "You can now install it in Cowork: Settings → Plugins → Install from file.", vbInformation, "Plugin Built"
Else
    MsgBox "Something went wrong. The plugin file was not created. Please check that the moyo-crm-agent folder exists.", vbCritical, "Build Failed"
End If

Set shell = Nothing
