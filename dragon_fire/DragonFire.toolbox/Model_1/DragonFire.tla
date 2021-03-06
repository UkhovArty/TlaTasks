----------------------------- MODULE DragonFire -----------------------------
EXTENDS Naturals, TLC

(* --algorithm DragonFire
variables firebreathing = 0, fireball = 0, c = 0

process thread = 1
variable tmp = 0
begin
A0: while TRUE do
A1:     await firebreathing = 0;
        firebreathing := firebreathing + 1;
A2:     skip;
        if (fireball > 0) then
            fireball := fireball - 1;
A4:         skip;
A5:         if fireball > 0 then
                fireball := fireball - 1;
A6:             if fireball > 0 then
                    fireball := fireball - 1;
C1:                 skip;
                end if;
            end if;
        end if;
A7: tmp := c - 1;
A8: c := tmp;
A9: tmp := c + 1;
A10:c := tmp;
A11:firebreathing := firebreathing - 1;
    end while;
end process;

process thread1 = 2
variable temp = 0
begin
B0: while TRUE do
        if c < 2 then
B3:         fireball := fireball + 1;
B4:         temp := c + 1;
B5:         c := temp;
        else
C2:         temp :=0;
            skip;
        end if;
    end while;
end process;
end algorithm *)
\* BEGIN TRANSLATION
VARIABLES firebreathing, fireball, c, pc, tmp, temp

vars == << firebreathing, fireball, c, pc, tmp, temp >>

ProcSet == {1} \cup {2}

Init == (* Global variables *)
        /\ firebreathing = 0
        /\ fireball = 0
        /\ c = 0
        (* Process thread *)
        /\ tmp = 0
        (* Process thread1 *)
        /\ temp = 0
        /\ pc = [self \in ProcSet |-> CASE self = 1 -> "A0"
                                        [] self = 2 -> "B0"]

A0 == /\ pc[1] = "A0"
      /\ pc' = [pc EXCEPT ![1] = "A1"]
      /\ UNCHANGED << firebreathing, fireball, c, tmp, temp >>

A1 == /\ pc[1] = "A1"
      /\ firebreathing = 0
      /\ firebreathing' = firebreathing + 1
      /\ pc' = [pc EXCEPT ![1] = "A2"]
      /\ UNCHANGED << fireball, c, tmp, temp >>

A2 == /\ pc[1] = "A2"
      /\ TRUE
      /\ IF (fireball > 0)
            THEN /\ fireball' = fireball - 1
                 /\ pc' = [pc EXCEPT ![1] = "A4"]
            ELSE /\ pc' = [pc EXCEPT ![1] = "A7"]
                 /\ UNCHANGED fireball
      /\ UNCHANGED << firebreathing, c, tmp, temp >>

A4 == /\ pc[1] = "A4"
      /\ TRUE
      /\ pc' = [pc EXCEPT ![1] = "A5"]
      /\ UNCHANGED << firebreathing, fireball, c, tmp, temp >>

A5 == /\ pc[1] = "A5"
      /\ IF fireball > 0
            THEN /\ fireball' = fireball - 1
                 /\ pc' = [pc EXCEPT ![1] = "A6"]
            ELSE /\ pc' = [pc EXCEPT ![1] = "A7"]
                 /\ UNCHANGED fireball
      /\ UNCHANGED << firebreathing, c, tmp, temp >>

A6 == /\ pc[1] = "A6"
      /\ IF fireball > 0
            THEN /\ fireball' = fireball - 1
                 /\ pc' = [pc EXCEPT ![1] = "C1"]
            ELSE /\ pc' = [pc EXCEPT ![1] = "A7"]
                 /\ UNCHANGED fireball
      /\ UNCHANGED << firebreathing, c, tmp, temp >>

C1 == /\ pc[1] = "C1"
      /\ TRUE
      /\ pc' = [pc EXCEPT ![1] = "A7"]
      /\ UNCHANGED << firebreathing, fireball, c, tmp, temp >>

A7 == /\ pc[1] = "A7"
      /\ tmp' = c - 1
      /\ pc' = [pc EXCEPT ![1] = "A8"]
      /\ UNCHANGED << firebreathing, fireball, c, temp >>

A8 == /\ pc[1] = "A8"
      /\ c' = tmp
      /\ pc' = [pc EXCEPT ![1] = "A9"]
      /\ UNCHANGED << firebreathing, fireball, tmp, temp >>

A9 == /\ pc[1] = "A9"
      /\ tmp' = c + 1
      /\ pc' = [pc EXCEPT ![1] = "A10"]
      /\ UNCHANGED << firebreathing, fireball, c, temp >>

A10 == /\ pc[1] = "A10"
       /\ c' = tmp
       /\ pc' = [pc EXCEPT ![1] = "A11"]
       /\ UNCHANGED << firebreathing, fireball, tmp, temp >>

A11 == /\ pc[1] = "A11"
       /\ firebreathing' = firebreathing - 1
       /\ pc' = [pc EXCEPT ![1] = "A0"]
       /\ UNCHANGED << fireball, c, tmp, temp >>

thread == A0 \/ A1 \/ A2 \/ A4 \/ A5 \/ A6 \/ C1 \/ A7 \/ A8 \/ A9 \/ A10
             \/ A11

B0 == /\ pc[2] = "B0"
      /\ IF c < 2
            THEN /\ pc' = [pc EXCEPT ![2] = "B3"]
            ELSE /\ pc' = [pc EXCEPT ![2] = "C2"]
      /\ UNCHANGED << firebreathing, fireball, c, tmp, temp >>

B3 == /\ pc[2] = "B3"
      /\ fireball' = fireball + 1
      /\ pc' = [pc EXCEPT ![2] = "B4"]
      /\ UNCHANGED << firebreathing, c, tmp, temp >>

B4 == /\ pc[2] = "B4"
      /\ temp' = c + 1
      /\ pc' = [pc EXCEPT ![2] = "B5"]
      /\ UNCHANGED << firebreathing, fireball, c, tmp >>

B5 == /\ pc[2] = "B5"
      /\ c' = temp
      /\ pc' = [pc EXCEPT ![2] = "B0"]
      /\ UNCHANGED << firebreathing, fireball, tmp, temp >>

C2 == /\ pc[2] = "C2"
      /\ temp' = 0
      /\ TRUE
      /\ pc' = [pc EXCEPT ![2] = "B0"]
      /\ UNCHANGED << firebreathing, fireball, c, tmp >>

thread1 == B0 \/ B3 \/ B4 \/ B5 \/ C2

Next == thread \/ thread1

Spec == Init /\ [][Next]_vars

\* END TRANSLATION
CriticalSections == {pc[1],pc[2]} /= {"C1", "C2"}
=============================================================================
\* Modification History
\* Last modified Thu Jan 07 13:29:00 MSK 2021 by auhov
\* Created Sat Dec 12 17:34:25 MSK 2020 by auhov
