name: Docker VPS mit ngrok Tunnel

on:
  # Erlaubt es dir, die Action manuell per Klick in GitHub zu starten
  workflow_dispatch:

jobs:
  start_vps:
    runs-on: ubuntu-latest

    steps:
    # 1. Code aus dem Repository auschecken
    - name: Code auschecken
      uses: actions/checkout@v4

    # 2. Das Docker-Image (unseren Ubuntu-Server) bauen
    - name: Docker VPS Image bauen
      run: docker build -t meine_vps .

    # 3. Den Docker-Container im Hintergrund starten
    - name: Docker VPS starten
      run: docker run -d -p 2222:22 --name vps_container meine_vps

    # 4. ngrok auf dem GitHub-Runner installieren
    - name: ngrok installieren
      run: |
        curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.dev/ngrok.asc >/dev/null
        echo "deb [signed-by=/etc/apt/trusted.gpg.dev/ngrok.asc] https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
        sudo apt-get update && sudo apt-get install ngrok

    # 5. ngrok authentifizieren und den Tunnel starten
    - name: ngrok Tunnel aktivieren & VPS freigeben
      env:
        NGROK_TOKEN: ${{ secrets.NGROK_AUTHTOKEN }}
      run: |
        # ngrok mit deinem Token konfigurieren
        ngrok config add-authtoken $NGROK_TOKEN
        
        # Tunnel im Hintergrund starten (leitet auf Port 2222 des Runners weiter, wo Docker läuft)
        ngrok tcp 2222 --log=stdout > ngrok.log &
        
        # Kurz warten, bis der Tunnel steht
        sleep 5
        
        # Die öffentliche ngrok-Adresse aus den Logs auslesen und im GitHub-Protokoll anzeigen
        echo "===================================================="
        echo "DEINE VPS IST JETZT ONLINE!"
        echo "Verbinde dich mit folgendem Befehl:"
        curl -s http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"tcp://[^"]*' | sed 's/"public_url":"tcp:\/\///' | awk -F: '{print "ssh vpsadmin@" $1 " -p " $2}'
        echo "Passwort lautet: MeinSicheresPasswort123!"
        echo "===================================================="

    # 6. Den Workflow aktiv halten, damit der Server online bleibt (für max. 6 Stunden)
    - name: Server am Laufen halten
      run: |
        echo "Server läuft. Drücke in GitHub auf 'Cancel run', um ihn zu stoppen."
        # Endlosschleife, die den GitHub-Runner blockiert, damit er nicht ausgeht
        while true; do sleep 60; done
