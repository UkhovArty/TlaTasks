----------------------------- MODULE FilterLock -----------------------------
EXTENDS Integers, Naturals, TLC, Sequences
CONSTANT N
(*--algorithm FilterLock 

variables level = [e \in 1..N |-> 0], victim = [f \in 1..N |-> 0];

fair process proc \in 1..N
variable proc = 0, otherproc, i = 1
begin
A1: while TRUE do
A2:     while i /= N do
A0:         otherproc := 1..N \ {self};
A4:         level[self] := i;
A5:         victim[i] := self;
A6:         while otherproc # {} do
                with j \in otherproc do
                    proc := j;
                end with; 
                if (level[proc] >= i) /\ (victim[i] = self) then
A7:                 skip;
                else 
A8:                 otherproc := otherproc \ {proc};
                end if;
            end while;
A9:     i := i + 1;
        end while;
A10:    i := 1;        
cs:     skip;
UL: level[self] := 0;
    end while;
end process;        
end algorithm--*)
\* BEGIN TRANSLATION
\* Process proc at line 8 col 6 changed to proc_
CONSTANT defaultInitValue
VARIABLES level, victim, pc, proc, otherproc, i

vars == << level, victim, pc, proc, otherproc, i >>

ProcSet == (1..N)

Init == (* Global variables *)
        /\ level = [e \in 1..N |-> 0]
        /\ victim = [f \in 1..N |-> 0]
        (* Process proc_ *)
        /\ proc = [self \in 1..N |-> 0]
        /\ otherproc = [self \in 1..N |-> defaultInitValue]
        /\ i = [self \in 1..N |-> 1]
        /\ pc = [self \in ProcSet |-> "A1"]

A1(self) == /\ pc[self] = "A1"
            /\ pc' = [pc EXCEPT ![self] = "A2"]
            /\ UNCHANGED << level, victim, proc, otherproc, i >>

A2(self) == /\ pc[self] = "A2"
            /\ IF i[self] /= N
                  THEN /\ pc' = [pc EXCEPT ![self] = "A0"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "A10"]
            /\ UNCHANGED << level, victim, proc, otherproc, i >>

A0(self) == /\ pc[self] = "A0"
            /\ otherproc' = [otherproc EXCEPT ![self] = 1..N \ {self}]
            /\ pc' = [pc EXCEPT ![self] = "A4"]
            /\ UNCHANGED << level, victim, proc, i >>

A4(self) == /\ pc[self] = "A4"
            /\ level' = [level EXCEPT ![self] = i[self]]
            /\ pc' = [pc EXCEPT ![self] = "A5"]
            /\ UNCHANGED << victim, proc, otherproc, i >>

A5(self) == /\ pc[self] = "A5"
            /\ victim' = [victim EXCEPT ![i[self]] = self]
            /\ pc' = [pc EXCEPT ![self] = "A6"]
            /\ UNCHANGED << level, proc, otherproc, i >>

A6(self) == /\ pc[self] = "A6"
            /\ IF otherproc[self] # {}
                  THEN /\ \E j \in otherproc[self]:
                            proc' = [proc EXCEPT ![self] = j]
                       /\ IF (level[proc'[self]] >= i[self]) /\ (victim[i[self]] = self)
                             THEN /\ pc' = [pc EXCEPT ![self] = "A7"]
                             ELSE /\ pc' = [pc EXCEPT ![self] = "A8"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "A9"]
                       /\ proc' = proc
            /\ UNCHANGED << level, victim, otherproc, i >>

A7(self) == /\ pc[self] = "A7"
            /\ TRUE
            /\ pc' = [pc EXCEPT ![self] = "A6"]
            /\ UNCHANGED << level, victim, proc, otherproc, i >>

A8(self) == /\ pc[self] = "A8"
            /\ otherproc' = [otherproc EXCEPT ![self] = otherproc[self] \ {proc[self]}]
            /\ pc' = [pc EXCEPT ![self] = "A6"]
            /\ UNCHANGED << level, victim, proc, i >>

A9(self) == /\ pc[self] = "A9"
            /\ i' = [i EXCEPT ![self] = i[self] + 1]
            /\ pc' = [pc EXCEPT ![self] = "A2"]
            /\ UNCHANGED << level, victim, proc, otherproc >>

A10(self) == /\ pc[self] = "A10"
             /\ i' = [i EXCEPT ![self] = 1]
             /\ pc' = [pc EXCEPT ![self] = "cs"]
             /\ UNCHANGED << level, victim, proc, otherproc >>

cs(self) == /\ pc[self] = "cs"
            /\ TRUE
            /\ pc' = [pc EXCEPT ![self] = "UL"]
            /\ UNCHANGED << level, victim, proc, otherproc, i >>

UL(self) == /\ pc[self] = "UL"
            /\ level' = [level EXCEPT ![self] = 0]
            /\ pc' = [pc EXCEPT ![self] = "A1"]
            /\ UNCHANGED << victim, proc, otherproc, i >>

proc_(self) == A1(self) \/ A2(self) \/ A0(self) \/ A4(self) \/ A5(self)
                  \/ A6(self) \/ A7(self) \/ A8(self) \/ A9(self)
                  \/ A10(self) \/ cs(self) \/ UL(self)

Next == (\E self \in 1..N: proc_(self))

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in 1..N : WF_vars(proc_(self))

\* END TRANSLATION
StarvationFreedom == \A v \in 1..N : []<>(pc[v] = "cs")
CriticalSection == \A r,k \in 1..N : r /= k => {pc[r],pc[k]} /= {"cs","cs"}
=============================================================================
\* Modification History
\* Last modified Thu Jan 07 12:05:08 MSK 2021 by auhov
\* Created Tue Jan 05 22:47:52 MSK 2021 by auhov
