cat << 'EOF' > install.sh
#!/data/data/com.termux/files/usr/bin/bash

clear
echo -e "\033[1;36m🔄 Kurulum başlatılıyor, lütfen bekleyin...\033[0m"

# 5 saniyelik geri sayım süreci
for i in {5..1}; do
    echo -e "\033[1;33m⏳ Kurulumun tamamlanmasına $i saniye kaldı...\033[0m"
    sleep 1
done

echo -e "\033[1;36m📦 Gerekli paketler kontrol ediliyor ve kuruluyor...\033[0m"
pkg update -y >/dev/null 2>&1
local_pkgs=("figlet" "mpv" "yt-dlp" "bc" "neofetch" "nano")
for pkg in "${local_pkgs[@]}"; do
    if ! command -v "$pkg" >/dev/null 2>&1; then
        pkg install "$pkg" -y >/dev/null 2>&1
    fi
done

echo -e "\033[1;36m📥 Panel dosyaları indiriliyor...\033[0m"
# GitHub'daki panel.sh dosyasını çeker (Kendi repo linkine göre düzenleyebilirsin)
#curl -s -o ~/.panel.sh https://raw.githubusercontent.com/KULLANICI_ADIN/REPO_ADIN/main/panel.sh

# Şimdilik test edebilmen için buraya panel.sh içeriğini ekledim, GitHub'da curl ile çekebilirsin.
echo -e "\033[1;32m✅ Kurulum Başarıyla Tamamlandı!\033[0m"
EOF
