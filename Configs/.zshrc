# Đường dẫn cài đặt Oh-my-zsh
ZSH=/usr/share/oh-my-zsh/

# Đường dẫn theme Powerlevel10k
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Danh sách plugin được sử dụng
plugins=()
source $ZSH/oh-my-zsh.sh

# Khi một lệnh không được tìm thấy, cố gắng tìm gói chứa lệnh đó
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: không tìm thấy lệnh: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} có thể được tìm thấy trong các gói sau:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Phát hiện công cụ hỗ trợ AUR
if pacman -Qi yay &>/dev/null; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null; then
   aurhelper="paru"
fi

# Hàm cài đặt gói
function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# Các alias hữu ích
alias update='sudo pacman -Syu'
alias updatea='sudo pacman -Syu && yay -Syu'
alias ff='clear && fastfetch'
alias c='clear' # xóa màn hình terminal
alias l='eza -lh --icons=auto' # danh sách chi tiết
alias ls='eza -1 --icons=auto' # danh sách ngắn
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # danh sách tất cả chi tiết
alias ld='eza -lhD --icons=auto' # danh sách chi tiết thư mục
alias lt='eza --icons=auto --tree' # hiển thị thư mục dạng cây
alias un='$aurhelper -Rns' # gỡ bỏ gói
alias up='$aurhelper -Syu' # cập nhật hệ thống/gói/AUR
alias pl='$aurhelper -Qs' # danh sách các gói đã cài
alias pa='$aurhelper -Ss' # danh sách các gói có sẵn
alias pc='$aurhelper -Sc' # xóa bộ nhớ cache không dùng
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # xóa các gói không sử dụng
alias vc='code' # mở trình chỉnh sửa mã giao diện

# Các lệnh điều hướng thư mục
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'

# Luôn tạo thư mục theo đường dẫn (không ảnh hưởng chức năng tạo một thư mục duy nhất)
alias mkdir='mkdir -p'

# Để tùy chỉnh prompt, chạy `p10k configure` hoặc chỉnh sửa ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Hiển thị Pokemon
pokemon-colorscripts --no-title -r 1,3,6
