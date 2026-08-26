cat << 'EOF' > install.sh
#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[1;36m🔄 Kurulum başlatılıyor, lütfen bekleyin...\033[0m"

# 5 saniyelik geri sayım süreci
for i in {5..1}; do
    echo -e "\033[1;33m⏳ Kurulumun tamamlanmasına $i saniye kaldı...\033[0m"
    sleep 1
done

echo -e "\033[1;36m📦 Sistem güncelleniyor (apt update & upgrade)...\033[0m"
apt update -y && apt upgrade -y --allow-downgrades --allow-remove-essential 2>/dev/null

echo -e "\033[1;36m📦 Gerekli paketler kontrol ediliyor ve kuruluyor...\033[0m"
local_pkgs=("figlet" "mpv" "yt-dlp" "bc" "neofetch" "nano")
for pkg in "${local_pkgs[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo -e "\033[1;33m➕ $pkg kuruluyor...\033[0m"
        pkg install "$pkg" -y
    fi
done

echo -e "\033[1;36m📥 Panel dosyaları indiriliyor...\033[0m"
# GitHub'daki panel.sh dosyasını çeker (Kendi repo linkine göre değiştirebilirsin)
curl -s -o ~/.panel.sh https://raw.githubusercontent.com/KULLANICI_ADIN/REPO_ADIN/main/panel.sh

# Bashrc ayarları (Daha önce eklenmediyse ekle)
grep -q "source ~/.panel.sh" ~/.bashrc 2>/dev/null || echo "source ~/.panel.sh" >> ~/.bashrc
grep -q "banner" ~/.bashrc 2>/dev/null || echo "banner" >> ~/.bashrc

echo -e "\033[1;32m✅ Kurulum Başarıyla Tamamlandı!\033[0m"
sleep 1

# Paneli doğrudan başlat
source ~/.panel.sh
banner
EOF
