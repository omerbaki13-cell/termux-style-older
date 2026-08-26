#!/data/data/com.termux/files/usr/bin/bash
# panel.sh — Tüm Özellikler + Özel Older-Banner

center_text() {
    local text="$1"
    local width=$(tput cols 2>/dev/null || echo 50)
    local pad=$(( (width - ${#text}) / 2 ))
    [ "$pad" -lt 0 ] && pad=0
    printf "%*s%s\n" "$pad" "" "$text"
}

banner() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;37m           ⚙️  HIZLI İŞLEM PANELİ  ⚙️          \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🧮 Hesap Makinesi (Saf Bash)\033[0m"
    echo -e "\033[0;33m [2] 🔄 Paket Güncelleme & Paket Listesi\033[0m"
    echo -e "\033[0;34m [3] 📁 Disk & Storage\033[0m"
    echo -e "\033[0;36m [4] 🌐 Ağ & IP Testi\033[0m"
    echo -e "\033[0;33m [5] 📝 Not Defteri\033[0m"
    echo -e "\033[0;36m [6] 🕒 Saat, Tarih & GMT Bilgisi\033[0m"
    echo -e "\033[0;34m [7] 📊 Sistem & Donanım Bilgisi\033[0m"
    echo -e "\033[0;33m [8] 🎵 Müzik Çalar\033[0m"
    echo -e "\033[0;32m [9] 🎨 Older Styling\033[0m"
    echo -e "\033[0;31m [0] ❌ Çıkış\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "Seçiminiz [0-9]: "
    read -r m_sec
    baki "$m_sec"
}

Older_Banner() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m           🔥 OLDER - ÖZEL MENÜ 🔥          \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🎬 Anime İzle (ani-cli)\033[0m"
    echo -e "\033[0;33m [2] 🔤 Figlet Çalıştır\033[0m"
    echo -e "\033[0;35m [srm] 🔄 Sürüm Aç/Kapat\033[0m"
    echo -e "\033[0;31m [0] ❌ Ana Menüye Dön\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "Older-Banner Seçiminiz [1/2/srm/0]: "
    read -r ob_secim

    case "$ob_secim" in
        1)
            clear
            if command -v ani-cli >/dev/null 2>&1; then
                ani-cli
            else
                echo -e "\033[1;31m⚠️ ani-cli kurulu değil!\033[0m"
            fi
            printf "\nDevam Etmek İçin Enter A Tıklayın..."
            read -r dummy
            Older_Banner
            ;;
        2)
            clear
            if command -v figlet >/dev/null 2>&1; then
                printf "Figlet için bir kelime/metin girin: "
                read -r f_text
                clear
                [ -n "$f_text" ] && figlet "$f_text" || figlet "OLDER"
            else
                echo -e "\033[1;31m⚠️ figlet kurulu değil!\033[0m"
            fi
            printf "\nDevam Etmek İçin Enter A Tıklayın..."
            read -r dummy
            Older_Banner
            ;;
        srm)
            toggle_srm
            Older_Banner
            ;;
        0) banner ;;
        *) Older_Banner ;;
    esac
}

bash_calc() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🧮 HESAP MAKİNESİ (Saf Bash)\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    printf "İşleminizi Girin (Örn: 5+5 veya 10*2): "
    read -r expr
    if [ -n "$expr" ]; then
        local result
        result=$(echo "scale=2; $expr" | bc 2>/dev/null || awk "BEGIN {print $expr}")
        echo -e "\033[1;32mSonuç: $result\033[0m"
    else
        echo -e "\033[0;31mİşlem girilmedi.\033[0m"
    fi
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

check_deps() {
    command -v mpv >/dev/null 2>&1 || pkg install mpv -y
    command -v yt-dlp >/dev/null 2>&1 || pkg install yt-dlp -y
}

