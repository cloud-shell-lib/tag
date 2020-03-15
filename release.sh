#!/bin/bash
# 脚本的文档
DOCS='https://xaoxuu.com/wiki/release.sh/'

# 可选操作 -f: 覆盖推送
PARAM1=$1


function start() {
	# check remote
	url=`sed -n '/\[remote "/,/url = /p' ".git/config"`
	url=${url#*'url = '}
	url=${url%*'/'}
	url=${url%*'.git'}
	if [ "$url" == "" ];then
		printf "> \033[31m%s\033[0m \n" '请在具有remote的git仓库中进行操作！'
		return
	fi

	# 输入版本号
	while :
	do
		if [ "$tag" == "" ];then
			read -p "请输入版本号: " tag
		else
			break
		fi
	done
	# 输入 commit message
	read -p "请输入 commit message: " message
	if [ "$message" == "" ];then
		message="new release"
	fi
  echo $message

	# 拉取最新代码
	printf "\n\n> \033[32m%s\033[0m" 'git pull'
	printf "\n"
	git pull
	# 发布
	printf "\n\n> \033[32m%s\033[0m" 'git add --all'
	printf "\n"
	git add --all

	printf "\n\n> \033[32m%s\033[0m" 'git commit -m'
	printf " \033[35m%s\033[0m" ${message}
	printf "\n"
	git commit -m "${message}"

	printf "\n\n> \033[32m%s\033[0m" 'git push origin'
	printf "\n"
	git push origin

	case $PARAM1 in
		'-f')
		git tag -d ${tag}
		git push origin :${tag}
		;;
		*) ;;
	esac

	printf "\n\n> \033[32m%s\033[0m" 'git tag'
	printf " \033[35m%s\033[0m\n" ${tag}
	git tag ${tag}

	printf "\n\n> \033[32m%s\033[0m" 'git push origin'
	printf " \033[35m%s\033[0m\n" ${tag}
	git push origin ${tag}

	# open url

	url=${url}/releases/tag/${tag}
	printf "\n\n> \033[32m%s\033[0m" 'Congratulations!'
	printf " %s\n\n" ${url}
	open $url

}

case $PARAM1 in
	'docs'|'help') open ${DOCS} ;;
	*) start ;;
esac
