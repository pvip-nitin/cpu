
import sys
import re



def c_compile(inp):
    src = open(inp, "r")
    for lin in src:
        rg = re.search("unsigned\s+short\s+([a-zA-Z_0-9]+)(,[a-zA-Z_0-9]+)*;\s*", lin)
    src.close()

def opcod(f):
    if  (f == "ADD"):
        return("0")
    elif(f == "SUB"):
        return("1")
    elif(f == "MUL"):
        return("2")
    elif(f == "DIV"):
        return("3")
    elif(f == "XOR"):
        return("4")
    elif(f == "AND"):
        return("5")
    elif(f == "OR"):
        return("6")
    elif(f == "BE"):
        return("7")
    elif(f == "BG"):
        return("8")
    elif(f == "BL"):
        return("9")
    elif(f == "BGE"):
        return("A")
    elif(f == "BLE"):
        return("B")
    else:
        sys.exit()

def hexn(d):
    temp = "0x%01X" % d
    return(temp.replace("0x",""))

def hex2(d):
    temp = "0x%02X" % d
    return(temp.replace("0x",""))

def hex3(d):
    temp = "0x%03X" % d
    return(temp.replace("0x",""))

def hex4(d):
    temp = "0x%04X" % d
    return(temp.replace("0x",""))

def asm_compile(inp):
    src = open(inp, "r")
    inp = re.sub("(.*\/)|(\.(s|S)$)","",inp)
    sbin = open(inp+".hex", "w")
    sdis = open(inp+".dis", "w")
    data = open(inp+".data.sv", "w")
    pc = 0
    for lin in src:
        lin = re.sub("\n", "", lin)
        if(re.search("^$",lin) == None):
            no_argss = 0
            rg = re.search("(ADD|SUB|MUL|DIV|XOR|AND|OR|BE|BG|BL|BGE|BLE)\s+x(1[0-5]|[0-9])\s*,\s*x(1[0-5]|[0-9])\s*,\s*x(0?[0-9]|1[0-5])\s*",lin)
            if(rg != None):
                f = opcod(rg.group(1))
                rd  = re.sub("^0x","", str(hexn(int(rg.group(2)))))
                rs1 = re.sub("^0x","", str(hexn(int(rg.group(3)))))
                rs2 = re.sub("^0x","", str(hexn(int(rg.group(4)))))
                argss = f+rd+rs1+rs2
            else:
                rg = re.search("JUMP\s+([0-9]+)", lin)
                if(rg != None):
                    f = "C"
                    addr = hex3(int(rg.group(1)))
                    argss = f+addr
                else:
                    rg = re.search("(LD|LA)\s+x(1[0-5]|[0-9])\s*,\s*([0-9]+)",lin)
                    if(rg != None):
                        if(rg.group(1) == "LA"):
                            f = "D"
                        else:
                            f = "E"
                        dst = hexn(int(rg.group(2)))
                        addr = hex2(int(rg.group(3)))
                        argss = f+dst+addr
                    else:
                        rg = re.search("ST\s+([0-9]+)\s*,\s*x(1[0-5]|[0-9])",lin)
                        if(rg != None):
                            f = "F"
                            addr = hex2(int(rg.group(1)))
                            srg = hexn(int(rg.group(2)))
                            argss = f+addr+srg
                        else:
                            rg = re.search("\.mem\s+([0-9A-F]{4})\s+([0-9]+)", lin)
                            if(rg != None):
                                data.write("\t\tmem[16'h{}] <= 16'h{};\n".format(rg.group(1), rg.group(2)))
                                no_argss = 1
            if(no_argss != 1):
                sbin.write(argss+"\n")
                tmp_str = str(hex4(pc))
                pc = pc + 1
                bin_str = "{}:  {}".format(tmp_str, argss)
                sdis.write(bin_str+"    #"+lin+"\n")
    src.close()
    sbin.close()
    sdis.close()
    data.close()

src_file = sys.argv[1]

if(re.search("\.(c|C)$", src_file) != None):
    c_compile(src_file)
elif(re.search("\.(s|S)$", src_file) != None):
    asm_compile(src_file)
