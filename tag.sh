#!/bin/bash
# 脚本的文档
DOCS='https://xaoxuu.com/wiki/tag.sh/'

# release 1.0 msg   -- push 1.0
# release d 1.0     -- delete 1.0

P1=$1
P2=$2


function add() {
	tag=$1
	msg=$2
	if [ "$tag" == "" ];then
		echo '请输入「tag 版本号 描述」来发布版本:'
		return
	fi
	if [ "$msg" == "" ];then
		msg="new release"
	fi

	# 拉取最新代码
	printf "\n\n> \033[32m%s\033[0m" 'git pull'
	printf "\n"
	git pull
	# 发布
	printf "\n\n> \033[32m%s\033[0m" 'git add --all'
	printf "\n"
	git add --all

	printf "\n\n> \033[32m%s\033[0m" 'git commit -m'
	printf " \033[35m%s\033[0m" ${msg}
	printf "\n"
	git commit -m "${msg}"

	printf "\n\n> \033[32m%s\033[0m" 'git push origin'
	printf "\n"
	git push origin

	printf "\n\n> \033[32m%s\033[0m" 'git tag'
	printf " \033[35m%s\033[0m\n" ${tag}
	git tag ${tag}

	printf "\n\n> \033[32m%s\033[0m" 'git push origin'
	printf " \033[35m%s\033[0m\n" ${tag}
	git push origin ${tag}

	# done
	printf "\n\n> \033[32m%s\033[0m\n" 'Congratulations!'

}

function del() {
	tag=$1
	if [ "$tag" == "" ];then
		echo '请输入「tag del 版本号」来删除指定版本:'
		return
	fi
	git tag -d ${tag}
	git push origin :${tag}
}

function check() {
	tag=''
	msg=''
	case $P1 in
		'')
			read -p "请输入 tag version: " tag
		;;
		'-d'|'del')
			case $P2 in
				'') ;;
				*) tag=$P2 ;;
			esac
			del $tag
			return
		;;
		*) tag=$P1 ;;
	esac
	case $P2 in
		'')
			read -p "请输入 commit message: " msg
		;;
		*) msg=$P2 ;;
	esac
	add $tag $msg
}

case $P1 in
	'docs'|'help') open ${DOCS} ;;
	*) check ;;
esac
