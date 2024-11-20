#!/bin/bash

echo "Postfix Installation und Konfiguration starten ..."

# -------------------------------
# 1. Abhängigkeiten installieren
# -------------------------------
echo "Installiere benötigte Pakete ..."
sudo apt update && sudo apt install -y mailutils postfix libsasl2-2 libsasl2-modules ca-certificates

# -------------------------------
# 2. Postfix automatisch konfigurieren
# -------------------------------
echo "Konfiguriere Postfix ..."
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo debconf-set-selections <<< "postfix postfix/mailname string $(hostname)"

# -------------------------------
# 3. Gmail-Anmeldedaten setzen
# -------------------------------
GMAIL_USER="DEINE-EMAIL"  # Hier deine Gmail-Adresse eintragen
GMAIL_PASS="DEIN-APP-PASSWORT"  # Hier das App-spezifische Passwort eintragen

# -------------------------------
# 4. SASL-Datei erstellen und konfigurieren
# -------------------------------
echo "Erstelle und konfiguriere die SASL-Datei ..."
sudo bash -c "cat > /etc/postfix/sasl/sasl_passwd" <<EOF
[smtp.gmail.com]:587 $GMAIL_USER:$GMAIL_PASS
EOF

# Erforderliche Berechtigungen setzen und SASL-Datei in eine Hash-Datei umwandeln
sudo postmap /etc/postfix/sasl/sasl_passwd
sudo chmod 600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db

# -------------------------------
# 5. Postfix-Konfigurationsdatei erstellen
# -------------------------------
echo "Konfiguriere Postfix-Hauptdatei ..."
sudo bash -c "cat > /etc/postfix/main.cf" <<EOF
# Postfix Hauptkonfigurationsdatei
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
smtp_tls_security_level = encrypt
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
EOF

# -------------------------------
# 6. Postfix neu starten
# -------------------------------
echo "Starte Postfix neu ..."
sudo systemctl restart postfix
echo "Postfix erfolgreich installiert und konfiguriert."

# -------------------------------
# 7. Test-E-Mail senden (optional)
# -------------------------------
read -p "Möchten Sie eine Test-E-Mail senden? (y/n): " send_test
if [[ "$send_test" == "y" ]]; then
    read -p "Geben Sie die Empfänger-E-Mail-Adresse ein: " recipient
    echo "Das ist eine Testnachricht von deinem Ubuntu-Server." | mail -s "Test-E-Mail" "$recipient"
    echo "Test-E-Mail gesendet. Überprüfe den Posteingang von $recipient."
fi