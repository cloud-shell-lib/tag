#!/bin/sh
# 这个脚本负责下载和安装的逻辑

# function lib
lib='https://sh.xaox.cc/lib/v3'
# repository name
REPO='tag'
# clint file name
TARGET='cli.sh'
# clint file name
RENAME='tag'
# download version
VERSION=$1
if [ "$VERSION" = "" ];then
	VERSION='main'
fi

on_success() {
	doc_url=https://xaoxuu.com/wiki/cloud-shell/tag/
	printf "\n> \033[32m恭喜您，安装成功！\033[0m 请收藏这个页面，在您遇到问题的时候可以查看文档：\n${doc_url}\n\n"
}

curl -s ${lib}/download.sh | sh -s ${REPO} ${VERSION} ${TARGET} &&
curl -s ${lib}/install.sh | sh -s $HOME/Downloads/${TARGET} ${RENAME} && on_success
