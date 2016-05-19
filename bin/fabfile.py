from fabric.api import *
from fabric.operations import *

def errorcheck():
    with cd('/fds/var/logs'):
        out = run("egrep '\[warning\]|\[error\]' $(ls -alt dm* | head -n 1 | awk '{print $9}')");

def toplogcheck(f='dm*', pattern='\[warning\]|\[error\]'):
    with cd('/fds/var/logs'):
        cmd = "egrep '{}' $(ls -alt {} | head -n 1 | awk '{{print $9}}')".format(pattern, f)
        out = run(cmd)

def dmtail(what="normal"):
    env.remote_interrupt = True
    with cd('/fds/var/logs'):
        cmd = "tail -F dm.log_{0..1000} | egrep '\[normal\]|\[warning\]|\[error\]'"
        out = run(cmd)

def putfile(src, dst):
   put(src, dst)

def getfile(src, dst):
   get(src, dst)

def test():
    sudo("echo hello")

def untarcoroner(f):
    paths = run("find /home/share -name '{}*' 2> /dev/null | egrep 'tar.gz'".format(f))
    paths = paths.split('\n')
    for p in paths: 
        parent = os.path.dirname(p)
        basedir = p.split('.')[0]
        with cd(parent):
            run("tar xvzf {}".format(p))
            with cd(basedir):
                with cd("fds"):
                    run("tar xvzf {}".format("var.tar.gz"))
                    run("tar xvzf {}".format("bin.tar.gz"))

def exec_remote_cmd(cmd):
    with hide('output','running','warnings'), settings(warn_only=True):
            return run(cmd)

def whereissvc(svcuuid):
    cmd = "grep -l setupSvcInfo_.*{} /fds/var/log/*log_0.log".format(svcuuid)
    result = exec_remote_cmd(cmd)
    if result.return_code == 0:
        print "Found files: {}".format(result)


def corecheck():
    """
    Looks for cores in fabric hosts
    """
    locations = ["/fds/var/log/corefiles", "/corefiles", "/fds/bin"]
    for loc in locations:
        cmd = "ls {}/ | grep core".format(loc)
        result = exec_remote_cmd(cmd)
        if result.return_code == 0:
            print "Found cores: {} at: {}".format(result, loc)
