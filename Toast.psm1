function New-ToastNotification{
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$TopText = $null,

        [Parameter()]
        [string]$BottomText = $null,

        [Parameter()]
        [string]$ImageSource = $null,

        [Parameter()]
        [ValidateSet("appLogoOverride", "hero", "")]
        [string]$ImagePlacement,

        [Parameter()]
        [switch]$ImageCrop,

        [Parameter()]
        [ValidateSet("reminder", "alarm", "incomingCall", "urgent")]
        [string]$Scenario,
        
        [Parameter()]
        [ValidateSet("silent","ms-winsoundevent:Notification.Default","ms-winsoundevent:Notification.IM","ms-winsoundevent:Notification.Mail","ms-winsoundevent:Notification.Reminder","ms-winsoundevent:Notification.SMS","ms-winsoundevent:Notification.Looping.Alarm","ms-winsoundevent:Notification.Looping.Alarm2","ms-winsoundevent:Notification.Looping.Alarm3","ms-winsoundevent:Notification.Looping.Alarm4","ms-winsoundevent:Notification.Looping.Alarm5","ms-winsoundevent:Notification.Looping.Alarm6","ms-winsoundevent:Notification.Looping.Alarm7","ms-winsoundevent:Notification.Looping.Alarm8","ms-winsoundevent:Notification.Looping.Alarm9","ms-winsoundevent:Notification.Looping.Alarm10","ms-winsoundevent:Notification.Looping.Call","ms-winsoundevent:Notification.Looping.Call2","ms-winsoundevent:Notification.Looping.Call3","ms-winsoundevent:Notification.Looping.Call4","ms-winsoundevent:Notification.Looping.Call5","ms-winsoundevent:Notification.Looping.Call6","ms-winsoundevent:Notification.Looping.Call7","ms-winsoundevent:Notification.Looping.Call8","ms-winsoundevent:Notification.Looping.Call9","ms-winsoundevent:Notification.Looping.Call10")]
        [string]$AlarmSource = "ms-winsoundevent:Notification.Default",

        [Parameter()]
        [switch]$Loop,

        [Parameter()]
        [string]$Button1Action = $null,

        [Parameter()]
        [string]$Button1Text = $null,

        [Parameter()]
        [string]$Button2Action = $null,

        [Parameter()]
        [string]$Button2Text = $null,

        [Parameter()]
        [System.IO.FileInfo]$OutFile
    )

    #Load the necessary WinRT API namespace
    [Windows.Data.Xml.Dom.XmlDocument,Windows.Data.Xml.Dom,ContentType=WindowsRuntime] | Out-Null

    #Create xml document object
    $toastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()

    #Create the root xml element
    $toastXml.AppendChild($Toastxml.CreateElement("toast")) | Out-Null

    #Set the type of notification - this will affect how the notification behaves
    $toastNode = $Toastxml.SelectSingleNode("/toast")
    $toastNode.SetAttribute("scenario", $scenario)

    #Create the visual element, parent of the binding element
    $toastNode.AppendChild($toastXml.CreateElement("visual")) | Out-Null

    #Create the binding element, and set the notification template
    $visualNode = $toastXml.SelectSingleNode("//toast/visual")
    $visualNode.AppendChild($toastXml.CreateElement("binding")) | Out-Null
    $bindingNode = $toastXml.SelectSingleNode("//toast/visual/binding")
    $bindingNode.SetAttribute("template", "ToastGeneric")

    #Create the text and image elements and set their attributes
    $bindingNode.AppendChild($toastXml.CreateElement("text")) | Out-Null
    $bindingNode.AppendChild($toastXml.CreateElement("image")) | Out-Null

    $textNode1 = $toastXml.SelectSingleNode("//toast/visual/binding/text[1]")
    $textNode1.SetAttribute("id",1)
    $textNode1.InnerText = $TopText
    $imageNode = $toastXml.SelectSingleNode("//toast/visual/binding/image")
    $imageNode.SetAttribute("id",1)
    $imageNode.SetAttribute("src", $ImageSource)
    $imageNode.SetAttribute("placement", $imagePlacement)

    if ($bottomText){
        $bindingNode.AppendChild($toastXml.CreateElement("text")) | Out-Null
        $textNode2 = $toastXml.SelectSingleNode("//toast/visual/binding/text[2]")
        $textNode2.SetAttribute("id",2)
        $textNode2.InnerText = $BottomText
    }
    
    if ($ImageCrop.IsPresent){
        $imageNode.SetAttribute("hint-crop", "circle")
    }

    #Create the audio element, choose what audio will play when the toast pops, and set looping
    $toastNode.AppendChild($toastXml.CreateElement("audio")) | Out-Null
    $audioNode = $toastXml.SelectSingleNode("//toast/audio")

    if ($alarmSource -eq "silent"){
        $audioNode.SetAttribute("silent", "true")
    }
    else {
        $audioNode.SetAttribute("src", $AlarmSource)
        
        if ($Loop.IsPresent){
            $audioNode.SetAttribute("loop", "true")
        }
    }
    
    #Create the action (button) elements and set what they do when clicked
    if ($button1Text -and $button1Action){
        $toastNode.AppendChild($toastXml.CreateElement("actions"))  | Out-Null
        $actionsNode = $toastXml.SelectSingleNode("//toast/actions")
        $actionsNode.AppendChild($toastXml.CreateElement("action"))  | Out-Null
        $actionNode1 = $toastXml.SelectSingleNode("//toast/actions/action[1]")
        $actionNode1.SetAttribute("content", $button1Text)
        $actionNode1.SetAttribute("arguments", $button1Action)
        $actionNode1.SetAttribute("activationType", "protocol")

        if ($button2Text -and $button2Action){
            $actionsNode.AppendChild($toastXml.CreateElement("action"))  | Out-Null
            $actionNode2 = $toastXml.SelectSingleNode("//toast/actions/action[2]")
            $actionNode2.SetAttribute("content", $button2Text)
            $actionNode2.SetAttribute("arguments", $button2Action)
            $actionNode2.SetAttribute("activationType", "protocol")
        }
    }

    #If an outfile is specified, write XML content to file, else simply output XML
    if ($outFile){
        $toastXml.getxml() | Out-File $outFile -Force | Out-Null

        if (Test-Path $outFile){
            Write-Host "XML content saved: $($outFile)" | Out-Null
        }

        return $OutFile
    }
    else {
        return $toastXml.getxml()
    }
}

