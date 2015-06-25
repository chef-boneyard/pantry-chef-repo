# Copyright (c) 2014, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# TODO: Support option for installing ChefDK prerelease, and upgrading.
param (
  [switch]$RunChef
)

Import-Module BitsTransfer

function Get-ChefDK {
  Try {
    Write-Host "Downloading ChefDK"
    Start-BitsTransfer "https://www.chef.io/chef/download-chefdk?p=windows&pv=2008r2&m=x86_64&v=latest" "chefdk.msi"
  } Catch {
    Write-Error $_.Exception
    Exit 110
  }
}

function Install-ChefDK {
  $ProcMsi = Start-Process -FilePath 'msiexec.exe' -ArgumentList "/qn /i chefdk.msi" -Passthru
  $i = 0
  while (-Not $ProcMsi.HasExited) {
    $StatusMsg = "Please Wait" + "." * ($i + 1)
    Write-Progress -Activity "Installing ChefDK" -Status $StatusMsg
    $i = ($i+1) % 3
    Start-Sleep 1
  }
  Write-Progress -Activity "Installing ChefDK" -Completed

  if ($ProcMsi.ExitCode -ne 0) {
    Write-Error "Failed to install ChefDK"
    exit 110
  }

  $env:PATH = $env:PATH + ";" + "C:\opscode\chefdk\bin"
}

function Test-ChefDK {
  Test-Path "C:\opscode\chefdk\version-manifest.txt"
}

function Get-Cookbooks {
  $PolicyfileExists = Test-Path "Policyfile.rb"
  $LockExists = Test-Path "Policyfile.lock.json"
  if ($PolicyfileExists -And -Not $LockExists) {
    Write-Host "Installing Policy to ChefDK cookbook cache and exporting repository to zero-repo."
    chef install
    chef export zero-repo --force
    if ($LASTEXITCODE -ne 0) {
      Write-Error "Chef Policyfile failed to install and export cookbooks!"
      Exit 120
    }
  }
}

function Invoke-ChefClient
{
  Write-Host "Running chef-client with the pantry default recipe."
  chef-client -z
  if ($LASTEXITCODE -ne 0) {
    Write-Error "chef-client run failed"
    Exit 130
  }
}

if ((Test-ChefDK) -eq $False) {
  Get-ChefDK
  Install-ChefDK
  rm "chefdk.msi"
}

Get-Cookbooks

if ($RunChef) {
  Invoke-ChefClient
  Write-Host "In the future, you can modify the Policyfile.rb, then run"
  Write-Host "`chef update` and `chef export zero-repo`, then rerun chef client with"
  Write-Host "`chef-client -z` from this directory."
}else {
  Write-Host 'To have this script automatically run Chef with the "pantry::default" recipe, run with -RunChef'
}
