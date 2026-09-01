
#!/bin/bash

echo "======================================"
echo " CyberSOC Lab v2 - Attacker Ready"
echo "======================================"

echo ""
echo "Installed Tools:"
echo "  • Nmap"
echo "  • Gobuster"
echo "  • Hydra"
echo "  • Curl"
echo "  • Netcat"
echo "  • DNS Utils"

echo ""

if [ -d "/opt/SecLists" ]; then
    echo "✅ SecLists mounted successfully."
    echo "📁 /opt/SecLists"
else
    echo "❌ SecLists NOT FOUND."
fi

echo ""
echo "Container IP:"
hostname -I

echo ""
echo "Attacker ready."

tail -f /dev/null