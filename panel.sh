#!/data/data/com.termux/files/usr/bin/bash
# panel.sh — Hızlı İşlem Paneli (Termux)

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
    command -v mpv >/dev/null 2>&1 || { echo "mpv kurulu değil, kuruluyor..."; pkg install mpv -y; }
    command -v yt-dlp >/dev/null 2>&1 || { echo "yt-dlp kurulu değil, kuruluyor..."; pkg install yt-dlp -y; }
}

print_controls() {
    echo -e "\033[0;35m--------------------------------------------------\033[0m"
    echo -e "\033[1;36m🎮 Kontroller:\033[0m"
    echo -e "\033[0;32m  [SPACE]      Duraklat / Devam Ettir\033[0m"
    echo -e "\033[0;32m  [← / →]      5sn Geri / İleri Sar\033[0m"
    echo -e "\033[0;32m  [↑ / ↓]      60sn Geri / İleri Sar\033[0m"
    echo -e "\033[0;32m  [9 / 0]      Sesi Azalt / Arttır\033[0m"
    echo -e "\033[0;32m  [m]          Sessize Al / Aç\033[0m"
    echo -e "\033[0;31m  [CTRL + C]   Durdur ve Çık\033[0m"
    echo -e "\033[0;35m--------------------------------------------------\033[0m"
}

mtb() {
    clear
    check_deps
    echo -e "\033[0;32m[+] MTB Şarkısı Başlatılıyor...\033[0m"
    print_controls
    mpv --no-video --quiet --volume=100 --ytdl-format="bestaudio" "https://youtu.be/EUIMyjFB2TM?si=Ao0P3qB09ME6NsU-"
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
}

loli() {
    clear
    check_deps
    echo -e "\033[0;32m[+] Loli Şarkısı Başlatılıyor...\033[0m"
    print_controls
    mpv --no-video --quiet --volume=100 --ytdl-format="bestaudio" "https://youtu.be/T8oeH99JDE4?si=C-xPydhYKnydwSvi"
    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
}

play_audio() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🎵 MÜZİK ÇALAR MENÜSÜ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🎵 MTB (Sabit Şarkı 1)\033[0m"
    echo -e "\033[0;33m [2] 🎵 Loli (Sabit Şarkı 2)\033[0m"
    echo -e "\033[0;36m [3] 🔗 Özel Link Gir (YouTube Linki)\033[0m"
    echo -e "\033[0;35m [0] ↩️  Ana Menüye Dön\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "Seçiminiz [0-3]: "
    read -r m_secim

    case "$m_secim" in
        1) mtb ;;
        2) loli ;;
        3)
            clear
            check_deps
            printf "Çalınacak YouTube Linkini Girin: "
            read -r link
            if [ -n "$link" ]; then
                echo -e "\033[0;32m[+] Bağlantı açılıyor, müzik başlatılıyor...\033[0m"
                print_controls
                mpv --no-video --quiet --volume=100 --ytdl-format="bestaudio" "$link"
            else
                echo -e "\033[0;31m[!] Link girilmedi.\033[0m"
            fi
            printf "\nDevam Etmek İçin Enter A Tıklayın..."
            read -r dummy
            ;;
        0) banner; return ;;
        *) echo -e "\033[0;31mGeçersiz seçim!\033[0m"; sleep 1 ;;
    esac

    banner
}

lsm() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;33m💬 LegacySMS Kuruluyor ve Başlatılıyor...\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    
    pkg update -y && pkg upgrade -y
    pkg install git python -y
    
    if [ ! -d "LegacySMS" ]; then
        git clone https://github.com/s4m3dnotfound/LegacySMS.git
    fi

    cd LegacySMS || return

    if [ -f "install.sh" ]; then
        chmod +x install.sh
        bash install.sh
    elif [ -f "setup.sh" ]; then
        chmod +x setup.sh
        bash setup.sh
    else
        pip install colorama
        [ -f "requirements.txt" ] && pip install -r requirements.txt
    fi

    if [ -f "LegacySMS.py" ]; then
        python LegacySMS.py
    elif [ -f "main.py" ]; then
        python main.py
    fi

    printf "\nDevam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    cd "$HOME" || return
    developer_menu
}

