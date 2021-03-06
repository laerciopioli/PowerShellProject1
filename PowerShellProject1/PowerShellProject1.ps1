#
# Script.ps1
#

#Creating the Log path and file.
if (-Not (Test-Path -Path C:\Laercio\PowerShellProject1 -PathType Leaf))
{
mkdir C:\Laercio\PowerShellProject1\log
}
Start-Transcript C:\Laercio\PowerShellProject1\log\transcript.log -Append


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
  if ( $runAt.ToString($timeFormat) -eq $now.ToString($timeFormat) ) {

    try {
      # Your code here
      # Don't forget to clean up your variables so GC frees up memory
      # e.g. Remove-Variable, $var = $null, etc.

      if (Test-Path -Path  C:\Laercio\PowerShellProject1\ExpSystemCall.txt -PathType Leaf)
      {
        
          #GET THE FILE CONTENT AND SAVE IT INTO A VARIABLE
          #working fine when reading a file content
          $firstLine = Get-Content C:\Laercio\PowerShellProject1\ExpSystemCall.txt -First 1 
                  
          #RUN CMD WITH THE STRING CODE
          cmd.exe /c $firstLine



        #AFTER GETTING THE STRING CODE, DELETE IT!!!!!!!!!!!!.
          #working fine for a specific directory
        #Remove-Item –path Z:\Input Data\ExpSystemCall.txt –recurse  
          #Working fine for a specific file.       
        Remove-Item C:\Laercio\PowerShellProject1\ExpSystemCall.txt -Recurse
          
      }Else
      {	      
          Write-Host "Please, create the file on the PSMORA WEB SERVER!!"

	  }

    }
    catch {
      # Write the error but don't blow up
      $_
          Write-Host "THE EXPERIMENTAL FILE DOES NOT EXIST!!!"
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
  }
  else {
    if ( $runAt -lt $now ) {
      $runAt.AddDays(1)
    }
  }
  
  # Check every minute since you aren't using a scheduler
  #Sleep 5
  Start-Sleep -Seconds 2
}