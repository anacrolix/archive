import msvcrt, os.path, shutil, subprocess, sys, zipfile

CXFREEZE = os.path.join(sys.prefix, "Scripts", "cxfreeze")
OUTDIR = "dist"

if os.path.exists(OUTDIR):
    print("Directory must be removed %r (y/n): " % OUTDIR, end='')
    sys.stdout.flush()
    if msvcrt.getch() != b'y': sys.exit()
    shutil.rmtree(OUTDIR, True)
subprocess.check_call([CXFREEZE, "--include-modules=tkinter._fix,prolepsis.dialogs,dbm.dumb", "prolepsis.py"], shell=True)
for a in ("tcl8.5", "tk8.5"):
    shutil.copytree(os.path.join(sys.prefix, "tcl", a), os.path.join(OUTDIR, a))
# E:\source\anacrolix\projects\prolepsis>c:\Python31\Scripts\cxfreeze --include-modules=tkinter._fix,prolepsis.dialogs,dbm.dumb prolepsis.py
# Scripts/{tcl,tk}8.5

if len(sys.argv) == 2:
    arcname = sys.argv[1] + ".zip"
    assert not os.path.exists(arcname)
    archive = zipfile.ZipFile(arcname, "w", zipfile.ZIP_DEFLATED)
    for root, dirs, files in os.walk(OUTDIR):
        for f in files:
            actualPath = os.path.join(root, f)
            memberPath = os.path.relpath(actualPath, OUTDIR)
            archive.write(actualPath, arcname=memberPath)
