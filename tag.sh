#!/bin/sh
# 脚本的文档
DOCS='https://xaoxuu.com/wiki/cloud-shell/tag/'

# tag 1.0 msg   => add 1.0
# tag del 1.0   => delete 1.0

P1=$1
P2=$2

git_add() {
	tag=$1
	msg=$2
	if [ "$tag" = "" ];then
		echo '请输入「tag 版本号 描述」来发布版本:'
		return
	fi
	if [ "$msg" = "" ];then
		msg="release: ${tag}"
	fi

	git pull
	git add --all
	git commit -m "${msg}"
	git push origin &&
	git tag ${tag}
	git push origin ${tag} &&
  printf "\n\n> \033[32m%s\033[0m\n" 'Congratulations!' ||
  printf "\n\n> \033[31m%s\033[0m\n" 'Operation failed.'

}

git_del() {
	tag=$1
	if [ "$tag" = "" ];then
		echo '请输入「tag del 版本号」来删除指定版本:'
		return
	fi
	git tag -d ${tag}
	git push origin :${tag}
}

check() {
	tag=''
	msg=''
	case $P1 in
		'')
			read -p "请输入 tag version: " tag
		;;
		'del')
			case $P2 in
				'') ;;
				*) tag=$P2 ;;
			esac
			git_del $tag
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
	git_add $tag $msg
}

case $P1 in
	'docs'|'help') open ${DOCS} ;;
	*) check ;;
esac
