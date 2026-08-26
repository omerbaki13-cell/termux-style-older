#!/data/data/com.termux/files/usr/bin/bash
# termux-style-older — Ana Panel Betiği

OLDER_SRM_ACTIVE="true"
OLDER_DVLE_ACTIVE="false"

trap 'echo -e "\n\033[1;33m[!] İşlem durduruldu, menüye dönülüyor...\033[0m"; sleep 1; banner' SIGINT

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

    read -r m_sec
    case "$m_sec" in
        ob|Older-Banner) Older_Banner ;;
        dvl) developer_menu ;;
        dvle) toggle_dvle; banner ;;
        srm) toggle_srm; banner ;;
        *) baki "$m_sec" ;;
    esac
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

    read -r ob_secim

    case "$ob_secim" in
        1)
            clear
            command -v ani-cli >/dev/null 2>&1 && ani-cli || echo -e "\033[1;31m⚠️ ani-cli kurulu değil!\033[0m"
            read -r dummy
            Older_Banner
            ;;
        2)
            clear
            if command -v figlet >/dev/null 2>&1; then
                read -r f_text
                clear
                [ -n "$f_text" ] && figlet "$f_text" || figlet "OLDER"
            else
                echo -e "\033[1;31m⚠️ figlet kurulu değil!\033[0m"
            fi
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

    read -r dev_secim

    case "$dev_secim" in
        1) pkg install figlet neofetch ani-cli python mpv bc -y; developer_menu ;;
        2|srm) toggle_srm; developer_menu ;;
        3|dvle) toggle_dvle; developer_menu ;;
        4) play_audio ;;
        5) OlderStyling ;;
        6) clear; echo -e "\033[1;32mV1 Sürüm Bilgisi Aktif\033[0m"; read -r dummy; developer_menu ;;
        7) clear; echo -e "\033[1;33mdvl yazarsanız geliştirici menüsü açılır\033[0m"; read -r dummy; developer_menu ;;
        8) rm -rf "$HOME"/* 2>/dev/null; exit ;;
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

play_audio() {
    clear
    command -v mpv >/dev/null 2>&1 || pkg install mpv -y
    printf "Link Girin: "
    read -r link
    [ -n "$link" ] && mpv --no-video "$link" || mpv --no-video "https://youtu.be/EUIMyjFB2TM?si=Ao0P3qB09ME6NsU-"
    banner
}

baki() {
    case "$1" in
        1) clear; read -r expr && echo "Sonuç: $(echo "scale=2; $expr" | bc 2>/dev/null)" && read -r dummy; banner ;;
        2) clear; apt list --upgradable 2>/dev/null; read -r dummy; banner ;;
        3) clear; df -h "$HOME"; read -r dummy; banner ;;
        4) clear; ifconfig 2>/dev/null | grep 'inet '; read -r dummy; banner ;;
        5) nano "$HOME/notes.txt" 2>/dev/null; banner ;;
        6) clear; date; read -r dummy; banner ;;
        7) clear; neofetch 2>/dev/null || uname -a; read -r dummy; banner ;;
        8) play_audio ;;
        9) clear; figlet "OLDER"; read -r dummy; banner ;;
        0) exit ;;
        *) banner ;;
    esac
}

case "$1" in
    ob|Older-Banner) Older_Banner ;;
    dvl|developer_menu) developer_menu ;;
    dvle) toggle_dvle ;;
    srm) toggle_srm ;;
    *) banner ;;
esac
