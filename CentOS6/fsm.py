#!/usr/bin/env python
# -*- coding:utf-8 -*-

import pexpect
import sys  # for logfile

configure_lxr_responses = [
    (r'single/multiple trees.*>.* ', 'm\n'),
    (r'Tree designation.*>.* ', 'embedded\n'),
    (r'--- Host name or IP.*>.* ', 'http://192.168.170.64\n'),
    (r'Database engine.*>.* ', 'sqlite\n'),
    (r'--- Directory for glimpse.*>.* ', '/home/lxruser/local/share/glimpse\n'),
    (r'Is your Apache version 2.4.*>.* ', 'no\n'),
    (r'--- Tree designation for URL.*>.* ', 'nupic.core\n'),
    (r'--- Caption in page header.*>.* ', 'Nupic.core by Lxr\n'),
    (r'--- Source directory.*>.* ', '/home/lxruser/local/share/lxr/nupic.core\n'),
    (r'Label for version selection menu.*>.* ', 'TAG\n'),
    (r'--- Version name\?  .*>.* ', '2014-09-19\n'),
    (r'--- Version name\? \(hit return to stop.*>.* ', '\n'),
    (r'--- Database file.*>.* ', '/home/lxruser/local/share/lxr/lxr.db\n'),
    (r'Configure another tree.*>.* ', 'no\n'),
    (r'>.* ','\n')
]

def run(command, responses, logfile=None, cwd=None, verbose=False, **kwargs):

    # Create the finite state machine out of given responses.
    if responses is not None:
        fsm = {}
        state = None
        for t in responses:
            if len(t) == 2:
                i,o = t; s0 = s1 = 's0'
            elif len(t) == 3:
                s0,i,o = t; s1 = s0
            else:
                s0,i,o,s1 = t
            list_i,list_o,list_s1 = fsm.setdefault(s0, ([],[],[]))
            list_i.append(i)
            list_o.append(o)
            list_s1.append(s1)
            if state is None:
                state = s0
    else:
        # This assumes EOF or TIMEOUT will eventually cause run to terminate.
        fsm = { 's0':(None,None,'s0') }
        state = 's0'

    child = pexpect.spawn(command, maxread=2000, logfile=logfile, cwd=cwd, **kwargs)

    child_result_list = []
    event_count = 0
    while True:
        try:
            index = child.expect(fsm[state][0])
            if verbose:
                print "Rule%d:%s_%s_:%s"%(index,child.before,child.after,fsm[state][1][index])
                print "State: %s -> %s"%(state, fsm[state][2][index])
            if isinstance(child.after, basestring):
                child_result_list.append(child.before + child.after)
            else:
                # child.after may have been a TIMEOUT or EOF,
                # which we don't want appended to the list.
                child_result_list.append(child.before)
            child.send(fsm[state][1][index])
            state = fsm[state][2][index]
            event_count = event_count + 1
        except pexpect.TIMEOUT:
            child_result_list.append(child.before)
            break
        except pexpect.EOF:
            child_result_list.append(child.before)
            break
    child_result = ''.join(child_result_list)

    child.close()
    return (child_result, child.exitstatus)


def main():
    
    output,ret = run(command="/home/lxruser/lxr/scripts/configure-lxr.pl",
                     responses=,
                     cwd='/home/lxruser/lxr',
                     logfile=sys.stdout,  # in case we want to watch the on-going match.
                     verbose=True
                     )

    print "-------- output --------"
    print output
    print "-------- output --------"
    print "exit code:",ret

if __name__ == "__main__":
    main()
