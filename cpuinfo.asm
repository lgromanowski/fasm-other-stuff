format ELF executable 3
entry _
segment readable writeable executable
_:
    mov eax, 80000000h
    cpuid
    cmp eax, 80000004h
    jb exit

    mov edi, cpuname

    mov eax, 80000002h
    call get_cpu_name_part

    mov eax, 80000003h
    call get_cpu_name_part

    mov eax, 80000004h
    call get_cpu_name_part

    mov ecx, cpuname
    mov edx, cpuname_size
    call print

    mov eax, 1
    cpuid
    shl ecx, 1
    jnc exit

vm:
    mov eax, 40000000h
    cpuid

    mov edi, hypervisor
    call save_cpuid_string2

    mov ecx, hypervisor
    mov edx, hypervisor_size
    call print

    jmp  exit

get_cpu_name_part:
    cpuid
    call save_cpuid_string
    ret

print:
    mov ebx, 1
    mov eax, 4
    int 80h
    ret

exit:
    mov eax, 1
    int 80h

save_cpuid_string:
    stosd

save_cpuid_string2:
    mov eax, ebx
    stosd
    mov eax, ecx
    stosd
    mov eax, edx
    stosd
    ret

cpuname rb 48
        db 0x0A
cpuname_size = $ - cpuname

hypervisor rb 12
           db 0x0A
hypervisor_size = $ - hypervisor