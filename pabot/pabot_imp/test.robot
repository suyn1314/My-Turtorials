*** Settings ***
Library    pabot.PabotLib
  
*** Test Case ***
Testing PabotLib
    Acquire Lock   MyLock
    Log   This part is critical section
    Release Lock   MyLock
    ${valuesetname} =    Acquire Value Set  admin-server
    ${host} =   Get Value From Set   host
    ${username} =     Get Value From Set   username
    ${password} =     Get Value From Set   password
    Log Many  ${host}  ${username}  ${password}
    Sleep   3s
    Release Value Set