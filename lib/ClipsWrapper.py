import os
from subprocess import Popen, PIPE

class CLIPSError(Exception): pass
class InvalidMessage(Exception): pass

class CLIPS(object):
    def __init__(self, exe=None, prompt="CLIPS> ", maxread=1024):
        if not exe:
            if os.name == 'nt':
                exe = r"C:\Program Files (x86)\CLIPS\CLIPSDOS64.exe"
            else:
                exe = "clips"
        # setup vars
        self.exe = exe
        self.prompt = prompt
        self.maxread = maxread
        self.output = ""
        # start up clips
        self.startCLIPS()

    #Clean up after myself
    def __del__(self):
        self.exit()

    def startCLIPS(self):
        self.pipe = Popen([self.exe], stdin=PIPE, stdout=PIPE, bufsize=0)
        self.recv()

    def sendRecv(self, cmd):
        self.send(cmd)
        return self.recv()

    def send(self, cmd):
        if not self.validmessage(cmd):
            raise InvalidMessage
        writeBytes = (cmd + '\n').encode()
        self.pipe.stdin.write(writeBytes)

    def recv(self):
        # read until prompt
        self.output = ""
        # this loop is terrible
        while self.output.find(self.prompt) == -1:
            self.output += self.pipe.stdout.read(self.maxread).decode()
        pos = self.output.find(self.prompt)
        result = self.output[:pos]
        self.output = self.output[pos+len(self.prompt):]
        return result

    def defrule(self, name, lhs, rhs):
        o = self.sendRecv("(defrule " + name + lhs + " => " + rhs + ")")
        if o:
            raise CLIPSError

    def deffacts(self, name, *facts):
        o = self.sendRecv("(deffacts " + name + "\n".join(facts) + ")")
        if o:
            raise CLIPSError

    def assertFact(self, *facts):
        return self.sendRecv("(assert " + " ".join(facts) + ")")

    def assertFacts(self, facts):
        for i in range(len(facts)):
            if (isinstance(facts[i], dict)):
                for factName in facts[i]:
                    factString = [factName]
                    factString.append(self.createFactString(facts[i][factName]))
                    fact = "(" + " ".join(factString) + ")"
                    self.assertFact(fact)
            else:
                self.assertFact("(" + facts[i] + ")")

    #Recursively create fact string from object
    def createFactString(self, obj):
        returnString = []
        if (isinstance(obj, dict)):
            for key in obj:
                returnString.append("(" + key + " " + self.createFactString(obj[key]) + ")")
        elif (isinstance(obj, list)):
            for i in range(len(obj)):
                returnString.append(self.createFactString(obj[i]))
        else:
            #Adds single item as a string
            #Must be single slot, so joins spaces with -
            returnString.append("-".join(str(obj).split()))
        return " ".join(returnString)

    def clear(self):
        self.sendRecv("(clear)")

    def reset(self):
        self.sendRecv("(reset)")       

    def run(self):
        print(self.sendRecv("(run)"), end='')

    def facts(self):
        lines = self.sendRecv("(facts)").split("\n")[:-2]
        result = {}
        for line in lines:
            indexStr, fact = line.split(" ", 1)
            index = int(indexStr[2:])
            result[index] = self.parseFact(fact.strip())
        return result

    #Take a string and turn it into a native python objective
    def parseFact(self, factStr):
        #Group fact by paren groups
        levels = self.parens(factStr)
        fact = levels.pop().split()
        factName = fact.pop(0)
        #ordered fact
        if (len(levels) == 0):
            #Single slot
            if (len(fact) == 0):
                return factName
            #multislot
            else:
                return {factName: fact}
        #templated fact
        else: 
            factObj = {factName: []}
            for i in range(len(levels)):
                parts = levels[i].split()
                name = parts.pop(0)
                #Multislot
                if (len(parts) > 1):
                    factObj[factName].append({name: parts})
                #Single slot
                else:
                    factObj[factName].append({name: parts[0]})
            return factObj                   
    
    def parens(self, string):
        stack = []
        levels = []
        for i, c in enumerate(string):
            if c == '(':
                stack.append(i)
            elif c == ')' and stack:
                start = stack.pop()
                levels.append(string[start + 1: i])
        return levels

    def printFacts(self):
        print(self.sendRecv("(facts)"), end='')

    def agenda(self):
        # TODO make it good
        print(self.sendRecv("(agenda)"), end='')

    def exit(self):
        self.send('(exit)')

    def load(self, name):
        self.sendRecv('(load "' + name + '")')

    def validmessage(self, s):
        st = []
        quote = False
        idx = len(s)
        for i, c in enumerate(s):
            if c == '(':
                if not quote:
                    st.insert(0, c)
            elif c == ')':
                if not quote:
                    if not st:
                        return False
                    elif st[0] == '(':
                        st.pop()
                    else:
                        return False
            elif c == '"':
                quote = not quote
            elif c == ';' and not quote:
                idx = i
                break
        s = s[:idx] # strip comment
        return not(bool(st)) and not quote and bool(s.strip())
