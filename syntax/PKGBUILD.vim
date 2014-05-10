" Vim syntax file
" Language:     PKGBUILD
" Maintainer:   Alessio 'mOLOk' Bolognino <themolok at gmail.com>
" Last Change:  2007/05/08
" Version Info: PKGBUILD-0.2 (colorphobic)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

let b:main_syntax = "sh"
let b:is_bash = 1
runtime! syntax/sh.vim

" case on
syn case match

" pkgname
" FIXME if '=' is in pkgname/pkgver, it highlights whole string, not just '='
syn keyword pb_k_pkgname pkgname contained
syn match pbValidPkgname /\([[:alnum:]]\|+\|-\|_\){,32}/ contained contains=pbIllegalPkgname
syn match pbIllegalPkgname /[[:upper:]]\|[^[:alnum:]-+_=]\|=.*=\|=['"]\?.\{33,\}['"]\?/ contained
syn match pbPkgnameGroup /^pkgname=.*/ contains=pbIllegalPkgname,pb_k_pkgname,shDoubleQuote,shSingleQuote

" pkgbase
" FIXME if '=' is in pkgbase/pkgname/pkgver, it highlights whole string, not just '='
syn keyword pb_k_pkgbase pkgbase contained
syn match pbValidPkgbase /\([[:alnum:]]\|+\|-\|_\){,32}/ contained contains=pbIllegalPkgbase
syn match pbIllegalPkgbase /[[:upper:]]\|[^[:alnum:]-+_=]\|=.*=\|=['"]\?.\{33,\}['"]\?/ contained
syn match pbPkgbaseGroup /^pkgbase=.*/ contains=pbIllegalPkgbase,pb_k_pkgbase,shDoubleQuote,shSingleQuote

" pkgver
syn keyword pb_k_pkgver pkgver contained
syn match pbValidPkgver /\([[:alnum:]]\|\.\|+\|_\)/ contained contains=pbIllegalPkgver
syn match pbIllegalPkgver /[^[:alnum:]+=\.\_]\|=.*=/ contained
syn match pbPkgverGroup /^pkgver=.*/ contains=pbIllegalPkgver,pbValidPkgver,pb_k_pkgver,shDoubleQuote,shSingleQuote

" pkgrel
syn keyword pb_k_pkgrel pkgrel contained
syn match pbValidPkgrel /[[:digit:]]*/ contained contains=pbIllegalPkgrel
syn match pbIllegalPkgrel /[^[:digit:]=]\|=.*=/ contained
syn match pbPkgrelGroup /^pkgrel=.*/ contains=pbIllegalPkgrel,pbValidPkgrel,pb_k_pkgrel,shDoubleQuote,shSingleQuote

" pkgdesc
syn keyword pb_k_desc pkgdesc contained
" 90 chars: 80 for description, 8 for pkgdesc and 2 for ''
syn match pbIllegalPkgdesc /.\{90,}\|=['"]\?.*['" ]\+[iI][sS] [aA]/ contained contains=pbPkgdescSign
syn match pbValidPkgdesc /[^='"]\.\{,80}/ contained contains=pbIllegalPkgdesc
syn match pbPkgdescGroup /^pkgdesc=.*/ contains=pbIllegalPkgdesc,pb_k_desc,pbValidPkgdesc,shDoubleQuote,shSingleQuote
syn match pbPkgdescSign /[='"]/ contained

" epoch
syn keyword pb_k_epoch epoch contained
syn match pbValidEpoch /[[:digit:]]*/ contained contains=pbIllegalEpoch
syn match pbIllegalEpoch /[^[:digit:]=]\|=.*=/ contained
syn match pbEpochGroup /^epoch=.*/ contains=pbIllegalEpoch,pbValidEpoch,pb_k_epoch,shDoubleQuote,shSingleQuote

" url
syn keyword pb_k_url url contained
syn match pbValidUrl /['"]*\(https\|http\|ftp\)\:\/.*\.\+.*/ contained

syn match pbIllegalUrl /[^=]/ contained contains=pbValidUrl
syn match pbUrlGroup /^url=.*/ contains=pbValidUrl,pb_k_url,pbIllegalUrl,shDoubleQuote,shSingleQuote

" license
syn keyword pb_k_license license contained
" echo $(pacman -Ql licenses | grep '/usr/share/licenses/common/' | cut -d'/' -f6 | sort -u)
syn keyword pbLicense  AGPL AGPL3 Apache APACHE Artistic2.0 CCPL CDDL CPL EPL FDL FDL1.2 FDL1.3 GPL GPL2 GPL3 LGPL LGPL2.1 LGPL3 LPPL MPL PerlArtistic PHP PSF RUBY W3C ZPL contained
" special cases from https://wiki.archlinux.org/index.php/Arch_Packaging_Standards
syn keyword pbLicenseSpecial  BSD MIT ZLIB Python contained
syn match pbLicenseCustom /custom\(:[[:alnum:]]*\)*/ contained
syn match pbIllegalLicense /[^='"() ]/ contained contains=pbLicenseCustom,pbLicenseSpecial,pbLicense
syn region pbLicenseGroup start=/^license=(/ end=/)/ contains=pb_k_license,pbLicenseCustom,pbLicenseSpecial,pbLicense,pbIllegalLicense

" backup
syn keyword pb_k_backup backup contained
syn match pbValidBackup   /\.\?[[:alpha:]]*\/[[:alnum:]\{\}+._$-]*]*/ contained
syn region pbBackupGroup start=/^backup=(/ end=/)/ contains=pb_k_backup,pbValidBackup,shDoubleQuote,shSingleQuote

" arch
syn keyword pb_k_arch arch contained
syn keyword pbArch i686 x86_64 ppc any contained
syn match pbIllegalArch /[^='"() ]/ contained contains=pbArch
syn region pbArchGroup start=/^arch=(/ end=/)/ contains=pb_k_arch,pbArch,pbIllegalArch

" groups
syn keyword pb_k_groups groups contained
syn match pbValidGroups /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbGroupsGroup start=/^groups=(/ end=/)/ contains=pb_k_groups,pbValidGroups,shDoubleQuote,shSingleQuote

" depends
syn keyword pb_k_depends depends contained
syn match pbValidDepends /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbDependsGroup start=/^depends=(/ end=/)/ contains=pb_k_depends,pbValidDepends,shDoubleQuote,shSingleQuote

" makedepends
syn keyword pb_k_makedepends makedepends contained
syn match pbValidMakedepends /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbMakedependsGroup start=/^makedepends=(/ end=/)/ contains=pb_k_makedepends,pbValidMakedepends,shDoubleQuote,shSingleQuote

" optdepends
syn keyword pb_k_optdepends optdepends contained
syn match pbValidOptdepends /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbOptdependsGroup start=/^optdepends=(/ end=/)/ contains=pb_k_optdepends,pbValidOptdepends,shDoubleQuote,shSingleQuote

" checkdepends
syn keyword pb_k_ckdepends checkdepends contained
syn match pbValidCkdepends /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbCkdependsGroup start=/^checkdepends=(/ end=/)/ contains=pb_k_ckdepends,pbValidCkdepends,shDoubleQuote,shSingleQuote

" conflicts
syn keyword pb_k_conflicts conflicts contained
syn match pbValidConflicts /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbConflictsGroup start=/^conflicts=(/ end=/)/ contains=pb_k_conflicts,pbValidConflicts,shDoubleQuote,shSingleQuote

" provides
syn keyword pb_k_provides provides contained
syn match pbValidProvides /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbProvidesGroup start=/^provides=(/ end=/)/ contains=pb_k_provides,pbValidProvides,shDoubleQuote,shSingleQuote

" replaces
syn keyword pb_k_replaces replaces contained
syn match pbValidReplaces /\([[:alnum:]]\|+\|-\|_\)*/ contained
syn region pbReplacesGroup start=/^replaces=(/  end=/)/ contains=pb_k_replaces,pbValidReplaces,shDoubleQuote,shSingleQuote

" install
" XXX remove install from bashStatement, fix strange bug
syn clear bashStatement
syn keyword bashStatement chmod clear complete du egrep expr fgrep find gnufind gnugrep grep less ls mkdir mv rm rmdir rpm sed sleep sort strip tail touch

syn keyword pb_k_install install contained
syn match pbValidInstall /\([[:alnum:]]\|\$\|+\|-\|_\)*\.install/ contained
syn match pbIllegalInstall /[^=]/ contained contains=pbValidInstall
syn match pbInstallGroup /^install=.*/ contains=pb_k_install,pbValidInstall,pbIllegalInstall,shDeref,shDoubleQuote,shSingleQuote

" changelog
syn keyword pb_k_changelog changelog contained
syn match pbValidChangelog /\([[:alnum:]]\|\$\|+\|-\|_\)*/ contained
syn match pbIllegalChangelog /[^=]/ contained contains=pbValidChangelog
syn match pbChangelogGroup /^changelog=.*/ contains=pb_k_changelog,pbValidChangelog,pbIllegalChangelog,shDeref,shDoubleQuote,shSingleQuote

" source:
" XXX remove source from shStatement, fix strange bug
syn clear shStatement
syn keyword shStatement xxx wait getopts return autoload whence printf true popd nohup enable r trap readonly fc fg kill ulimit umask disown stop pushd read history logout times local exit test pwd time eval integer suspend dirs shopt hash false newgrp bg print jobs continue functions exec help cd break unalias chdir type shift builtin let bind

syn keyword pb_k_source source contained
syn match pbIllegalSource /\(http\|ftp\|https\).*\.\+\(dl\|download.\?\)\.\(sourceforge\|sf\).net/
syn region pbSourceGroup  start=/^source=(/ end=/)/ contains=pb_k_source,pbIllegalSource,shNumber,shDoubleQuote,shSingleQuote,pbDerefEmulation
syn match pbDerefEmulation /\$[{]\?[[:alnum:]_]*[}]\?/ contained
hi def link pbDerefEmulation PreProc

" md5sums
syn keyword pb_k_md5sums md5sums contained
syn match pbIllegalMd5sums /[^='"()\/ ]/ contained contains=pbValidMd5sums
syn match pbValidMd5sums /\x\{32\}/ contained
syn region pbMd5sumsGroup start=/^md5sums/ end=/)/ contains=pb_k_md5sums,pbMd5Quotes,pbMd5Hash,pbIllegalMd5sums keepend
syn match pbMd5Quotes /'.*'\|".*"/ contained contains=pbMd5Hash,pbIllegalMd5sums
syn match pbMd5Hash /\x\+/ contained contains=pbValidMd5sums
hi def link pbMd5Quotes Keyword
hi def link pbMd5Hash Error
hi def link pbValidMd5sums  Number

" sha1sums
syn keyword pb_k_sha1sums sha1sums contained
syn match pbIllegalSha1sums /[^='"()\/ ]/ contained contains=pbValidSha1sums
syn match pbValidSha1sums /\x\{40\}/ contained
syn region pbSha1sumsGroup start=/^sha1sums/ end=/)/ contains=pb_k_sha1sums,pbSha1Quotes,pbSha1Hash,pbIllegalSha1sums keepend
syn match pbSha1Quotes /'.*'\|".*"/ contained contains=pbSha1Hash,pbIllegalSha1sums
syn match pbSha1Hash /\x\+/ contained contains=pbValidSha1sums
hi def link pbSha1Quotes Keyword
hi def link pbSha1Hash Error
hi def link pbValidSha1sums  Number

" sha256sums
syn keyword pb_k_sha256sums sha256sums contained
syn match pbIllegalSha256sums /[^='"()\/ ]/ contained contains=pbValidSha256sums
syn match pbValidSha256sums /\x\{64\}/ contained
syn region pbSha256sumsGroup start=/^sha256sums/ end=/)/ contains=pb_k_sha256sums,pbSha256Quotes,pbSha256Hash,pbIllegalSha256sums keepend
syn match pbSha256Quotes /'.*'\|".*"/ contained contains=pbSha256Hash,pbIllegalSha256sums
syn match pbSha256Hash /\x\+/ contained contains=pbValidSha256sums
hi def link pbSha256Quotes Keyword
hi def link pbSha256Hash Error
hi def link pbValidSha256sums  Number

" sha384sums
syn keyword pb_k_sha384sums sha384sums contained
syn match pbIllegalSha384sums /[^='"()\/ ]/ contained contains=pbValidSha384sums
syn match pbValidSha384sums /\x\{96\}/ contained
syn region pbSha384sumsGroup start=/^sha384sums/ end=/)/ contains=pb_k_sha384sums,pbSha384Quotes,pbSha384Hash,pbIllegalSha384sums keepend
syn match pbSha384Quotes /'.*'\|".*"/ contained contains=pbSha384Hash,pbIllegalSha384sums
syn match pbSha384Hash /\x\+/ contained contains=pbValidSha384sums
hi def link pbSha384Quotes Keyword
hi def link pbSha384Hash Error
hi def link pbValidSha384sums  Number

" sha512sums
syn keyword pb_k_sha512sums sha512sums contained
syn match pbIllegalSha512sums /[^='"()\/ ]/ contained contains=pbValidSha512sums
syn match pbValidSha512sums /\x\{128\}/ contained
syn region pbSha512sumsGroup start=/^sha512sums/ end=/)/ contains=pb_k_sha512sums,pbSha512Quotes,pbSha512Hash,pbIllegalSha512sums keepend
syn match pbSha512Quotes /'.*'\|".*"/ contained contains=pbSha512Hash,pbIllegalSha512sums
syn match pbSha512Hash /\x\+/ contained contains=pbValidSha512sums
hi def link pbSha512Quotes Keyword
hi def link pbSha512Hash Error
hi def link pbValidSha512sums  Number

" options
syn keyword pb_k_options options contained
syn match pbOptions /\(no\)\?\(strip\|docs\|libtool\|emptydirs\|zipman\|purge\|upx\|fakeroot\|distcc\|color\|ccache\|check\|sign\|makeflags\|buildflags\)/ contained
syn match   pbOptionsNeg     /\!/ contained
syn match   pbOptionsDeprec  /no/ contained
syn region pbOptionsGroup start=/^options=(/ end=/)/ contains=pb_k_options,pbOptions,pbOptionsNeg,pbOptionsDeprec,pbIllegalOption
syn match pbIllegalOption /[^!"'()= ]/ contained contains=pbOptionsDeprec,pbOptions

" noextract
syn match pbNoextract /[[:alnum:]+._${}-]\+/ contained
syn keyword pb_k_noextract noextract  contained
syn region pbNoextractGroup  start=/^noextract=(/ end=/)/ contains=pb_k_noextract,pbNoextract,shDoubleQuote,shSingleQuote

" comments
syn keyword    pb_k_maintainer Maintainer Contributor contained
syn match      pbMaintainerGroup /Maintainer.*/ contains=pbMaintainer contained

syn match pbDate /[0-9]\{4}\/[0-9]\{2}\/[0-9]\{2}/ contained

syn cluster    pbCommentGroup	contains=pbTodo,pb_k_maintainer,pbMaintainerGroup,pbDate
syn keyword    pbTodo	contained	COMBAK FIXME TODO XXX
syn match      pbComment	"^#.*$"	contains=@pbCommentGroup
syn match      pbComment	"[^0-9]#.*$"	contains=@pbCommentGroup

" quotes are handled by sh.vim

hi def link pbComment Comment
hi def link pbTodo Todo

hi def link pbIllegalPkgname Error
hi def link pb_k_pkgname pbKeywords

hi def link pbIllegalPkgbase Error
hi def link pb_k_pkgbase pbKeywords

hi def link pbIllegalPkgver Error
hi def link pb_k_pkgver pbKeywords

hi def link pbIllegalPkgrel Error
hi def link pb_k_pkgrel pbKeywords

hi def link pbIllegalPkgdesc Error
hi def link pb_k_desc pbKeywords

hi def link pbIllegalEpoch Error
hi def link pb_k_epoch pbKeywords

hi def link pbIllegalUrl Error
hi def link pb_k_url pbKeywords

hi def link pb_k_license pbKeywords
hi def link pbIllegalLicense Error

hi def link pb_k_backup pbKeywords

hi def link pb_k_arch pbKeywords
hi def link pbIllegalArch Error

hi def link pb_k_groups pbKeywords
hi def link pb_k_makedepends pbKeywords
hi def link pb_k_optdepends pbKeywords
hi def link pb_k_ckdepends pbKeywords
hi def link pb_k_depends pbKeywords
hi def link pb_k_replaces pbKeywords
hi def link pb_k_conflicts pbKeywords
hi def link pb_k_provides pbKeywords

hi def link pbIllegalInstall Error
hi def link pb_k_install pbKeywords

hi def link pbIllegalChangelog Error
hi def link pb_k_changelog pbKeywords

hi def link pb_k_source pbKeywords
hi def link pbIllegalSource Error

hi def link pb_k_md5sums pbKeywords
hi def link pbIllegalMd5sums Error

hi def link pb_k_sha1sums pbKeywords
hi def link pbIllegalSha1sums Error

hi def link pb_k_sha256sums pbKeywords
hi def link pbIllegalSha256sums Error

hi def link pb_k_sha384sums pbKeywords
hi def link pbIllegalSha384sums Error

hi def link pb_k_sha512sums pbKeywords
hi def link pbIllegalSha512sums Error

hi def link pb_k_options pbKeywords
hi def link pbOptionsDeprec Todo
hi def link pbIllegalOption Error

hi def link pb_k_noextract pbKeywords
hi def link pbNoextract Normal

hi def link pb_k_maintainer pbKeywords

hi def link pbKeywords Keyword

hi def link pbDate Special

"syntax include @SHELL syntax/sh.vim
"syntax region BUILD start=/^build()/ end=/^}/ contains=@SHELL
"let b:current_syntax = "PKGBUILD"

" vim: ft=vim
