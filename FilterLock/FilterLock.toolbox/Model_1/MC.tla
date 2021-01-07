---- MODULE MC ----
EXTENDS FilterLock, TLC

\* CONSTANT definitions @modelParameterConstants:1N
const_1610012659351390000 == 
3
----

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_1610012659362391000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_1610012659373392000 ==
CriticalSection
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_1610012659383393000 ==
StarvationFreedom
----
=============================================================================
\* Modification History
\* Created Thu Jan 07 12:44:19 MSK 2021 by auhov
