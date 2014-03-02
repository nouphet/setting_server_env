setting_server_env
==================

Common Settings for My Server

対象サーバ
==================
<table>
    <tr>
        <td>OS</td>
        <td>Version</td>
    </tr>
    <tr>
        <td>CentOS</td>
        <td>5, 6</td>
    </tr>
</table>

スクリプト
==================

```bash
# cd /usr/local/src/
# curl -L https://raw.github.com/nouphet/setting_server_env/master/setting_server_env.sh | bash
```

```bash
yum -y install ntp vim fping wget curl git
wget --no-check-certificate https://raw.github.com/nouphet/setting_server_env/master/setting_server_env.sh
```

自分用おまけ
==================
グローバルIPを確認する方法

```bash
$ curl http://dyn.value-domain.com/cgi-bin/dyn.fcg?ip
```

Linuxのローカルタイムを日本時間に変更する方法

```bash
# cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```
