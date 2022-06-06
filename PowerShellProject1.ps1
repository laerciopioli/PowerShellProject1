#
# Script.ps1
#

#Creating the Log path and file.
if (-Not (Test-Path -Path Z:\log -PathType Leaf))
{
mkdir Z:\log
}
Start-Transcript Z:\log\transcript.log -Append


# Use 24 hour time
$runAt = Get-Date -Hour 17 -Minute 0 -Second 0
$now = Get-Date

$timeFormat = 'HH:mm'

# If we're after the time for today, add a day
if ( $runAt -lt $now ) {

  $runAt.AddDays(1)
}

while ( $true ) {

  $now = Get-Date
  #if ( $runAt.ToString($timeFormat) -eq $now.ToString($timeFormat) ) {

    try {
      # Your code here
      # Don't forget to clean up your variables so GC frees up memory
      # e.g. Remove-Variable, $var = $null, etc.

      if (Test-Path -Path  Z:\Input_Data\ExpSystemCall.txt -PathType Leaf)
      {
          Set-Location C:\Laercio\Release

        
          #GET THE FILE CONTENT AND SAVE IT INTO A VARIABLE
          #working fine when reading a file content
          
          #1 Running fine
          $goPath = cd C:\Laercio\Release 
          $firstLine = Get-Content Z:\Input_Data\ExpSystemCall.txt -First 1 
          
          $cmdEXEC = "& $goPath $firstLine"
          
          Invoke-Expression $cmdEXEC




          #RUN CMD WITH THE STRING CODE
          #cmd.exe cd C:\Laercio\Release 
          #cmd.exe /c $firstLine
          
          #Start-Process -Wait -NoNewWindow cmd $firstLine /c, dir -WorkingDirectory C:\Laercio\Release

          
          Start-Process cmd -Argument "/c $cmdEXEC" -RedirectStandardOutput somefile

          #$cmd = "& 'C:\Program Files\7-zip\7z.exe' a -tzip c:\temp\test.zip c:\temp\test.txt"
          #Invoke-Expression $cmd


        #AFTER GETTING THE STRING CODE, DELETE IT!!!!!!!!!!!!.
          #working fine for a specific directory
        #Remove-Item –path Z:\Input Data\ExpSystemCall.txt –recurse  
          #Working fine for a specific file.       
        Remove-Item Z:\Input_Data\ExpSystemCall.txt -Recurse
          
      }Else
      {	      
          Write-Host "THERE IS NO EXPERIMENTATION RUNNING ON THE SERVER!!"
	  }

    }
    catch {
      # Write the error but don't blow up
      $_
          Write-Host "Try again, the experimental file does not exist!!!"
    }
    finally {

      # We need to add a day to the next run, and let's schedule the GC
      # to run while we sleep
      $runAt.AddDays(1)
      [System.GC]::Collect(
        0,
        [System.GCCollectionMode]::Optimized,
        $false
      )
    }
  #}
  #else {
    #if ( $runAt -lt $now ) {
      #$runAt.AddDays(1)
    #}
  #}
  
  # Check every minute since you aren't using a scheduler
  #Sleep 5
  Start-Sleep -Seconds 2
}