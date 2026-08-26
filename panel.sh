#!/data/data/com.termux/files/usr/bin/bash
# termux-style-older — Hızlı İşlem Paneli (Stabil Sürüm)

# --- GLOBAL DEĞİŞKENLER ---
OLDER_SRM_ACTIVE="true"
OLDER_DVLE_ACTIVE="false"

# Ctrl+C Basıldığında Çökmesini Engelle
trap 'echo -e "\n\033[1;33m[!] İşlem durduruldu, menüye dönülüyor...\033[0m"; sleep 1; banner' SIGINT

# --- YARDIMCI FONKSİYONLAR ---

center_text() {
    local text="$1"
    local width=$(tput cols 2>/dev/null || echo 50)
    local pad=$(( (width - ${#text}) / 2 ))
    [ "$pad" -lt 0 ] && pad=0
    printf "%*s%s\n" "$pad" "" "$text"
}

check_deps() {
    command -v mpv >/dev/null 2>&1 || { echo -e "\033[0;33m[+] mpv kuruluyor...\033[0m"; pkg install mpv -y; }
    command -v yt-dlp >/dev/null 2>&1 || { echo -e "\033[0;33m[+] yt-dlp kuruluyor...\033[0m"; pkg install yt-dlp -y; }
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

# --- İŞLEM MENÜLERİ ---

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

    echo -e "\033[1;36m$(center_text "termux-style-older")\033[0m"

    if [ "$OLDER_SRM_ACTIVE" = "true" ]; then
        echo -e "\033[1;33m$(center_text "Older Paket V1")\033[0m"
    fi

    echo -e "\033[0;35m==================================================\033[0m"
    printf "Devam Etmek İçin Enter A Tıklayın..."
    read -r dummy
    banner
}

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

Older_Banner() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;36m           🔥 OLDER - ÖZEL MENÜ 🔥          \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 🎬 Anime İzle (ani-cli)\033[0m"
    echo -e "\033[0;33m [2] 🔤 Figlet Çalıştır\033[0m"
    echo -e "\033[0;35m [srm] 🔄 Sürüm Aç/Kapat\033[0m"
    echo -e "\033[0;36m [dvle] 🛠️ Geliştirme Sürümü Aç/Kapat\033[0m"
    echo -e "\033[0;31m [0] ❌ Ana Menüye Dön\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    if [ "$OLDER_SRM_ACTIVE" = "true" ]; then
        echo -e "\033[1;32mℹ️  [SÜRÜM BİLGİSİ]: Older-Banner V1 Aktif | Ani-Cli için mpv gerekli.\033[0m"
    fi

    printf "Seçiminiz: "
    read -r ob_secim

    case "$ob_secim" in
        1)
            clear
            command -v ani-cli >/dev/null 2>&1 && ani-cli || echo -e "\033[1;31m⚠️ ani-cli kurulu değil!\033[0m"
            printf "\nDevam Etmek İçin Enter'a Basın..."
            read -r dummy
            Older_Banner
            ;;
        2)
            clear
            if command -v figlet >/dev/null 2>&1; then
                printf "Yazı girin: "
                read -r f_text
                clear
                [ -n "$f_text" ] && figlet "$f_text" || figlet "OLDER"
            else
                echo -e "\033[1;31m⚠️ figlet kurulu değil!\033[0m"
            fi
            printf "\nDevam Etmek İçin Enter'a Basın..."
            read -r dummy
            Older_Banner
            ;;
        srm) toggle_srm; Older_Banner ;;
        dvle) toggle_dvle; Older_Banner ;;
        ob) Older_Banner ;;
        dvl) developer_menu ;;
        0|ana) banner ;;
        *) Older_Banner ;;
    esac
}

developer_menu() {
    clear
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[1;33m          🛠️  GELİŞTİRİCİ SEÇENEKLERİ  🛠️          \033[0m"
    echo -e "\033[0;35m==================================================\033[0m"
    echo -e "\033[0;32m [1] 📦 Older Paket Ekle (Yükleme/Kontrol)\033[0m"
    echo -e "\033[0;36m [2] 🔄 srm (Sürüm Aç/Kapat)\033[0m"
    echo -e "\033[0;36m [3] 🛠️  dvle (Geliştirme Sürümü Aç/Kapat)\033[0m"
    echo -e "\033[0;36m [4] 🎵 Müzik Çalar Komutunu Çalıştır\033[0m"
    echo -e "\033[0;36m [5] 🎨 Older Styling Komutunu Çalıştır\033[0m"
    echo -e "\033[0;36m [6] ℹ️  Sürüm Bilgisi\033[0m"
    echo -e "\033[0;36m [7] ℹ️  Geliştirici Modu Bilgisi (dvle)\033[0m"
    echo -e "\033[0;31m [8] 💥 Herşeyi Sıfırlama (old)\033[0m"
    echo -e "\033[0;34m [9] 📁 Depolama İzni Ver (termux-setup-storage)\033[0m"
    echo -e "\033[0;36m [10] ⚙️ Çalışan Arka Plan Süreçleri (ps aux)\033[0m"
    echo -e "\033[0;32m [11] 🧹 Önbellek ve Önemsiz Dosya Temizliği\033[0m"
    echo -e "\033[1;36m [ob] 🔥 Older-Banner Menüsü\033[0m"
    echo -e "\033[1;32m [ana] ⚙️ Ana Menüye Dön\033[0m"
    echo -e "\033[0;31m [0] ❌ Çıkış\033[0m"
    echo -e "\033[0;35m==================================================\033[0m"

    printf "Seçiminiz: "
    read -r dev_secim

    case "$dev_secim" in
        1) Older ;;
        2|srm) toggle_srm; developer_menu ;;
        3|dvle) toggle_dvle; developer_menu ;;
        4) play_audio ;;
        5) OlderStyling ;;
        6) clear; echo -e "\033[1;32mV1 Sürüm Bilgisi Aktif\033[0m"; read -r dummy; developer_menu ;;
        7) clear; echo -e "\033[1;33mdvl yazarsanız geliştirici menüsü açılır\033[0m"; read -r dummy; developer_menu ;;
        8) reset_termux ;;
        9) termux-setup-storage; developer_menu ;;
        10) clear; ps aux; read -r dummy; developer_menu ;;
        11) pkg clean; apt autoremove -y; sleep 1; developer_menu ;;
        ob) Older_Banner ;;
        dvl) developer_menu ;;
        ana) banner ;;
        0) exit ;;
        *) developer_menu ;;
    esac
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
        srm) toggle_srm; banner ;;
        dvle) toggle_dvle; banner ;;
        ob|Older-Banner) Older_Banner ;;
        dvl) developer_menu ;;
        0) exit ;;
        *) banner ;;
    esac
}

# --- ANA MENÜ DÖNGÜSÜ ---

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

    printf "Seçiminiz: "
    read -r m_sec
    baki "$m_sec"
}

# Parametre Girişi / Başlatma
case "$1" in
    ob|Older-Banner) Older_Banner ;;
    dvl|developer_menu) developer_menu ;;
    dvle) toggle_dvle; banner ;;
    srm) toggle_srm; banner ;;
    *) banner ;;
esac
