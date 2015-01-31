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
  $LockExists = Test-Path "Berksfile.lock"
  if (-Not $LockExists) {
    Write-Host "Vendoring cookbooks with Berkshelf."
    berks vendor
    if ($LASTEXITCODE -ne 0) {
      Write-Error "Berkshelf failed to vendor required cookbooks!"
      Exit 120
    }
  }
}

function Invoke-ChefClient
{
  Write-Host "Running chef-client with the pantry default recipe."
  chef-client -z -r 'recipe[pantry]'
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
  Write-Host 'Running chef-client with the pantry default recipe.'
  chef-client -z -o 'recipe[pantry]' -c .chef/config.rb
}else {
  Write-Host 'To have this script automatically run Chef with the base role, run with -RunChef'
}
