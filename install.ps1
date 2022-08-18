# Install Python
& "$($PSScriptRoot)\\bin\\python-3.10.5-amd64.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

# Upgrade Python
python -m venv --upgrade "./venv"

# Download pip
curl "https://bootstrap.pypa.io/get-pip.py" -o "$($PSScriptRoot)\\bin\\get-pip.py"

# Install pip
python "$($PSScriptRoot)\\bin\\get-pip.py"

# Install requirements
pip install colorama
pip install O365
pip install pip
pip install pyodbc
pip install setuptools
pip install xmltodict