play_audio() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🎵 MÜZİK ÇALAR MENÜSÜ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🎵 MTB\033[0m"
    echo -e "\033[0;33m [2] 🎵 Loli\033[0m"
    echo -e "\033[0;36m [3] 🔗 Özel Link Gir\033[0m"
    echo -e "\033[0;35m [0] ↩️  Ana Menüye Dön\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "Seçiminiz [0-3]: "
    read -r m_secim

    case "$m_secim" in
        1)
            clear
            check_deps
            mpv --no-video --quiet --volume=100 "https://youtu.be/EUIMyjFB2TM?si=Ao0P3qB09ME6NsU-"
            banner
            ;;
        2)
            clear
            check_deps
            mpv --no-video --quiet --volume=100 "https://youtu.be/T8oeH99JDE4?si=C-xPydhYKnydwSvi"
            banner
            ;;
        3)
            clear
            check_deps
            printf "YouTube Linki Girin: "
            read -r link
            [ -n "$link" ] && mpv --no-video --quiet --volume=100 "$link"
            banner
            ;;
        0) banner ;;
        *) play_audio ;;
    esac
}

toggle_srm() {
    if [ "$OLDER_SRM_ACTIVE" = "true" ]; then
        OLDER_SRM_ACTIVE="false"
        echo -e "\033[1;31m❌ Sürüm Bilgisi Kapatıldı!\033[0m"
    else
        OLDER_SRM_ACTIVE="true"
        echo -e "\033[1;32m✅ Sürüm Bilgisi Aktifleşti!\033[0m"
    fi
    sleep 1
}

toggle_dvle() {
    if [ "$OLDER_DVLE_ACTIVE" = "true" ]; then
        OLDER_DVLE_ACTIVE="false"
        echo -e "\033[1;31m❌ Geliştirme Sürümü Kapatıldı!\033[0m"
    else
        OLDER_DVLE_ACTIVE="true"
        echo -e "\033[1;32m✅ Geliştirme Sürümü Aktifleşti!\033[0m"
    fi
    sleep 1
}

baki() {
    case "$1" in
        1) bash_calc ;;
        2) menu2 ;;
        3) menu3 ;;
        4) menu4 ;;
        5) menu5 ;;
        6) menu6 ;;
        7) menu7 ;;
        8) play_audio ;;
        9) OlderStyling ;;
        0) exit ;;
        *) banner ;;
    esac
}

menu2() {
    clear
    apt list --upgradable 2>/dev/null
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu3() {
    clear
    df -h "$HOME"
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu4() {
    clear
    ifconfig 2>/dev/null | grep 'inet '
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu5() {
    local NOTES="$HOME/notes.txt"
    [ -f "$NOTES" ] || touch "$NOTES"
    nano "$NOTES" 2>/dev/null || vi "$NOTES"
    banner
}

menu6() {
    clear
    date
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu7() {
    clear
    neofetch 2>/dev/null || uname -a
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

OlderStyling() {
    clear
    figlet "OLDER" 2>/dev/null
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

Older() {
    clear
    echo -e "\033[0;33mEksik Older Paketleri Yükleniyor...\033[0m"
    pkg install figlet neofetch ani-cli python mpv bc -y
    echo -e "\033[0;32m✅ Older Paketleri Başarıyla Yüklendi!\033[0m"
    echo -e "\033[1;36m💡 srm yaz bi n'oluyo | Older-Banner yaz ne oluyo\033[0m"
    sleep 2
    Older_Banner
}

developer_menu() {
    clear
    echo -e "\033[1;33m🛠️ GELİŞTİRİCİ MENÜSÜ (dvl)\033[0m"
    echo -e "[1] Older Paket Kur\n[2] srm Değiştir\n[3] dvle Değiştir\n[0] Ana Menü"
    printf "Seçim: "
    read -r d_sec
    case "$d_sec" in
        1) Older ;;
        2) toggle_srm; developer_menu ;;
        3) toggle_dvle; developer_menu ;;
        *) banner ;;
    esac
}

alias older-banner='Older_Banner'
alias Older-Banner='Older_Banner'
alias dvl='developer_menu'
alias srm='toggle_srm'

banner
