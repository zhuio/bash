cd /

apt-get update

apt-get upgrade

apt-get -y install python python-dev python-pip python-setuptools python-m2crypto curl wget unzip gcc swig automake make perl cpio build-essential

apt-get install python-pip pip install shadowsocks

# Set shadowsocks config password
    echo "Please input password for shadowsocks-python:"
    read -p "(Default password: zhuio):" shadowsockspwd
    [ -z "${shadowsockspwd}" ] && shadowsockspwd="zhuio"
    echo
    echo "---------------------------"
    echo "password = ${shadowsockspwd}"
    echo "---------------------------"
    echo

    # Set shadowsocks config port
    while true
    do
    echo -e "Please input port for shadowsocks-python [1-65535]:"
    read -p "(Default port: 8989):" shadowsocksport
    [ -z "$shadowsocksport" ] && shadowsocksport="8989"
    expr ${shadowsocksport} + 0 &>/dev/null
    if [ $? -eq 0 ]; then
        if [ ${shadowsocksport} -ge 1 ] && [ ${shadowsocksport} -le 65535 ]; then
            echo
            echo "---------------------------"
            echo "port = ${shadowsocksport}"
            echo "---------------------------"
            echo
            break
        else
            echo "Input error, please input correct number"
        fi
    else
        echo "Input error, please input correct number"
    fi
    done

    echo
    echo "Press any key to start...or Press Ctrl+C to cancel"
    char=`get_char`
    # Config shadowsocks
    config_shadowsocks(){
        cat > /etc/shadowsocks.json<<-EOF
    {
        "server":"0.0.0.0",
        "server_port":${shadowsocksport},
        "local_address":"127.0.0.1",
        "local_port":1080,
        "password":"${shadowsockspwd}",
        "timeout":300,
        "method":"aes-256-cfb",
        "fast_open":false
    }
    EOF
    }
/etc/init.d/shadowsocks start
/etc/init.d/shadowsocks status
