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
        <td>5.x, 6.x, 7.x</td>
    </tr>
</table>

スクリプト
==================

```bash
# cd /usr/local/src/
# curl -L https://raw.github.com/nouphet/setting_server_env/master/setting_server_env_light.sh | bash
```

```bash
yum -y install ntp vim fping wget curl git
wget --no-check-certificate https://raw.github.com/nouphet/setting_server_env/master/setting_server_env_light.sh
```
or
```bash
yum -y install ntp vim fping wget curl git && wget --no-check-certificate https://raw.github.com/nouphet/setting_server_env/master/setting_server_env_light.sh
```


自分用おまけ
==================
グローバルIPを確認する方法

```bash
$ curl http://dyn.value-domain.com/cgi-bin/dyn.fcg?ip
```

Linuxのローカルタイムを日本時間に変更する方法

```bash
# mv /etc/localtime /etc/localtime.orig; ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
or
# mv /etc/localtime /etc/localtime.orig; cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```
