#!/data/data/com.termux/files/usr/bin/bash
# install.sh — Hızlı İşlem Paneli kurulum scripti

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL_SRC="$REPO_DIR/panel.sh"
PANEL_DEST="$HOME/.panel.sh"
BASHRC="$HOME/.bashrc"
MARKER="# >>> hizli-islem-paneli >>>"

echo "📦 Bağımlılıklar kontrol ediliyor / kuruluyor..."
apt update -y
apt upgrade -y

if ! command -v figlet >/dev/null 2>&1 || ! command -v mpv >/dev/null 2>&1 || ! command -v yt-dlp >/dev/null 2>&1; then
    echo -e "\033[1;33m⏳ Styling İçin Gereken Paketler Yükleniyor... Tahmini Bekleme: 5 Dakika\033[0m"
    sleep 3
fi

command -v figlet >/dev/null 2>&1 || { echo "🔤 figlet kuruluyor..."; pkg install figlet -y; }
command -v mpv >/dev/null 2>&1 || { echo "🎵 mpv kuruluyor..."; pkg install mpv -y; }
command -v yt-dlp >/dev/null 2>&1 || { echo "🔗 yt-dlp kuruluyor..."; pkg install yt-dlp -y; }

echo "✅ Bağımlılıklar hazır."

echo "📦 Panel kuruluyor..."

if [ ! -f "$PANEL_SRC" ]; then
    echo "❌ panel.sh bulunamadı: $PANEL_SRC"
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
        echo "banner"
        echo "# <<< hizli-islem-paneli <<<"
    } >> "$BASHRC"
    echo "✅ .bashrc güncellendi."
else
    echo "ℹ️ .bashrc zaten kurulu, tekrar eklenmedi."
fi

echo ""
echo "✅ Kurulum tamamlandı! Yeni terminal aç ya da şunu çalıştır:"
echo "   source ~/.bashrc"
