# Write the Python script to a temporary file
$pythonScript = @"
import json
import subprocess

# Define Brave settings for startup pages
brave_settings = {
    "BraveStartupPages": {
        "Content": "Set Startup Pages",
        "Description": "Sets the browser startup pages.",
        "category": "Startup Tweaks",
        "panel": "1",
        "Order": "s001_",
        "registry": [
            {
                "Path": "HKCU:\\Software\\BraveSoftware\\Brave-Browser\\Preference",
                "Name": "startup_urls",
                "Type": "MultiString",
                "Value": [
                    "https://app.trading212.com/",
                    "https://www.youtube.com/",
                    "https://www.twitch.tv/",
                    "http://amazon.co.uk/"
                ],
                "OriginalValue": []
            }
        ],
        "InvokeScript": [
            "Set-ItemProperty -Path 'HKCU:\\Software\\BraveSoftware\\Brave-Browser\\Preference' -Name 'startup_urls' -Value 'https://app.trading212.com/','https://www.youtube.com/','https://www.twitch.tv/','http://amazon.co.uk/'"
        ],
        "UndoScript": [
            "Remove-ItemProperty -Path 'HKCU:\\Software\\BraveSoftware\\Brave-Browser\\Preference' -Name 'startup_urls'"
        ],
        "link": "https://brave.com/"
    }
}

# Extension IDs (from Chrome Web Store)
extensions = {
    "BetterTTV": "ajopnjidmegmdimjlfnijceegpefgped",
    "Bitwarden Password Manager": "nngceckbapebfimnlniiiahkandclblb",
    "DarkMode - Night Eye": "pnifibmhobonkjbgandfngjokmielkbh",
    "Grammarly": "kbfnbcaeplbcioakkpcpgfkobkghlhen",
    "Quidco": "lmhkpmbekcpmknklioeibfkpmmfibljd"
}

def install_brave_extension(extension_id):
    subprocess.run(["brave", "--install-extension", extension_id], check=True)

def create_brave_config(settings_data):
    for name, details in settings_data.items():
        config = {
            "Content": details["Content"],
            "Description": details["Description"],
            "category": details["category"],
            "panel": details["panel"],
            "Order": details["Order"],
            "registry": details["registry"],
            "InvokeScript": details["InvokeScript"],
            "UndoScript": details["UndoScript"],
            "link": details["link"]
        }
        with open(f"{name}_config.json", "w") as f:
            json.dump(config, f, indent=4)
        print(f"Config file for {name} created.")

def install_extensions(extensions_data):
    for ext_name, ext_id in extensions_data.items():
        install_brave_extension(ext_id)
        print(f"Installed extension: {ext_name}")

# Run configuration and install extensions
create_brave_config(brave_settings)
install_extensions(extensions)
"@

$tempFilePath = [System.IO.Path]::GetTempFileName() + ".py"
Set-Content -Path $tempFilePath -Value $pythonScript

# Execute the Python script
python $tempFilePath

# Remove the temporary file
Remove-Item $tempFilePath