toggle_srm() {
    if [ "$OLDER_SRM_ACTIVE" = "true" ]; then
        OLDER_SRM_ACTIVE="false"
        echo -e "\033[1;31m❌ Older Paket V1 Sürüm Bilgisi Kapatıldı!\033[0m"
    else
        OLDER_SRM_ACTIVE="true"
        echo -e "\033[1;32m✅ Older Paket V1 Sürüm Bilgisi Aktifleşti!\033[0m"
    fi
    sleep 1
    OlderStyling
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
        srm) toggle_srm ;;
        lsm) lsm ;;
        0) exit ;;
        *) banner ;;
    esac
}

alias 1='bash_calc'
alias 2='menu2'
alias 3='menu3'
alias 4='menu4'
alias 5='menu5'
alias 6='menu6'
alias 7='menu7'
alias 8='play_audio'
alias 9='OlderStyling'
alias srm='toggle_srm'
alias lsm='lsm'
alias 0='exit'
alias old='reset_termux'
alias dvl='developer_menu'

reset_termux() {
    clear
    echo -e "\033[1;31m⚠️ Yüklenen paketler ve tüm dosyalar siliniyor...\033[0m"
    pkg uninstall mpv figlet neofetch ani-cli bc yt-dlp python -y 2>/dev/null
    yes | pkg clean >/dev/null 2>&1
    yes | pkg autoremove >/dev/null 2>&1
    rm -rf "$HOME"/* "$HOME"/.[!.]* "$HOME"/..?* 2>/dev/null
    echo -e "\033[1;32m✅ Termux tamamen sıfırlandı. Çıkış yapılıyor...\033[0m"
    exit
}

Older() {
    clear
    local all_installed=true
    command -v figlet >/dev/null 2>&1 || all_installed=false
    command -v neofetch >/dev/null 2>&1 || all_installed=false
    command -v ani-cli >/dev/null 2>&1 || all_installed=false
    command -v python >/dev/null 2>&1 || all_installed=false
    command -v mpv >/dev/null 2>&1 || all_installed=false

    if [ "$all_installed" = true ]; then
        echo -e "\033[1;33m⚠️ Older Paketi Önceden Kurulmuş!\033[0m"
    else
        echo -e "\033[0;33mEksik Older Paketleri Yükleniyor...\033[0m"
        pkg update -y && pkg upgrade -y
        command -v figlet >/dev/null 2>&1 || pkg install figlet -y
        command -v neofetch >/dev/null 2>&1 || pkg install neofetch -y
        command -v ani-cli >/dev/null 2>&1 || pkg install ani-cli -y
        command -v python >/dev/null 2>&1 || pkg install python -y

        echo -e "\033[1;33m🔧 mpv yeniden kuruluyor (kütüphane uyumluluğu için)...\033[0m"
        pkg uninstall mpv -y
        pkg install mpv -y

        hash -r
        echo -e "\033[0;32m✅ Older Paketleri Başarıyla Yüklendi!\033[0m"
        echo -e "\033[1;36m💡 srm yaz bi n'oluyo\033[0m"
    fi
    printf "\nDevam Etmek İçin Enter'a Basın..."
    read -r dummy
    developer_menu
}

developer_menu() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;33m          🛠️  GELİŞTİRİCİ SEÇENEKLERİ  🛠️          \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 📦 Older Paket Ekle (Yükleme/Kontrol)\033[0m"
    echo -e "\033[0;36m [2] 🔄 srm (Sürüm Aç/Kapat)\033[0m"
    echo -e "\033[0;36m [3] 🎵 Müzik Çalar Komutunu Çalıştır\033[0m"
    echo -e "\033[0;36m [4] 🎨 Older Styling Komutunu Çalıştır\033[0m"
    echo -e "\033[0;31m [5] 💥 Herşeyi Sıfırlama (old)\033[0m"
    echo -e "\033[0;34m [6] 📁 Depolama İzni Ver (termux-setup-storage)\033[0m"
    echo -e "\033[0;36m [7] ⚙️  Çalışan Arka Plan Süreçleri (ps aux)\033[0m"
    echo -e "\033[0;32m [8] 🧹 Önbellek ve Önemsiz Dosya Temizliği\033[0m"
    echo -e "\033[0;33m [9] 💬 LegacySMS Çalıştır (lsm)\033[0m"
    echo -e "\033[0;35m [0] ↩️  Ana Menüye Dön\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "Seçiminiz [0-9]: "
    read -r dev_secim

    case "$dev_secim" in
        1) Older ;;
        2) toggle_srm ;;
        3) play_audio ;;
        4) OlderStyling ;;
        5) reset_termux ;;
        6)
            termux-setup-storage
            printf "\nDevam Etmek İçin Enter A Tıklayın..."
            read -r dummy
            developer_menu
            ;;
        7)
            clear
            ps aux
            printf "\nDevam Etmek İçin Enter A Tıklayın..."
            read -r dummy
            developer_menu
            ;;
        8)
            clear
            echo -e "\033[1;33m🧹 Temizlik Yapılıyor...\033[0m"
            pkg clean
            apt autoremove -y
            echo -e "\033[0;32m✅ Önbellek Temizlendi!\033[0m"
            printf "\nDevam Etmek İçin Enter A Tıklayın..."
            read -r dummy
            developer_menu
            ;;
        9) lsm ;;
        0) banner ;;
        *) developer_menu ;;
    esac
}

menu3() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m📁 DİSK & DEPOLAMA BİLGİSİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    df -h "$HOME" | awk 'NR==2 {print " Toplam Alan : " $2 "\n Kullanılan  : " $3 "\n Boş Alan    : " $4 "\n Kullanım %  : " $5}'
    echo -e "\033[0;35m==================================================\033[0m"
    printf "Devam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu4() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🌐 AĞ & IP TESTİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    ifconfig 2>/dev/null | grep 'inet ' | awk '{print " Yerel IP Adresiniz: " $2}'
    echo -e "\033[0;35m==================================================\033[0m"
    printf "Devam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

OlderStyling() {
    clear
    if ! command -v figlet >/dev/null 2>&1; then
        echo -e "\033[0;35m==================================================\033[0m"
        echo -e "\033[1;31m         ⚠️ FİGLET YÜKLÜ DEĞİL!  ⚠️         \033[0m"
        echo -e "\033[0;35m==================================================\033[0m"
        echo -e "\033[1;33m Bu menüyü kullanabilmek için önce Figlet\033[0m"
        echo -e "\033[1;33m yüklemeniz gerekmektedir.\033[0m"
        echo -e "\033[0;35m==================================================\033[0m"
        printf "\nAna menüye dönmek için Enter'a basın..."
        read -r dummy
        banner
        return
    fi

    echo -e "\033[0;35m==================================================\033[0m"
    local width=$(tput cols 2>/dev/null || echo 50)

    while IFS= read -r line; do
        [ -z "$line" ] && continue
        local len=${#line}
        local pad=$(( (width - len) / 2 ))
        [ "$pad" -lt 0 ] && pad=0
        printf "%*s\033[1;32m%s\033[0m\n" "$pad" "" "$line"
    done < <(figlet "OLDER")

    echo -e "\033[1;36m$(center_text "TERMUX STYLİNG")\033[0m"

    if [ "$OLDER_SRM_ACTIVE" = "true" ]; then
        echo -e "\033[1;33m$(center_text "Older Paket V1")\033[0m"
    fi

    echo -e "\033[0;35m==================================================\033[0m"
    printf "Devam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu2() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;33m🔍 Güncellenebilir Paketler Kontrol Ediliyor...\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    apt list --upgradable 2>/dev/null
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;37m[1] Şimdi Hepsini Güncelle (pkg upgrade -y)\033[0m"
    echo -e "\033[1;37m[2] Elle Güncelleme Yapacağım (Ana Menüye Dön)\033[0m"
    echo -e "\033[1;36m[3] Yüklü Paketleri Göster\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "Seçiminiz [1-3]: "
    read -r g_secim

    if [ "$g_secim" = "1" ]; then
        pkg upgrade -y
        banner
    elif [ "$g_secim" = "3" ]; then
        clear
        echo -e "\033[0;35m==================================================\033[0m"
        echo -e "\033[1;36m📦 YÜKLÜ PAKET LİSTESİ\033[0m"
        echo -e "\033[0;35m==================================================\033[0m"

        if command -v figlet >/dev/null 2>&1; then
            echo -e "\033[1;33m[Older Paketi İle Yüklenenler]:\033[0m"
            echo -e "\033[0;32m  [✓] neofetch\033[0m"
            echo -e "\033[0;32m  [✓] figlet\033[0m"
            echo -e "\033[0;32m  [✓] ani-cli\033[0m"
            echo -e "\033[0;32m  [✓] mpv\033[0m"
            echo -e "\033[0;32m  [✓] python\033[0m"
            echo -e "\033[0;35m--------------------------------------------------\033[0m"
        fi

        echo -e "\033[1;33m[Sistemdeki Tüm Yüklü Paketler]:\033[0m"
        apt list --installed 2>/dev/null | cut -d/ -f1 | head -n 30
        echo -e "\033[0;35m==================================================\033[0m"
        printf "Devam Etmek İçin Enter A Tıklayın..."
        read -r dummy
        banner
    else
        banner
    fi
}

menu6() {
    clear
    local current_time=$(date +"%H:%M:%S")
    local current_date=$(date +"%d.%m.%Y")
    local current_day=$(date +"%A")
    local current_gmt=$(date +"%Z / GMT%z")

    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m🕒 SAAT, TARİH & GMT BİLGİSİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e " \033[1;33mAnlık Saat    :\033[0m $current_time"
    echo -e " \033[1;33mBugünün Tarihi :\033[0m $current_date ($current_day)"
    echo -e " \033[1;33mZaman Dilimi   :\033[0m $current_gmt"
    echo -e "\033[0;35m==================================================\033[0m"
    printf "Devam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu7() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m📊 SİSTEM & DONANIM BİLGİSİ\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    command -v yt-dlp >/dev/null 2>&1 || pkg install yt-dlp python -y 2>/dev/null

    if command -v neofetch >/dev/null 2>&1; then
        neofetch
    else
        echo -e "\033[1;33m[Cihaz ve Sistem Özeti]:\033[0m"
        echo -e " İşletim Sistemi : $(uname -o)"
        echo -e " Çekirdek (Kernel): $(uname -r)"
        echo -e " Mimari          : $(uname -m)"
        echo -e " Kullanıcı       : $(whoami)"
        echo -e " Depolama Alanı  : $(df -h "$HOME" | awk 'NR==2 {print "Toplam: " $2 ", Boş: " $4}')"
    fi

    echo -e "\033[0;35m==================================================\033[0m"
    printf "Devam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

menu5() {
    local NOTES="$HOME/notes.txt"
    [ -f "$NOTES" ] || touch "$NOTES"
    if command -v nano >/dev/null 2>&1; then
        nano "$NOTES"
    elif command -v vi >/dev/null 2>&1; then
        vi "$NOTES"
    else
        echo -e "\033[0;31mnano/vi bulunamadı. 'pkg install nano' ile kurabilirsin.\033[0m"
        echo -e "\033[0;36mNot dosyası: $NOTES\033[0m"
    fi
    banner
}