function Pop-ToastNotification{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [string]$XmlContent,

        [Parameter()]
        [switch]$File,

    #The LauncherID defines the name of the app that calls the toast notification and appears on the top of the toast - the app must be registered in the registry beforehand - please see wiki for more info
        [Parameter(Mandatory)]
        [string]$launcherID = $null,
    )

    if ($launcherID == $null) {
        return "Missing required argument '-launcherID'"
    }

    #Load the necessary WinRT namespaces
    [Windows.UI.Notifications.ToastNotificationManager,Windows.UI.Notifications,ContentType=WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification,Windows.UI.Notifications,ContentType=WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument,Windows.Data.Xml.Dom,ContentType=WindowsRuntime] | Out-Null

    #Create an XML object and load the XML content, either from direct input or a file
    if ($file.IsPresent){
        $toastXmlObject = [Windows.Data.Xml.Dom.XmlDocument]::new()
        $toastXmlObject.LoadXml((Get-Content $xmlContent))
    }
    else {
        $toastXmlObject = [Windows.Data.Xml.Dom.XmlDocument]::new()
        $toastXmlObject.LoadXml($xmlContent)
    }

    #Convert the toast xml object to a toast notification object
    $toastNotification = [Windows.UI.Notifications.ToastNotification]::new($toastXmlObject)
    
    #Set the notification to disappear from the Notification center on reboot
    $toastNotification.ExpiresOnReboot = $true

    #Pop the toast
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($launcherID).show($toastNotification)
}