# Toast
Send and receive toast notifications on Windows.

Introduction
============
Toast is a PowerShell module that allows you to create, save and pop toast notifications on Windows devices that support them. Toast notifications are those that pop up in the corner, by the Windows taskbar:

![image](https://github.com/cannnoeli/Toast/assets/81331851/323b7797-1774-4828-8744-0c76f44347f7)

I was influenced by the [BurntToast](https://github.com/Windos/BurntToast) module, and decided to create this module to get a better understanding of how toast notifications work.

Requirements
============
- Windows PowerShell 5.1

Prerequisites
=====================
Before you can start using the module, you must register an 'app' that will send the notification:

This 'app' is just a name that you add to the registry.  
Create a new key under HKEY_CLASSES_ROOT\AppUserModelId - name it the name of your 'app'.  
Under this new key, create a new string value named 'DisplayName'. Set the data to the name that you want to appear as the app associated with your toast notification.  
Create a DWORD value named 'ShowInSettings' with the data being 0.

Installation & Usage
====================
To install, add the Toast folder, parent of the 1.0 folder, to C:\Program Files\WindowsPowershell\Modules\. This will make the module available without having to import into your PS session manually. Add this to any PCs that will be sending and/or receiving toast notifications.

Toast notifications will only appear to the end user if the commands are ran by that end user. There are a handful of ways to run commands as the currently logged on user - my preferred method is to run the commands via PDQ Deploy with the Run As option set to Logged on User.

<h3>Available cmdlets:</h3>

<h4>Name</h4>
New-ToastNotification  

<h4>Synopsis</h4>
Allows you to create the toast notification, and optionally save it as an XML file that you can reuse.  

<h4>Syntax</h4>
<code>New-ToastNotification</code> <code>[[-TopText] &lt;String&gt;]</code> <code>[[-BottomText] &lt;String&gt;]</code> <code>[[-ImageSource] &lt;String&gt;]</code> <code>[[-ImagePlacement &lt;String&gt; {appLogoOverride | hero | ""}]</code> <code>[-ImageCrop]</code> <code>[[-Scenario] &lt;String&gt; {reminder | alarm | incomingCall | urgent}]</code> <code>[[-AlarmSource] &lt;String&gt; {silent | ms-winsoundevent:Notification.Default | ms-winsoundevent:Notification.IM | ms-winsoundevent:Notification.Mail | ms-winsoundevent:Notification.Reminder | ms-winsoundevent:Notification.SMS | ms-winsoundevent:Notification.Looping.Alarm | ms-winsoundevent:Notification.Looping.Alarm2 | ms-winsoundevent:Notification.Looping.Alarm3 | ms-winsoundevent:Notification.Looping.Alarm4 | ms-winsoundevent:Notification.Looping.Alarm5 | ms-winsoundevent:Notification.Looping.Alarm6 | ms-winsoundevent:Notification.Looping.Alarm7 | ms-winsoundevent:Notification.Looping.Alarm8 | ms-winsoundevent:Notification.Looping.Alarm9 | ms-winsoundevent:Notification.Looping.Alarm10 | ms-winsoundevent:Notification.Looping.Call | ms-winsoundevent:Notification.Looping.Call2 | ms-winsoundevent:Notification.Looping.Call3 | ms-winsoundevent:Notification.Looping.Call4 | ms-winsoundevent:Notification.Looping.Call5 | ms-winsoundevent:Notification.Looping.Call6 | ms-winsoundevent:Notification.Looping.Call7 | ms-winsoundevent:Notification.Looping.Call8 | ms-winsoundevent:Notification.Looping.Call9 | ms-winsoundevent:Notification.Looping.Call10}]</code> <code>[-Loop]</code> <code>[[-Button1Action] &lt;String&gt;]</code> <code>[[-Button1Text] &lt;String&gt;]</code> <code>[[-Button2Action] &lt;String&gt;]</code> <code>[[-Button2Text] &lt;String&gt;]</code> <code>[[-OutFile] &lt;String&gt;]</code>

<h4>Parameters</h4>

<code>-TopText &lt;String&gt;</code>  
Specifies the text that will appear at the top of the notification

<code>-BottomText &lt;String&gt;</code>  
Specifies the text that will appear near the bottom of the notification

<code>-ImageSource &lt;String&gt;</code>  
Specifies the image that will appear on your toast notification

<code>-ImagePlacement &lt;String&gt;</code>  
Specifies how the image will be displayed  
Acceptable values include:  

"" (default)  
appLogoOverride  
hero

<code>-ImageCrop &lt;SwitchParameter&gt;</code>  
If enabled, it will crop the image to a circle

<code>-Scenario &lt;String&gt;</code>  
Specifies the behavior of the notification  
Acceptable values include:  

reminder  
alarm  
incomingCall  
urgent

<code>-AlarmSource &lt;String&gt;</code>  
Specifies the alarm to use for the notification  
Acceptable values include:  

silent  
ms-winsoundevent:Notification.Default (default)  
ms-winsoundevent:Notification.IM  
ms-winsoundevent:Notification.Mail  
ms-winsoundevent:Notification.Reminder  
ms-winsoundevent:Notification.SMS  
ms-winsoundevent:Notification.Looping.Alarm  
ms-winsoundevent:Notification.Looping.Alarm2  
ms-winsoundevent:Notification.Looping.Alarm3  
ms-winsoundevent:Notification.Looping.Alarm4  
ms-winsoundevent:Notification.Looping.Alarm5  
ms-winsoundevent:Notification.Looping.Alarm6  
ms-winsoundevent:Notification.Looping.Alarm7  
ms-winsoundevent:Notification.Looping.Alarm8  
ms-winsoundevent:Notification.Looping.Alarm9  
ms-winsoundevent:Notification.Looping.Alarm10  
ms-winsoundevent:Notification.Looping.Call  
ms-winsoundevent:Notification.Looping.Call2  
ms-winsoundevent:Notification.Looping.Call3  
ms-winsoundevent:Notification.Looping.Call4  
ms-winsoundevent:Notification.Looping.Call5  
ms-winsoundevent:Notification.Looping.Call6  
ms-winsoundevent:Notification.Looping.Call7  
ms-winsoundevent:Notification.Looping.Call8  
ms-winsoundevent:Notification.Looping.Call9  
ms-winsoundevent:Notification.Looping.Call10

<code>-Loop &lt;SwitchParameter&gt;</code>  
If enabled, the alarm sound will loop for the duration of the notification

<code>-Button1Action &lt;String&gt;</code>  
Specifies the action to take when the first button is clicked - you can use URL protocol handlers to customize the application that is triggered by the button click

<code>-Button1Text &lt;String&gt;</code>  
Specifies the text to be shown on the first button

<code>-Button2Action &lt;String&gt;</code>  
Specifies the action to take when the second button is clicked - you can use URL protocol handlers to customize the application that is triggered by the button click

<code>-Button1Text &lt;String&gt;</code>  
Specifies the text to be shown on the second button

<code>-OutFile &lt;String&gt;</code>  
Specifies the file to be created with the set parameters - must be an XML file in order to be usable by Pop-ToastNotification

<hr>

<h4>Name</h4>
Pop-ToastNotification

<h4>Synopsis</h4>
Pops the toast notification, either from the piped output of New-ToastNotification or an XML file.

<h4>Syntax</h4>
<code>Pop-ToastNotification</code> <code>-File &lt;String&gt;</code>

<h4>Parameters</h4>

<code>-File &lt;String&gt;</code>  
Specifies the XML file from which to load the toast notification parameters
