# 文件名: diy-part2.sh
# 描述: OpenWrt DIY script part 2 (放在安装feeds之后)

# 修改管理地址
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate

# 强制切换内核版本
sed -i "s/KERNEL_PATCHVER:=*.*/KERNEL_PATCHVER:=5.10/g" target/linux/x86/Makefile
sed -i "s/KERNEL_TESTING_PATCHVER:=*.*/KERNEL_TESTING_PATCHVER:=5.10/g" target/linux/x86/Makefile

# 交换LAN/WAN口
sed -i 's/"eth1 eth2" "eth0"/"eth1 eth2" "eth0"/g' target/linux/x86/base-files/etc/board.d/02_network
sed -i "s/'eth1 eth2' 'eth0'/'eth1 eth2' 'eth0'/g" target/linux/x86/base-files/etc/board.d/02_network
sed -i "s/lan 'eth0'/lan 'eth0'/g" package/base-files/files/etc/board.d/99-default_network
sed -i "s/wan 'eth1'/wan 'eth1'/g" package/base-files/files/etc/board.d/99-default_network
sed -i "s/net\/eth1/net\/eth1/g" package/base-files/files/etc/board.d/99-default_network

# 修改默认皮肤
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci-nginx/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon-mod/g' feeds/luci/collections/luci-ssl-nginx/Makefile

# 修改主机名以及一些显示信息
sed -i "s/hostname='*.*'/hostname='OpenWrt'/" package/base-files/files/bin/config_generate
sed -i "s/DISTRIB_ID='*.*'/DISTRIB_ID='OpenWrt'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt'/g"  package/base-files/files/etc/openwrt_release
sed -i '/(<%=pcdata(ver.luciversion)%>)/a\      built by ywt114' package/lean/autocore/files/x86/index.htm
echo -n "$(date +'%Y%m%d')" > package/base-files/files/etc/openwrt_version

# 修改部分默认设置
sed -i "/exit 0/i sed -i '\/oui\/d' \/etc\/opkg\/distfeeds.conf" package/lean/default-settings/files/zzz-default-settings
sed -i "s/option check_signature/# option check_signature/g" package/system/opkg/Makefile
# echo "src/gz openwrt_kiddin9 https://op.supes.top/packages/x86_64" >> package/system/opkg/files/customfeeds.conf
echo "src/gz openwrt_kenzok8 https://op.dllkids.xyz/packages/x86_64" >> package/system/opkg/files/customfeeds.conf
sed -i "s/mirrors.cloud.tencent.com\/lede/mirrors.cloud.tencent.com\/openwrt/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i 's\/root::0:0:99999:7:::/# sed -i 's\/root::0:0:99999:7:::/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i 's\/root:::0:99999:7:::/# sed -i 's\/root:::0:99999:7:::/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/sed -i '\/REDIRECT --to-ports/# sed -i '\/REDIRECT --to-ports/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/echo 'iptables -t/echo '# iptables -t/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/echo '\[ -n/echo '# \[ -n/g" package/lean/default-settings/files/zzz-default-settings

# 开启wifi选项
sed -i 's/disabled=*.*/disabled=0/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i 's/ssid=*.*/ssid=OpenWrt/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 添加关机按钮到系统选项
curl -fsSL https://raw.githubusercontent.com/ywt114/poweroff/main/poweroff.htm > feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_system/poweroff.htm
curl -fsSL https://raw.githubusercontent.com/ywt114/poweroff/main/system.lua > feeds/luci/modules/luci-mod-admin-full/luasrc/controller/admin/system.lua

