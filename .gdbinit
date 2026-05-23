set disassembly-flavor intel
set print pretty on
set print array on
set print address on
set print demangle on
set confirm off

winheight cmd +10
lay src

set backtrace limit 20

handle SIGALRM ignore
handle SIGPIPE noignore
handle SIGUSR1 noprint

define dump_mem
    printf "Dumping %d units of memory at %p:\n", $arg1, $arg0
    x/$arg1$arg2 $arg0
end
document dump_mem
    Usage: dump_mem [address] [count] [format]
    Example: dump_mem buf 16 x (Dumps 16 hex bytes)
end

define check_null
    if $arg0 == 0
        printf "Variable %s is NULL\n", "$arg0"
    else
        print $arg0
    end
end

set tui border-kind ascii
set disassembly-flavor intel
set environment LSAN_OPTIONS detect_leaks=0
