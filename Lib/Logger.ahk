; log := new Logger("test.log")
; log.Debug("test")

class Logger
{
    __New(filename)
    {
        this.filename := filename
    }

    Debug(msg)
    {
        FileAppend, % A_Now . " " . msg . "`n", % this.filename
    }
}
