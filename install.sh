#!/data/data/com.termux/files/usr/bin/bash
# install.sh — termux-style-older Kurulum Scripti

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL_SRC="$REPO_DIR/panel.sh"
PANEL_DEST="$HOME/.panel.sh"
BASHRC="$HOME/.bashrc"
MARKER="# >>> termux-style-older >>>"

echo -e "\033[1;36m📦 Bağımlılıklar kontrol ediliyor ve güncelleniyor...\033[0m"
pkg update -y && pkg upgrade -y

echo -e "\033[1;33m⏳ Gerekli temel paketler kuruluyor...\033[0m"

# Temel bağımlılık kontrolü ve toplu kurulum
NEEDED_PKGS=()
command -v figlet >/dev/null 2>&1 || NEEDED_PKGS+=(figlet)
command -v mpv >/dev/null 2>&1 || NEEDED_PKGS+=(mpv)
command -v yt-dlp >/dev/null 2>&1 || NEEDED_PKGS+=(yt-dlp)
command -v bc >/dev/null 2>&1 || NEEDED_PKGS+=(bc)
command -v neofetch >/dev/null 2>&1 || NEEDED_PKGS+=(neofetch)

if [ ${#NEEDED_PKGS[@]} -gt 0 ]; then
    echo -e "\033[0;32m[+] Eksik paketler yükleniyor: ${NEEDED_PKGS[*]}\033[0m"
    pkg install "${NEEDED_PKGS[@]}" -y
fi

echo -e "\033[1;32m✅ Bağımlılıklar hazır.\033[0m"

echo -e "\033[1;36m📦 Panel dosyaları kopyalanıyor...\033[0m"

if [ ! -f "$PANEL_SRC" ]; then
    echo -e "\033[1;31m❌ panel.sh bulunamadı: $PANEL_SRC\033[0m"
    exit 1
fi

cp "$PANEL_SRC" "$PANEL_DEST"
chmod +x "$PANEL_DEST"

touch "$BASHRC"

if ! grep -q "$MARKER" "$BASHRC" 2>/dev/null; then
    {
        echo ""
        echo "$MARKER"
        echo "source \"\$HOME/.panel.sh\""
        echo "# <<< termux-style-older <<<"
    } >> "$BASHRC"
    echo -e "\033[1;32m✅ .bashrc güncellendi.\033[0m"
else
    echo -e "\033[1;33mℹ️ .bashrc zaten yapılandırılmış, tekrar eklenmedi.\033[0m"
fi

echo ""
echo -e "\033[1;32m🎉 Kurulum tamamlandı!\033[0m"
echo -e "\033[1;36mPaneli hemen başlatmak için aşağıdaki komutu çalıştırabilirsin:\033[0m"
echo -e "\033[1;33msource ~/.bashrc && banner\033[0m"
