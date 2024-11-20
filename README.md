# Postfix-Mail-Installer
Automated script to install and configure Postfix on Ubuntu for sending emails via Gmail. It simplifies the setup process for Postfix and ensures quick and error-free configuration.

# Postfix-Mail-Installer

This project provides a Bash script to automate the installation and configuration of Postfix on an Ubuntu server. The script is designed to send emails using Gmail's SMTP service.

## Features
- Automatically installs required dependencies (Postfix, mailutils, etc.).
- Configures Postfix for Gmail with minimal input.
- Includes the ability to send a test email after setup.

## Prerequisites
- An Ubuntu system with `sudo` access.
- A Gmail account with [App Passwords](https://support.google.com/accounts/answer/185833?hl=en) enabled.

## Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/timoelan/Postfix-Mail-Installer.git
   cd Postfix-Mail-Installer

2. Make the script executable:
   ```bash
   chmod +x postfixInstaller.sh

3. Run Script
   ```bash
   ./postfixInstaller.sh

4. During the setup, follow the prompts:
-	Enter your Gmail address.
-	Enter your Gmail App Password (not your regular Gmail password).
5.	Test the email functionality:
-	After setup, you’ll be asked if you want to send a test email. Type y to confirm.
-	Provide the recipient email address for the test email.
6.	Verify the email has been sent:
- Check your Gmail account’s sent folder.
- If you don’t see the email, review the logs:
   ```bash
   sudo tail -f /var/log/mail.log
7.	(Optional) Send additional emails manually:
   ```bash
  echo "Your message" | mail -s "Subject" -a FROM:<your-email-address> recipient@example.com
