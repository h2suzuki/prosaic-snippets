#!/usr/bin/env python
# -*- coding:utf-8 -*-

import pexpect
#import sys  # for logfile

configure_lxr_responses = {
    r'single/multiple trees.*>.* ':'m\n',
    r'Tree designation.*>.* ':'embedded\n',
    r'--- Host name or IP.*>.* ':'http://192.168.170.64\n',
    r'Database engine.*>.* ':'sqlite\n',
    r'--- Directory for glimpse.*>.* ':'/home/lxruser/local/share/glimpse\n',
    r'Is your Apache version 2.4.*>.* ':'no\n',
    r'--- Tree designation for URL.*>.* ':'nupic.core\n',
    r'--- Caption in page header.*>.* ':'Nupic.core by Lxr\n',
    r'--- Source directory.*>.* ':'/home/lxruser/local/share/lxr/nupic.core\n',
    r'Label for version selection menu.*>.* ':'TAG\n',
    r'--- Version name\?  .*>.* ':'2014-09-19\n',
    r'--- Version name\? \(hit return to stop.*>.* ':'\n',
    r'--- Database file.*>.* ':'/home/lxruser/local/share/lxr/lxr.db\n',
    r'Configure another tree.*>.* ':'no\n',
    r'>.* ':'\n'
}

def main():
    output,ret = pexpect.run("/home/lxruser/lxr/scripts/configure-lxr.pl",
                     events=configure_lxr_responses,
                     withexitstatus=True,
                     cwd='/home/lxruser/lxr',
#                    logfile=sys.stdout
                     )

    print "-------- output --------"
    print output
    print "-------- output --------"
    print "exit code:",ret

if __name__ == "__main__":
    main()
