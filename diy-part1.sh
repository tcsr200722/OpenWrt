# 文件名: diy-part1.sh
# 描述: OpenWrt DIY script part 1 (放在更新feeds之前)

# 修改feeds源
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
sed -i "s/src-git/src-git-full/g" feeds.conf.default

# 添加feeds源
#echo 'src-git helloworld https://github.com/fw876/helloworld.git' >> feeds.conf.default