# 删除替换默认源插件和添加插件
\rm -rf feeds/packages/lang/golang
git clone -b 20.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
git clone https://github.com/sbwml/luci-app-alist package/lean/op-alist
\cp -rf package/lean/op-alist/alist package/lean/alist
\cp -rf package/lean/op-alist/luci-app-alist package/lean/luci-app-alist
\rm -rf package/lean/op-alist
\rm -rf feeds/luci/applications/luci-app-adbyby-plus
git clone https://github.com/ywt114/luci-app-adbyby-plus-lite package/lean/luci-app-adbyby-plus-lite
git clone https://github.com/ywt114/luci-app-gpsysupgrade package/lean/luci-app-gpsysupgrade
# \rm -rf feeds/packages/net/smartdns
# \rm -rf feeds/luci/applications/luci-app-smartdns
# git clone https://github.com/pymumu/openwrt-smartdns feeds/packages/net/smartdns
# git clone -b lede https://github.com/pymumu/luci-app-smartdns package/lean/luci-app-smartdns
git clone https://github.com/kenzok8/small package/lean/small
\rm -rf package/lean/small/luci-app-bypass
\rm -rf package/lean/small/luci-app-vssr
\rm -rf package/lean/small/luci-app-passwall2
\rm -rf feeds/packages/net/adguardhome
\rm -rf feeds/luci/applications/luci-app-adguardhome
# \rm -rf feeds/packages/net/mosdns
# \rm -rf feeds/luci/applications/luci-app-mosdns
# \rm -rf feeds/packages/utils/v2dat
git clone https://github.com/kenzok8/openwrt-packages package/lean/openwrt-packages
\cp -rf package/lean/openwrt-packages/luci-app-openclash package/lean/small/luci-app-openclash
\cp -rf package/lean/openwrt-packages/adguardhome feeds/packages/net/adguardhome
\cp -rf package/lean/openwrt-packages/luci-app-adguardhome package/lean/luci-app-adguardhome
# \cp -rf package/lean/openwrt-packages/mosdns feeds/packages/net/mosdns
# \cp -rf package/lean/openwrt-packages/luci-app-mosdns package/lean/luci-app-mosdns
# \cp -rf package/lean/openwrt-packages/v2dat feeds/packages/utils/v2dat
\rm -rf package/lean/openwrt-packages
# \rm -rf feeds/packages/net/socat
# \rm -rf feeds/luci/applications/luci-app-socat
git clone https://github.com/xiangfeidexiaohuo/openwrt-packages package/lean/openwrt-packages
# \cp -rf package/lean/openwrt-packages/op-socat/socat feeds/packages/net/socat
# \cp -rf package/lean/openwrt-packages/op-socat/luci-app-socat package/lean/luci-app-socat
\cp -rf package/lean/openwrt-packages/op-homebox/homebox package/lean/homebox
\cp -rf package/lean/openwrt-packages/op-homebox/luci-app-homebox package/lean/luci-app-homebox
\rm -rf package/lean/openwrt-packages
git clone https://github.com/sirpdboy/chatgpt-web package/lean/luci-app-chatgpt
git clone https://github.com/sirpdboy/luci-app-autotimeset package/lean/luci-app-autotimeset
sed -i 's/control"/system"/g' package/lean/luci-app-autotimeset/luasrc/controller/autotimeset.lua
sed -i 's/control]/system]/g' package/lean/luci-app-autotimeset/luasrc/view/autotimeset/log.htm
git clone https://github.com/linkease/istore package/lean/istore
# sed -i 's/+luci-lib-ipkg/+luci-base/g' package/lean/istore/luci/luci-app-store/Makefile
\cp -rf package/lean/istore/luci/* package/lean
\cp -rf package/lean/istore/translations package/lean
\rm -rf package/lean/istore
git clone https://github.com/linkease/nas-packages-luci package/lean/nas-packages-luci
\cp -rf package/lean/nas-packages-luci/luci/* package/lean
\rm -rf package/lean/nas-packages-luci
git clone https://github.com/linkease/nas-packages package/lean/nas-packages
\cp -rf package/lean/nas-packages/network/services/* package/network/services
\cp -rf package/lean/nas-packages/multimedia package
\rm -rf package/lean/nas-packages
git clone https://github.com/sirpdboy/luci-app-advanced package/lean/luci-app-advanced
sed -i 's/Variable1 = "*.*"/Variable1 = "ywt114"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable2 = "*.*"/Variable2 = "OpenWrt"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable3 = "*.*"/Variable3 = "x86_64_5.10"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable4 = "*.*"/Variable4 = "5.10"/g' package/lean/luci-app-gpsysupgrade/luasrc/model/cbi/gpsysupgrade/sysupgrade.lua
sed -i 's/Variable1 = "*.*"/Variable1 = "ywt114"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable2 = "*.*"/Variable2 = "OpenWrt"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable3 = "*.*"/Variable3 = "x86_64_5.10"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
sed -i 's/Variable4 = "*.*"/Variable4 = "5.10"/g' package/lean/luci-app-gpsysupgrade/root/usr/bin/upgrade.lua
