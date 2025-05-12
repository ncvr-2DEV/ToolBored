@echo off
powershell -Command "New-Item -Path 'ToolBored-Installer' -ItemType Directory -Force"
powershell -Command "New-Item -Path 'ToolBored-Installer\bin' -ItemType Directory -Force"
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/eiedouno/ToolBored/stable/installer/LICENSE.txt' -OutFile 'ToolBored-Installer\LICENSE.txt'"
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/eiedouno/ToolBored/stable/installer/bin/install.ps1' -OutFile 'ToolBored-Installer\bin\install.ps1'"
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/eiedouno/ToolBored/stable/installer/bin/initiate.ps1' -OutFile 'ToolBored-Installer\bin\initiate.ps1'"
powershell -File "ToolBored-Installer\bin\install.ps1"